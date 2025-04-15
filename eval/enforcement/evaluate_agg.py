from evaluation import run_experiments

run_experiments(
    option        = 'monpoly',
    benchmark     = 'agg',
    exe           = './monpoly.exe',
    accelerations = [512],
    n             = 1,
    time_unit     = 1,
    only_graph    = False,
)

run_experiments(
    option        = 'enfguard',
    benchmark     = 'agg',
    exe           = './enfguard.exe',
    accelerations = [2, 8, 32, 64],
    n             = 1,
    time_unit     = 1,
    only_graph    = False,
)
