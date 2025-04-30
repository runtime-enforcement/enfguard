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

to build EnfGuard's image. Expect this to take a considerable
amount of time.

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

The output should be of the form

```
       formula   log          a  avg_latency  max_latency  avg_time  max_time      avg_ev
0      consent  gdpr  6400000.0     0.961801          4.0  1.043160       4.0  809.516964
1     deletion  gdpr  6400000.0     0.316199          2.0  0.402594       2.0  809.516964
2  information  gdpr  6400000.0     0.816553          4.0  0.901179       4.0  809.516964
3   lawfulness  gdpr  6400000.0     0.833766          2.0  0.908255       3.0  809.516964
4      sharing  gdpr  6400000.0     0.831408          4.0  0.912500       4.0  809.516964
```
with rows corresponding to formulae in the "GDPR" benchmark and columns listing the log's name, acceleration, average and maximum latency, average and maximum time, and average event rate. Figure 14 in the paper contains the `a`, `avg_ev`, `avg_latency`, and `max_latency` columns, respectively.

## Step 2: Correctness tests

Indicative duration: < 5 minutes.

-----------------

You can run our correctness tests with the command

```
$ python3 tests/test.py
```

from `/home/me/enfguard/`.

## Step 3: Reproducing the measurements for RQ2-3

Indicative duration: 1 hour to 1 day per file, depending on hardware.

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

to perform the performance measurements for RQ2-3 described in Section 5 and generate the corresponding tables.

*Note*: "Broken pipe" errors are printed in the console when measurements on a script times out (the default timeout duration is 15 minutes). The rest of the evaluation will proceed normally.
