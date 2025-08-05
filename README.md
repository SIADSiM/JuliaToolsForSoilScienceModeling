# Julia Tools Fo rSoil Science Modeling

A Julia-based, high-performance soil science modeling toolkit for simulating physical, hydrological, biogeochemical, and erosion processes.

This toolkit is designed for reproducibility, HPC readiness, and integration with the scientific computing ecosystem in Julia. It implements peer-reviewed, well-documented routines with consistent SI units and strong type-checking.

## 👷‍♂️ Installation

To use this toolkit, you can add it to your Julia environment using the Pkg manager. From the Julia REPL, run:

```julia
using Pkg
Pkg.develop(path="path/to/SoilScienceModel.jl")
```

This will install the package in development mode. You also need to instantiate the project to download the required dependencies:

```julia
Pkg.instantiate()
```

## ⚓ Usage

Each module provides a set of functions for specific soil processes. You can import the modules and use the functions as follows:

```julia
using SoilScienceModel.Physics
using SoilScienceModel.Hydrology
# etc.

# Example call
porosity = 0.5
particle_density = 2650.0
bulk_density = bulk_density_calc(particle_density, porosity)
println("Bulk Density: $bulk_density kg/m³")
```

For detailed examples, please see the scripts in the `/examples` directory.

## 🧩 Modules and Functions

Below is a list of the implemented modules and functions. All functions include DocStrings with detailed information about parameters, units, and references.

### Physics Module (`src/Physics.jl`)
*   `soil_moisture_balance(precip, et, params)`: Daily soil water balance.
*   `green_ampt_infiltration(t, Ks, psi, theta_i, theta_s)`: Green–Ampt infiltration.
*   `soil_temperature_profile(initial_temp, surface_temp_series, thermal_diff, dt, dz, n_nodes)`: 1D heat conduction in soil.

### Hydrology Module (`src/Hydrology.jl`)
*   `penman_monteith_et(temp, rh, u2, Rn, G, params)`: FAO-56 Penman–Monteith ET.
*   `soil_water_retention_vg(theta_r, theta_s, alpha, n, h)`: van Genuchten water retention.

### Biogeochemistry Module (`src/Biogeochemistry.jl`)
*   `nitrogen_mineralization(temp, moisture, params)`: CENTURY model scalars for N mineralization.
*   `soil_respiration_q10(T, Rref, Tref, Q10)`: Q10 soil respiration model.
*   `soil_carbon_decomposition(C0, k, temp, moisture)`: First-order SOC decomposition.

### Erosion Module (`src/Erosion.jl`)
*   `bulk_density_calc(particle_density, porosity)`: Soil bulk density calculation.
*   `soil_erosion_usle(R, K, LS, C, P)`: Universal Soil Loss Equation.

## 🧩 UML Diagram

A UML diagram showing the module and function dependencies is available in `uml_diagram.puml`. This file contains the source code for the diagram in PlantUML format.

## 📜 License

This project is licensed under a custom non-commercial license.

* ✅ **Free for personal, academic, and research use.**
* ❌ **Commercial use is strictly prohibited without a separate license.**

For commercial licensing inquiries, please contact me at ** s i a d s i m @ g m a i l . c o m  **.

## 📑 References

Allen, R.G., Pereira, L.S., Raes, D., & Smith, M. (1998). *Crop Evapotranspiration — Guidelines for computing crop water requirements*. FAO Irrigation and Drainage Paper 56.

Green, W.H. & Ampt, G.A. (1911). Studies on soil physics. *The Journal of Agricultural Science, 4*(1), 1-24.

Hillel, D. (1998). *Environmental Soil Physics*. Academic Press.

Lloyd, J. & Taylor, J.A. (1994). On the temperature dependence of soil respiration. *Functional Ecology, 8*(3), 315-323.

Parton, W.J., Schimel, D.S., Cole, C.V., & Ojima, D.S. (1987). Analysis of factors controlling soil organic matter levels in Great Plains grasslands. *Soil Science Society of America Journal, 51*(5), 1173-1179.

van Genuchten, M.T. (1980). A closed-form equation for predicting the hydraulic conductivity of unsaturated soils. *Soil Science Society of America Journal, 44*(5), 892-898.

Wischmeier, W.H., & Smith, D.D. (1978). *Predicting rainfall erosion losses*. USDA Agriculture Handbook 537.
