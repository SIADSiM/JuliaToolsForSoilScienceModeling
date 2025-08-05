using Test
using DataFrames
using ..SoilScienceModel.Physics

@testset "Physics Module" begin

    @testset "soil_moisture_balance" begin
        precip = [10.0, 0.0, 5.0]
        et = [2.0, 2.0, 2.0]
        params = Dict(:fc => 0.3, :wp => 0.1, :zr => 0.5, :initial_moisture => 0.2)
        df = soil_moisture_balance(precip, et, params)

        @test df isa DataFrame
        @test size(df) == (3, 5)
        @test df.SoilMoisture[end] > 0
    end

    @testset "green_ampt_infiltration" begin
        t = 3600.0 # 1 hour
        Ks = 1e-5
        psi = 0.15
        theta_i = 0.2
        theta_s = 0.4
        F = green_ampt_infiltration(t, Ks, psi, theta_i, theta_s)

        # Expected value is around Ks*t for long t, but higher for short t.
        # Let's check if it's a positive value and greater than Ks*t
        @test F > 0
        @test F > Ks * t
    end

    @testset "soil_temperature_profile" begin
        initial_temp = 10.0
        surface_temp_series = [15.0, 16.0, 15.5]
        thermal_diff = 2e-7
        dt = 3600.0
        dz = 0.1
        n_nodes = 10

        T = soil_temperature_profile(initial_temp, surface_temp_series, thermal_diff, dt, dz, n_nodes)

        @test size(T) == (n_nodes, length(surface_temp_series))
        @test T[1, 2] == 15.0 # Surface boundary condition
        @test T[n_nodes, end] == T[n_nodes-1, end] # Bottom boundary condition
    end

end
