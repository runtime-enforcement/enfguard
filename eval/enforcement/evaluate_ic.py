from evaluation import run_experiments

run_experiments(
    option        = 'monpoly',
    benchmark     = 'ic',
    exe           = './monpoly.exe',
    accelerations = [2, 128, 256],
    n             = 1,
    time_unit     = 1,
    only_graph    = False,
)

run_experiments(
    option        = 'enfguard',
    benchmark     = 'ic',
    exe           = './enfguard.exe',
    accelerations = [2, 64, 128],
    n             = 1,
    time_unit     = 1,
    only_graph     = False
)
