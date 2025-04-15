from evaluation import run_experiments

run_experiments(
    option        = 'monpoly',
    benchmark     = 'ic',
    exe           = './monpoly.exe',
    accelerations = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512],
    n             = 5,
    time_unit     = 1,
)

run_experiments(
    option        = 'enfguard',
    benchmark     = 'ic',
    exe           = './enfguard.exe',
    accelerations = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512],
    n             = 5,
    time_unit     = 1,
)
