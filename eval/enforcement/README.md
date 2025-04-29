# Replication instructions

This document describes the steps needed to reproduce the empirical evaluation presented in Section 5 of

Hublet, F., Lima, L., Basin, D., Krstić, S., & Traytel, D. (2025). Scaling Up Proactive Enforcement. *CAV'25*.

## Step 0: Requirements and preparation

Indicative duration: 30 minutes.

The configuration used for our experiments was the following:

  * Processor: AMD Ryzen™ 5 5600X, with 6 cores and 3.7 GHz
  * RAM: 16 GB
  * OS: Ubuntu 22.04
  * Python 3.9.5

From the extracted `enfguard-artifact` folder, run

```
# docker build -t enfguard:artifact .
```

to build this artifact's image, which includes the tools **EnfGuard**, **WhyEnf**, **EnfPoly** and **MonPoly**,
and all of their dependencies. Expect this to take a considerable amount of time.

Next, run

```
# docker run -it enfguard:artifact
```

to access the container.

## Step 1: Smoke Test

Indicative duration: < 15 minutes.

-----------------

You can run the smoke test with

```
$ python3 evaluate_smoke_test.py
```

from `/home/me/enfguard/eval/enforcement`.

This ensures that you can execute all tools included in
this artifact.

## Step 2: Correctness tests

Indicative duration: < 5 minutes.

-----------------

You can run our correctness tests with the command

```
$ python3 tests/test.py
```

from `/home/me/enfguard/`.

## Step 3: Reproducing the measurements for RQ2-3

Indicative duration: 30 minutes to 12 hours per experiment, depending on hardware.

-----------------

You can run

```
$ python3 evaluate_gdpr.py      # GDPR
$ python3 evaluate_fun.py       # GDPR^fun
$ python3 evaluate_nokia.py     # Nokia
$ python3 evaluate_ic.py        # IC
$ python3 evaluate_agg.py       # Agg
$ python3 evaluate_cluster.py   # Cluster
```

to perform the performance measurements for RQ2-3 described in Section 5 and generate the corresponding tables,
where each script executes a single experiment.

Each experiment is associated with a selection of the tools, formulas and log files.

Whenever the execution of a tool reaches 100%, a table is printed to the standard output, e.g.,

```
      formula   log           a  avg_latency  max_latency  avg_time  max_time       avg_ev
0     consent  gdpr  25600000.0     0.319972          2.0  0.394104       1.0  3465.209891
1    deletion  gdpr  25600000.0     0.271870          2.0  0.358962       1.0  3465.209891
2  lawfulness  gdpr  25600000.0     0.278472          2.0  0.363208       1.0  3465.209891
3     sharing  gdpr  25600000.0     0.275407          2.0  0.366038       1.0  3465.209891
option = monpoly, benchmark = gdpr, accelerations = 25600000.0-51200000.0, n = 1: 100%|███████████████████████████████████████| 12/12 [00:39<00:00,  3.30s/it]
```

with columns `formula` (policy), `log`, `a`, `avg_latency` (avg_l), `max_latency` (max_l), `avg_time`,
`max_time`, and `avg_ev` (avg_er). (In parenthesis we include the corresponding notation in the paper.)

*Note*: "Broken pipe" errors are printed in the console when measurements on a script times out (the default timeout duration is 15 minutes). The rest of the evaluation will proceed normally.
