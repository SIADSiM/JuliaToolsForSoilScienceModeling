module Hydrology

export penman_monteith_et, soil_water_retention_vg

"""
    penman_monteith_et(temp, rh, u2, Rn, G, params)

Calculates reference evapotranspiration (ET₀) using the FAO-56 Penman-Monteith equation.

### Arguments
- `temp`: Mean daily air temperature (°C).
- `rh`: Mean daily relative humidity (%).
- `u2`: Mean daily wind speed at 2m height (m/s).
- `Rn`: Net radiation at the crop surface (MJ/m²/day).
- `G`: Soil heat flux density (MJ/m²/day).
- `params`: A Dictionary or NamedTuple containing site-specific parameters:
    - `z`: Elevation above sea level (m).
    - `lat`: Latitude (degrees).

### Returns
- `ET₀`: Reference evapotranspiration (mm/day).

### References
- Allen, R.G., Pereira, L.S., Raes, D., & Smith, M. (1998). Crop Evapotranspiration —
  Guidelines for computing crop water requirements. FAO Irrigation and Drainage Paper 56.
"""
function penman_monteith_et(temp::Real, rh::Real, u2::Real, Rn::Real, G::Real, params::Dict)
    # Constants
    P = 101.3 * ((293 - 0.0065 * params[:z]) / 293)^5.26 # Atmospheric pressure (kPa)
    lambda = 2.45 # Latent heat of vaporization (MJ/kg)
    gamma = 0.00163 * P / lambda # Psychrometric constant (kPa/°C)

    # Saturation vapor pressure (es)
    es = 0.6108 * exp((17.27 * temp) / (temp + 237.3))

    # Actual vapor pressure (ea)
    ea = (rh / 100) * es

    # Vapor pressure deficit (VPD)
    vpd = es - ea

    # Slope of the saturation vapor pressure curve (delta)
    delta = (4098 * es) / (temp + 237.3)^2

    # Numerator and denominator of the Penman-Monteith equation
    num = 0.408 * delta * (Rn - G) + gamma * (900 / (temp + 273)) * u2 * vpd
    den = delta + gamma * (1 + 0.34 * u2)

    ET0 = num / den

    return ET0
end

"""
    soil_water_retention_vg(theta_r, theta_s, alpha, n, h)

Calculates soil water content (θ) for a given pressure head (h) using the van Genuchten (1980) model.

### Arguments
- `theta_r`: Residual water content (m³/m³).
- `theta_s`: Saturated water content (m³/m³).
- `alpha`: van Genuchten parameter, related to the inverse of the air-entry pressure (1/m).
- `n`: van Genuchten parameter, a measure of the pore-size distribution.
- `h`: Soil water pressure head (m), typically negative for unsaturated conditions.

### Returns
- `theta`: Soil water content (m³/m³).

### References
- van Genuchten, M.T. (1980). A closed-form equation for predicting the hydraulic
  conductivity of unsaturated soils. Soil Science Society of America Journal, 44(5), 892–898.
"""
function soil_water_retention_vg(theta_r::Real, theta_s::Real, alpha::Real, n::Real, h::Union{Real, AbstractArray})
    m = 1 - 1/n
    # h is expected to be negative for unsaturated conditions, so we use abs(h)
    theta = theta_r + (theta_s - theta_r) ./ (1 .+ (alpha .* abs.(h)).^n).^m
    return theta
end


end # module Hydrology
