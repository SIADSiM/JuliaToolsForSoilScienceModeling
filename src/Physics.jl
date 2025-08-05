module Physics

using DataFrames, Roots

export soil_moisture_balance, green_ampt_infiltration, soil_temperature_profile

"""
    soil_moisture_balance(precip, et, params)::DataFrame

Calculates daily soil water balance using a simple bucket model approach, inspired by FAO-56.

This function tracks daily changes in soil moisture content based on precipitation,
evapotranspiration, and runoff.

### Arguments
- `precip`: Vector of daily precipitation (mm/day).
- `et`: Vector of daily potential evapotranspiration (mm/day).
- `params`: A Dictionary or NamedTuple containing soil parameters:
    - `fc`: Field capacity (m³/m³).
    - `wp`: Wilting point (m³/m³).
    - `zr`: Rooting depth (m).
    - `initial_moisture`: Initial soil moisture content (m³/m³).

### Returns
- A `DataFrame` with columns: `Day`, `Precipitation`, `ET`, `SoilMoisture`, `Runoff`.

### References
- Allen, R.G., Pereira, L.S., Raes, D., & Smith, M. (1998). Crop Evapotranspiration —
  Guidelines for computing crop water requirements. FAO Irrigation and Drainage Paper 56.
"""
function soil_moisture_balance(precip::AbstractVector, et::AbstractVector, params::Dict)
    n_days = length(precip)
    sm = zeros(n_days)
    runoff = zeros(n_days)

    # Initial soil moisture
    sm[1] = params[:initial_moisture] * params[:zr] * 1000 # in mm

    for t in 2:n_days
        sm_prev = sm[t-1]

        # Water input
        water_in = precip[t-1]

        # Available water capacity (AWC) in mm
        awc = (params[:fc] - params[:wp]) * params[:zr] * 1000

        # Update soil moisture
        sm_t = sm_prev + water_in - et[t-1]

        # Check for runoff
        if sm_t > params[:fc] * params[:zr] * 1000
            runoff[t] = sm_t - (params[:fc] * params[:zr] * 1000)
            sm_t = params[:fc] * params[:zr] * 1000
        end

        # Check for wilting point
        if sm_t < params[:wp] * params[:zr] * 1000
            sm_t = params[:wp] * params[:zr] * 1000
        end

        sm[t] = sm_t
    end

    df = DataFrame(
        Day = 1:n_days,
        Precipitation = precip,
        ET = et,
        SoilMoisture = sm ./ (params[:zr] * 1000), # as m³/m³
        Runoff = runoff
    )

    return df
end

"""
    green_ampt_infiltration(P, Ks, psi, theta_i, theta_s)

Calculates cumulative infiltration (F) after a given time (t) using the Green-Ampt model.
This implementation solves the implicit form of the Green-Ampt equation.

### Arguments
- `t`: Time duration of infiltration (s).
- `Ks`: Saturated hydraulic conductivity (m/s).
- `psi`: Wetting front soil suction head (m).
- `theta_i`: Initial soil moisture content (m³/m³).
- `theta_s`: Saturated soil moisture content (m³/m³).

### Returns
- `F`: Cumulative infiltration (m).

### References
- Green, W.H., & Ampt, G.A. (1911). Studies on soil physics. The Journal of Agricultural Science, 4(1), 1–24.
"""
function green_ampt_infiltration(t::Real, Ks::Real, psi::Real, theta_i::Real, theta_s::Real)
    delta_theta = theta_s - theta_i

    # Implicit Green-Ampt equation: F - psi * delta_theta * log(1 + F / (psi * delta_theta)) - Ks * t = 0
    # We need to find the root F of this equation.
    g(F) = F - psi * delta_theta * log(1 + F / (psi * delta_theta)) - Ks * t

    # Initial guess for F can be Ks*t (assuming rainfall rate is high)
    initial_guess = Ks * t

    # Find the root (cumulative infiltration F)
    F = find_zero(g, initial_guess)

    return F
end

"""
    soil_temperature_profile(initial_temp, thermal_diff, dt, dz, steps, n_nodes)

Simulates the 1D soil temperature profile over time using the heat conduction equation.

### Arguments
- `initial_temp`: Initial temperature at all soil depths (°C). Can be a scalar or a vector.
- `surface_temp_series`: A vector of surface temperatures for each time step (°C).
- `thermal_diff`: Soil thermal diffusivity (m²/s).
- `dt`: Time step (s).
- `dz`: Depth step (m).
- `n_nodes`: Number of depth nodes.

### Returns
- A matrix of soil temperatures (`n_nodes` x `length(surface_temp_series)`), where each column is the temperature profile at a time step.

### References
- Hillel, D. (1998). Environmental Soil Physics. Academic Press.
"""
function soil_temperature_profile(initial_temp::Union{Real, AbstractVector}, surface_temp_series::AbstractVector, thermal_diff::Real, dt::Real, dz::Real, n_nodes::Int)

    # Stability criterion
    alpha = thermal_diff * dt / dz^2
    if alpha > 0.5
        @warn "Stability criterion (alpha > 0.5) not met. Results may be unstable."
    end

    n_steps = length(surface_temp_series)
    T = zeros(n_nodes, n_steps)

    # Set initial conditions
    if initial_temp isa Real
        T[:, 1] .= initial_temp
    else
        T[:, 1] = initial_temp
    end

    for j in 1:(n_steps-1)
        # Set boundary condition at the surface
        T[1, j+1] = surface_temp_series[j]

        for i in 2:(n_nodes-1)
            # Finite difference equation (explicit forward-time, centered-space)
            T[i, j+1] = T[i, j] + alpha * (T[i+1, j] - 2*T[i, j] + T[i-1, j])
        end

        # Assume zero heat flux at the bottom boundary (insulated)
        T[n_nodes, j+1] = T[n_nodes-1, j+1]
    end

    return T
end


end # module Physics
