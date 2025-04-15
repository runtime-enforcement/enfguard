# Replication instructions

This document describes the steps needed to reproduce the empirical evaluation presented in Section 5 of

Hublet, F., Lima, L., Basin, D., Krstić, S., & Traytel, D. (2025). Scaling Up Proactive Enforcement. *CAV'25*.

## Step 0: Requirements and preparation

Indicative duration: 5 minutes. (TODO: Double check this)

The configuration used for our experiments was the following:

  * Processor: AMD Ryzen™ 5 5600X, with 6 cores and 3.7 GHz
  * RAM: 16 GB
  * OS: Ubuntu 22.04
  * Python 3.9.5

From the extracted `enfguard-artifact` folder, run

```
docker build -t enfguard:artifact .
```

to build EnfGuard's image. Expect this to take a considerable
amount of time.

Next, run

```
docker run -it enfguard:artifact
```

to access the container.

Then open a terminal at the root of the repository and execute

```
cd eval/enforcement
virtualenv env
source env/bin/activate
pip3 install -r requirements.txt
```

## Step 1: Correctness tests

Indicative duration: < 5 minutes.

-----------------

You can run the correctness tests with

```
cd ../..
python3 tests/test.py
```

## Step 2: Smoke Test

Indicative duration: < 1 minute.

-----------------

You can run the smoke test with

```
python3 evaluate_smoke_test.py
```

## Step 3: Reproducing the measurements for RQ2-3

Indicative duration: 1 hour to 1 day per file, depending on hardware.

-----------------

You can run
```
python3 evaluate_gdpr.py      # GDPR
python3 evaluate_fun.py       # GDPR^fun
python3 evaluate_nokia.py     # Nokia
python3 evaluate_ic.py        # IC
python3 evaluate_agg.py       # Agg
python3 evaluate_cluster.py   # Cluster
```
to perform the performance measurements for RQ2-3 described in Section 5 and generate the corresponding tables.

*Note*: "Broken pipe" errors are printed in the console when measurements on a script times out (the default timeout duration is 15 minutes). The rest of the evaluation will proceed normally.
