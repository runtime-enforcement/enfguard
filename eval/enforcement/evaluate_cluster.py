from evaluation import run_experiments

run_experiments(
    option        = 'enfguard',
    benchmark     = 'cluster',
    exe           = './enfguard.exe',
    accelerations = [32, 64],
    n             = 1,
    time_unit     = 1,
    func          = True,
    only_graph    = False,
)
