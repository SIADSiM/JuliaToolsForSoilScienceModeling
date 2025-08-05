using Test

@testset "SoilScienceModel.jl" begin
    # Include testing files for each module
    include("physics_tests.jl")
    include("hydrology_tests.jl")
    include("biogeochemistry_tests.jl")
    include("erosion_tests.jl")
end
