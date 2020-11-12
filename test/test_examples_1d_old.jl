module TestExamples1D

using Test
using Trixi

include("test_trixi.jl")

# Start with a clean environment: remove Trixi output directory if it exists
outdir = "out"
isdir(outdir) && rm(outdir, recursive=true)

# pathof(Trixi) returns /path/to/Trixi/src/Trixi.jl, dirname gives the parent directory
const EXAMPLES_DIR = joinpath(pathof(Trixi) |> dirname |> dirname, "examples", "1d")

# Run basic tests
@testset "Examples 1D" begin
  @testset "taal-confirmed parameters_advection_basic.toml" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_advection_basic.toml"),
            l2   = [5.581321238071356e-6],
            linf = [3.270561745361e-5])
  end
  @testset "taal-confirmed parameters_advection_amr.toml" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_advection_amr.toml"),
            l2   = [0.3540209654959832],
            linf = [0.9999905446337742])
  end
  @testset "taal-confirmed parameters_advection_amr_nonperiodic.toml" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_advection_amr_nonperiodic.toml"),
            l2   = [4.317984162166343e-6],
            linf = [3.239622040581043e-5])
  end
  @testset "taal-confirmed parameters_euler_nonperiodic.toml" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_nonperiodic.toml"),
            l2   = [3.8103398423084437e-6, 1.6765350427819571e-6, 7.733123446821975e-6],
            linf = [1.2975101617795914e-5, 9.274867029507305e-6, 3.093686036947929e-5])
  end
  @testset "taal-confirmed parameters_euler_blast_wave.toml" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_blast_wave.toml"),
            l2   = [0.21530530948120738, 0.2805965425286348, 0.5591770920395336],
            linf = [1.508388610723991, 1.5622010377944118, 2.035149673163788],
            n_steps_max=30)
  end
  @testset "taal-confirmed parameters_euler_ec.toml" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_ec.toml"),
            l2   = [0.11948926375393912, 0.15554606230413676, 0.4466895989733186],
            linf = [0.2956500342985863, 0.28341906267346123, 1.0655211913235232])
  end
  @testset "taal-confirmed parameters_euler_ec.toml with extra_analysis_quantities" begin
    # TODO: Taal, remove if not required for coverage (currently not ported)
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_ec.toml"),
            l2   = [0.11948926375393912, 0.15554606230413676, 0.4466895989733186],
            linf = [0.2956500342985863, 0.28341906267346123, 1.0655211913235232],
            extra_analysis_quantities = ["l2_error_primitive", "linf_error_primitive", "conservation_error",
                                        "entropy", "energy_total", "energy_kinetic", "energy_internal", "residual"],
            save_analysis = true)
  end
  @testset "taal-confirmed parameters_euler_ec.toml with flux_shima_etal" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_ec.toml"),
            l2   = [0.06423364669980625, 0.08503530800170918, 0.2407844935006154],
            linf = [0.3212150514022287, 0.3070502221852398, 1.1446658347785068],
            n_steps_max=10,
            surface_flux = "flux_shima_etal",
            volume_flux = "flux_shima_etal")
  end
  @testset "taal-confirmed parameters_euler_ec.toml with flux_ranocha" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_ec.toml"),
            l2   = [0.06424564531300972, 0.08500942143178748, 0.2407606831620822],
            linf = [0.3215742010701772, 0.30592054370082256, 1.1453122141121064],
            n_steps_max=10,
            surface_flux = "flux_ranocha",
            volume_flux = "flux_ranocha")
  end
  @testset "taal-confirmed parameters_euler_ec.toml with flux_hll" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_ec.toml"),
            l2   = [0.0575654253650954, 0.0748264642646861, 0.21532027367350406],
            linf = [0.17289848639699257, 0.22023865765090028, 0.6349097763679086],
            n_steps_max=10,
            surface_flux = "flux_hll",
            volume_flux = "flux_hll")
  end
  @testset "taal-confirmed parameters_euler_sedov_blast_wave.toml" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_sedov_blast_wave.toml"),
            l2   = [1.252250990134887, 0.068566581088377, 0.9448804645921002],
            linf = [2.989362275712484, 0.16948139637812973, 2.665646470846281])
  end
  @testset "taal-confirmed parameters_euler_sedov_blast_wave.toml with pressure" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_sedov_blast_wave.toml"),
            l2   = [1.297435677146544, 0.07960523576439762, 0.9453356096003658],
            linf = [3.1803117766542313, 0.21385627917778924, 2.665017066963603],
            shock_indicator_variable = "pressure")
  end
  @testset "taal-confirmed parameters_euler_sedov_blast_wave.toml with density" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_sedov_blast_wave.toml"),
            l2   = [1.2778131494486642, 0.0709461986289949, 0.9456057083034296],
            linf = [3.1163652756237115, 0.17652352860779985, 2.66646958937844],
            shock_indicator_variable = "density")
  end
  @testset "taal-confirmed parameters_euler_shockcapturing.toml" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_shockcapturing.toml"),
            l2   = [0.1166063015913971, 0.15097998823740955, 0.4348178492249418],
            linf = [0.1872570975062362, 0.245999816865685, 0.7037939282238272])
  end
  @testset "taal-confirmed parameters_euler_source_terms.toml" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_source_terms.toml"),
            l2   = [2.243591980786875e-8, 1.8007794300157155e-8, 7.701353735993148e-8],
            linf = [1.6169171668245497e-7, 1.4838378192827406e-7, 5.407841152660353e-7])
  end
  @testset "taal-confirmed parameters_euler_density_wave.toml" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_density_wave.toml"),
            l2   = [0.0011482554828446659, 0.00011482554838682677, 5.741277410494742e-6],
            linf = [0.004090978306810378, 0.0004090978313616156, 2.045489169688608e-5])
  end
  @testset "taal-confirmed parameters_euler_density_wave.toml with initial_condition_density_pulse" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_density_wave.toml"),
            l2   = [0.003724642049410045, 0.0037246420494099837, 0.0018623210247047657],
            linf = [0.018538787219922304, 0.018538787219903874, 0.009269393609915078],
            initial_condition = "initial_condition_density_pulse")
  end
  @testset "taal-confirmed parameters_euler_density_wave.toml with initial_condition_constant" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_euler_density_wave.toml"),
            l2   = [7.058654266604569e-16, 1.9703187362332313e-14, 7.286819681608443e-15],
            linf = [3.774758283725532e-15, 6.733502644351574e-14, 2.4868995751603507e-14],
            initial_condition = "initial_condition_constant")
  end
