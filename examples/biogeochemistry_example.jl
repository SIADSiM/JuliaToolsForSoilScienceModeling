# To run this example, you need to have the SoilScienceModel package installed.

using SoilScienceModel.Biogeochemistry
using Plots

# --- Example for nitrogen_mineralization ---
println("--- Running Nitrogen Mineralization Example ---")
temp_nm = 25.0
moisture_nm = 0.3
params_nm = Dict(:max_rate => 1.0)
n_min_rate = nitrogen_mineralization(temp_nm, moisture_nm, params_nm)
println("Nitrogen mineralization rate: $(round(n_min_rate, digits=3)) kg N/ha/day (hypothetical units)")
println("-"^40)

# --- Example for soil_respiration_q10 ---
println("--- Running Q10 Soil Respiration Example ---")
T_resp = 15.0
Rref = 1.5
Tref = 10.0
Q10 = 2.0
resp_rate = soil_respiration_q10(T_resp, Rref, Tref, Q10)
println("Respiration rate at $T_resp°C: $(round(resp_rate, digits=2))")
println("-"^40)


# --- Example for soil_carbon_decomposition ---
println("--- Running SOC Decomposition Example ---")
C0 = 100.0 # Initial SOC (e.g., Mg C/ha)
k = 0.005 # Intrinsic decomposition rate (per day)
n_years = 10
n_days = n_years * 365
C_series = zeros(n_days)
C_series[1] = C0

# Simulate with constant temp and moisture for simplicity
temp_soc = 15.0
moisture_soc = 0.25

for day in 2:n_days
    C_series[day] = soil_carbon_decomposition(C_series[day-1], k, temp_soc, moisture_soc)
end

println("Simulated SOC decomposition over $n_years years.")
p = plot(1:n_days, C_series,
         xlabel="Days",
         ylabel="Soil Organic Carbon (Mg C/ha)",
         title="SOC Decomposition Over Time",
         legend=false)
savefig("examples/soc_decomposition.png")
println("Plot saved to examples/soc_decomposition.png")
println("-"^40)
