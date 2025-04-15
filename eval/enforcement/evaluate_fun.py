from evaluation import run_experiments

run_experiments(
    option        = 'enfguard',
    benchmark     = 'fun',
    exe           = './enfguard.exe',
    accelerations = [1e5, 2e5, 4e5, 8e5, 1.6e6, 3.2e6, 6.4e6, 1.28e7, 2.56e7, 5.12e7],
    n             = 5,
    time_unit     = 24 * 3600,
    func          = True,
)
