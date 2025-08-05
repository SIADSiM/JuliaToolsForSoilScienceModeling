module Erosion

export bulk_density_calc, soil_erosion_usle

"""
    bulk_density_calc(particle_density, porosity)

Calculates soil bulk density from particle density and porosity.

### Arguments
- `particle_density`: The density of the solid soil particles (kg/m³). A common value for mineral soils is 2650 kg/m³.
- `porosity`: The fraction of the soil volume occupied by pores (m³/m³).

### Returns
- `bulk_density`: The dry bulk density of the soil (kg/m³).

### References
- Hillel, D. (1998). Environmental Soil Physics. Academic Press.
"""
function bulk_density_calc(particle_density::Real, porosity::Union{Real, AbstractArray})
    return particle_density .* (1.0 .- porosity)
end

"""
    soil_erosion_usle(R, K, LS, C, P)

Estimates average annual soil loss (A) using the Universal Soil Loss Equation (USLE).

### Arguments
- `R`: Rainfall-runoff erosivity factor.
- `K`: Soil erodibility factor.
- `LS`: Topographic factor (slope length and steepness).
- `C`: Cover-management factor.
- `P`: Support practice factor.

### Returns
- `A`: Estimated average annual soil loss (e.g., in tons/acre/year or Mg/ha/year, depending on the units of the factors).

### References
- Wischmeier, W.H., & Smith, D.D. (1978). Predicting rainfall erosion losses. USDA Agriculture Handbook 537.
"""
function soil_erosion_usle(R::Real, K::Real, LS::Real, C::Real, P::Real)
    return R * K * LS * C * P
end

end # module Erosion
