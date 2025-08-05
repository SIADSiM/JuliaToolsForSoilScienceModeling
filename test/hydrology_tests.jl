using Test
using ..SoilScienceModel.Hydrology

@testset "Hydrology Module" begin

    @testset "penman_monteith_et" begin
        temp = 20.0
        rh = 60.0
        u2 = 2.0
        Rn = 15.0
        G = 2.0
        params = Dict(:z => 100.0, :lat => 40.0)

        ET0 = penman_monteith_et(temp, rh, u2, Rn, G, params)

        @test ET0 > 0
        @test ET0 < 10 # Plausible range for mm/day
    end

    @testset "soil_water_retention_vg" begin
        theta_r = 0.05
        theta_s = 0.45
        alpha = 0.14
        n = 2.68

        # Scalar input
        h_scalar = -1.0
        theta_scalar = soil_water_retention_vg(theta_r, theta_s, alpha, n, h_scalar)
        @test theta_scalar > theta_r
        @test theta_scalar < theta_s

        # Array input
        h_array = [-0.1, -1.0, -10.0]
        theta_array = soil_water_retention_vg(theta_r, theta_s, alpha, n, h_array)
        @test length(theta_array) == 3
        @test all(theta_array .> theta_r)
        @test all(theta_array .< theta_s)
    end

end
