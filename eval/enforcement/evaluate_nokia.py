from evaluation import run_experiments


run_experiments(
    option        = 'monpoly',
    benchmark     = 'nokia',
    exe           = './monpoly.exe',
    accelerations = [32, 128, 256, 512],
    n             = 1,
    time_unit     = 1,
    only_graph    = False,
)

run_experiments(
    option        = 'enfguard',
    benchmark     = 'nokia',
    exe           = './enfguard.exe',
    accelerations = [32, 64, 128],
    n             = 1,
    time_unit     = 1,
    only_graph    = False,
)

run_experiments(
    option        = 'enfpoly',
    benchmark     = 'nokia',
    exe           = './enfpoly.exe',
    accelerations = [512],
    n             = 1,
    time_unit     = 1,
    only_graph    = False,
)

run_experiments(
    option        = 'whyenf',
    benchmark     = 'nokia',
    exe           = './whyenf.exe',
    accelerations = [256, 512],
    n             = 1,
    time_unit     = 1,
    only_graph    = False,
)
