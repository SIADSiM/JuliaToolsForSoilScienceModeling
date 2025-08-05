# To run this example, you need to have the SoilScienceModel package installed.

using SoilScienceModel.Hydrology
using Plots

# --- Example for penman_monteith_et ---
println("--- Running Penman-Monteith ET Example ---")
temp = 20.0
rh = 60.0
u2 = 2.0
Rn = 15.0
G = 2.0
params_et = Dict(:z => 100.0, :lat => 40.0)
ET0 = penman_monteith_et(temp, rh, u2, Rn, G, params_et)
println("Reference Evapotranspiration (ET₀): $(round(ET0, digits=2)) mm/day")
println("-"^40)


# --- Example for soil_water_retention_vg ---
println("--- Running van Genuchten Water Retention Example ---")
theta_r = 0.05
theta_s = 0.45
alpha = 0.14
n = 2.68
h_range = -10.0:0.1:-0.01 # Pressure head range

theta_curve = soil_water_retention_vg(theta_r, theta_s, alpha, n, h_range)

println("Plotting soil water retention curve...")
p = plot(h_range, theta_curve,
         xlabel="Pressure Head (m)",
         ylabel="Soil Water Content (m³/m³)",
         title="Soil Water Retention Curve (van Genuchten)",
         legend=false)
savefig("examples/soil_water_retention_curve.png")
println("Plot saved to examples/soil_water_retention_curve.png")
println("-"^40)
