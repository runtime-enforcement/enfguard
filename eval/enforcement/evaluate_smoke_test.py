from evaluation import run_experiments

run_experiments(
    option        = 'enfguard',
    benchmark     = 'gdpr',
    exe           = './enfguard.exe',
    accelerations = [6.4e6],
    n             = 1,
    time_unit     = 24 * 3600
)