end

# Coverage test for all initial conditions
@testset "Tests for initial conditions" begin
  # Linear scalar advection
  @testset "taal-confirmed parameters_advection_basic.toml with initial_condition_sin" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_advection_basic.toml"),
            l2   = [9.506162481381351e-5],
            linf = [0.00017492510098227054],
            n_steps_max = 1,
            initial_condition = "initial_condition_sin")
  end
  @testset "taal-confirmed parameters_advection_basic.toml with initial_condition_constant" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_advection_basic.toml"),
            l2   = [6.120436421866528e-16],
            linf = [1.3322676295501878e-15],
            n_steps_max = 1,
            initial_condition = "initial_condition_constant")
  end
  @testset "taal-confirmed parameters_advection_basic.toml with initial_condition_linear_x" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_advection_basic.toml"),
            l2   = [7.602419413667044e-17],
            linf = [2.220446049250313e-16],
            n_steps_max = 1,
            initial_condition = "initial_condition_linear_x",
            boundary_conditions = "boundary_condition_linear_x",
            periodicity=false)
  end
  @testset "taal-confirmed parameters_advection_basic.toml with initial_condition_convergence_test" begin
    test_trixi_run(joinpath(EXAMPLES_DIR, "parameters_advection_basic.toml"),
            l2   = [2.9989673704826656e-6],
            linf = [5.841215237722963e-6],
            n_steps_max = 1,
            initial_condition = "initial_condition_convergence_test",
            boundary_conditions = "boundary_condition_convergence_test",
            periodicity=false)
  end
end

# Clean up afterwards: delete Trixi output directory
@test_nowarn rm(outdir, recursive=true)

end #module