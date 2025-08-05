module Biogeochemistry

export nitrogen_mineralization, soil_respiration_q10, soil_carbon_decomposition

"""
    nitrogen_mineralization(temp, moisture, params)

Calculates the nitrogen mineralization rate based on temperature and moisture scalars
from the CENTURY model.

### Arguments
- `temp`: Soil temperature (°C).
- `moisture`: Soil moisture content (m³/m³).
- `params`: A Dictionary or NamedTuple containing model parameters:
    - `max_rate`: The maximum potential mineralization rate (e.g., kg N/ha/day).
    - `temp_params`: Parameters for the temperature scalar function.
    - `moisture_params`: Parameters for the moisture scalar function.

### Returns
- Mineralization rate (e.g., kg N/ha/day).

### References
- Parton, W.J., Schimel, D.S., Cole, C.V., & Ojima, D.S. (1987). Analysis of factors
  controlling soil organic matter levels in Great Plains grasslands. Soil Science
  Society of America Journal, 51(5), 1173–1179.
"""
function nitrogen_mineralization(temp::Real, moisture::Real, params::Dict)
    # Temperature scalar (based on CENTURY model)
    # This is a simplified representation. A more detailed implementation would be a bell-shaped curve.
    temp_scalar = (temp > 0 && temp < 35) ? (temp / 35.0) : 0.0

    # Moisture scalar (based on CENTURY model)
    # This is a simplified representation.
    moisture_scalar = (moisture > 0.1 && moisture < 0.5) ? (moisture / 0.5) : 0.0

    mineralization_rate = params[:max_rate] * temp_scalar * moisture_scalar

    return mineralization_rate
end

"""
    soil_respiration_q10(T, Rref, Q10)

Calculates soil respiration rate at a given temperature (T) using a Q10 temperature
sensitivity model.

### Arguments
- `T`: Soil temperature (°C).
- `Rref`: Respiration rate at the reference temperature (e.g., in μmol CO₂/m²/s).
- `Tref`: Reference temperature (°C), often 10°C or 20°C.
- `Q10`: The factor by which respiration rate increases for a 10°C rise in temperature.

### Returns
- Respiration rate at temperature T.

### References
- Lloyd, J., & Taylor, J.A. (1994). On the temperature dependence of soil respiration.
  Functional Ecology, 8(3), 315–323.
"""
function soil_respiration_q10(T::Union{Real, AbstractArray}, Rref::Real, Tref::Real, Q10::Real)
    return Rref .* Q10 .^ ((T .- Tref) ./ 10.0)
end

"""
    soil_carbon_decomposition(C0, k, temp, moisture)

Calculates the amount of soil organic carbon (SOC) remaining after one time step,
based on a first-order decomposition model with temperature and moisture modifiers.

### Arguments
- `C0`: Initial amount of soil organic carbon (e.g., kg C/ha).
- `k`: Intrinsic decomposition rate constant (e.g., per day).
- `temp`: Soil temperature (°C).
- `moisture`: Soil moisture content (m³/m³).

### Returns
- `C1`: Amount of SOC remaining after one time step (e.g., kg C/ha).

### References
- Based on first-order kinetics common in soil carbon models. Temperature and moisture
  scalars are conceptually similar to those in CENTURY (Parton et al., 1987).
"""
function soil_carbon_decomposition(C0::Real, k::Real, temp::Real, moisture::Real)
    # Using simplified scalars similar to nitrogen_mineralization
    temp_scalar = (temp > 0 && temp < 35) ? (temp / 35.0) : 0.0
    moisture_scalar = (moisture > 0.1 && moisture < 0.5) ? (moisture / 0.5) : 0.0

    # Effective decomposition rate
    k_eff = k * temp_scalar * moisture_scalar

    # First-order decay
    C1 = C0 * exp(-k_eff)

    return C1
end


end # module Biogeochemistry
