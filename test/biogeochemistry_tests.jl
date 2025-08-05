using Test
using ..SoilScienceModel.Biogeochemistry

@testset "Biogeochemistry Module" begin

    @testset "nitrogen_mineralization" begin
        temp = 25.0
        moisture = 0.3
        params = Dict(:max_rate => 1.0)
        rate = nitrogen_mineralization(temp, moisture, params)

        @test rate > 0
    end

    @testset "soil_respiration_q10" begin
        T = 20.0
        Rref = 1.5
        Tref = 10.0
        Q10 = 2.0

        R20 = soil_respiration_q10(T, Rref, Tref, Q10)
        @test R20 == Rref * Q10

        T_array = [10.0, 20.0, 30.0]
        R_array = soil_respiration_q10(T_array, Rref, Tref, Q10)
        @test length(R_array) == 3
        @test R_array[1] == Rref
    end

    @testset "soil_carbon_decomposition" begin
        C0 = 100.0
        k = 0.01
        temp = 25.0
        moisture = 0.3

        C1 = soil_carbon_decomposition(C0, k, temp, moisture)
        @test C1 < C0
        @test C1 > 0
    end

end
