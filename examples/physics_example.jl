# To run this example, you need to have the SoilScienceModel package installed.
# You can do this by running `using Pkg; Pkg.develop(path=".")` in the Julia REPL.

using SoilScienceModel.Physics
using DataFrames, Plots

# --- Example for soil_moisture_balance ---
println("--- Running Soil Moisture Balance Example ---")
precip = [10.0, 0.0, 5.0, 0.0, 0.0, 20.0, 2.0]
et = [2.0, 2.0, 2.0, 3.0, 3.0, 1.0, 1.5]
params_sm = Dict(:fc => 0.3, :wp => 0.1, :zr => 0.5, :initial_moisture => 0.2)
df_smb = soil_moisture_balance(precip, et, params_sm)
println("Soil Moisture Balance Results:")
println(df_smb)
println("-"^40)

# --- Example for green_ampt_infiltration ---
println("--- Running Green-Ampt Infiltration Example ---")
t = 3600.0 # 1 hour
Ks = 1e-5
psi = 0.15
theta_i = 0.2
theta_s = 0.4
F = green_ampt_infiltration(t, Ks, psi, theta_i, theta_s)
println("Cumulative infiltration after $(t/3600) hour(s): $(round(F*1000, digits=2)) mm")
println("-"^40)

# --- Example for soil_temperature_profile ---
println("--- Running Soil Temperature Profile Example ---")
initial_temp = 10.0
surface_temp_series = 15.0 .+ 5.0 .* sin.(2 * π .* (1:365) ./ 365) # Annual sine wave
thermal_diff = 2e-7
dt = 86400.0 # 1 day
dz = 0.1
n_nodes = 20 # 2 meters deep
T = soil_temperature_profile(initial_temp, surface_temp_series, thermal_diff, dt, dz, n_nodes)

println("Soil temperature simulation complete. Plotting results...")
depths = (0:(n_nodes-1)) .* dz
p = plot(T[:, 1], depths, ylims=(0, n_nodes*dz), xlims=(0,25), xlabel="Temperature (°C)", ylabel="Depth (m)", label="Day 1", title="Soil Temperature Profile")
plot!(p, T[:, 180], depths, label="Day 180")
plot!(p, T[:, 365], depths, label="Day 365")
savefig("examples/soil_temperature_profile.png")
println("Plot saved to examples/soil_temperature_profile.png")
println("-"^40)
