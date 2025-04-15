from evaluation import run_experiments

run_experiments(
    option        = 'enfguard',
    benchmark     = 'fun',
    exe           = './enfguard.exe',
    accelerations = [6.4e6, 1.28e7, 2.56e7],
    n             = 1,
    time_unit     = 24 * 3600,
    func          = True,
    only_graph    = False,
)
