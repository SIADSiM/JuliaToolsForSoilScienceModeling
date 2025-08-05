# To run this example, you need to have the SoilScienceModel package installed.

using SoilScienceModel.Erosion

# --- Example for bulk_density_calc ---
println("--- Running Bulk Density Calculation Example ---")
particle_density = 2650.0 # kg/m³
porosity = 0.5
bulk_density = bulk_density_calc(particle_density, porosity)
println("Soil with porosity $porosity has a bulk density of $bulk_density kg/m³.")
println("-"^40)

# --- Example for soil_erosion_usle ---
println("--- Running USLE Soil Erosion Example ---")
R = 120.0  # Rainfall erosivity factor
K = 0.35   # Soil erodibility factor
LS = 0.8   # Topographic factor
C = 0.2    # Cover-management factor
P = 1.0    # Support practice factor
soil_loss = soil_erosion_usle(R, K, LS, C, P)
println("Estimated annual soil loss (USLE): $soil_loss tons/acre/year (assuming US customary units for factors)")
println("-"^40)
