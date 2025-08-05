using Test
using ..SoilScienceModel.Erosion

@testset "Erosion Module" begin

    @testset "bulk_density_calc" begin
        particle_density = 2650.0
        porosity = 0.5

        bd = bulk_density_calc(particle_density, porosity)
        @test bd == 2650.0 * 0.5

        porosity_array = [0.4, 0.5, 0.6]
        bd_array = bulk_density_calc(particle_density, porosity_array)
        @test length(bd_array) == 3
        @test bd_array[2] == bd
    end

    @testset "soil_erosion_usle" begin
        R, K, LS, C, P = 100.0, 0.3, 1.0, 0.5, 1.0
        A = soil_erosion_usle(R, K, LS, C, P)
        @test A == 100.0 * 0.3 * 1.0 * 0.5 * 1.0
    end

end
