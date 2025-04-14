# Replication instructions

This document describes the steps needed to reproduce the empirical evaluation presented in Section 5 of

Hublet, F., Lima, L., Basin, D., Krstić, S., & Traytel, D. (2025). Scaling Up Proactive Enforcement. *CAV'25*.

## Step 0: Requirements and preparation

Indicative duration: 5 minutes. (TODO: Double check this)

The configuration used for our experiments was the following:

  * Processor: AMD Ryzen™ 5 5600X, with 6 cores and 3.7 GHz
  * RAM: 16 GB
  * OS: Ubuntu 22.04
  * Python 3.8.10 (TODO: Double check this)

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

## Step 1 (Optional): Smoke Test

Indicative duration: < 1 minute. (TODO: Double check this)

-----------------

You can type

```
../../bin/whyenf.exe -sig examples/arfelt_et_al_2019.sig -formula examples/formulae_whyenf/{formula}.mfotl -log examples/arfelt_et_al_2019.log
```

where `{formula}` is any of `minimization`, `limitation`, `lawfulness`, `consent`, `information`, `deletion`, or `sharing`, to see the type checking decisions and run the enforcer on the corresponding formula and log.

This experiment will use the following files:

  * The logs generated in the previous step;
  * The signature file in `examples/arfelt_et_al_2019.sig`;
  * The formulae in `examples/formulae_whyenf/`.

## Step 3. Reproducing the measurements with the log from Debois & Slaats (2015) for RQ2-3

Indicative duration: 1-3 hours.

You can run
```
python3 evaluate_rq2.py option [-e EXECUTABLE_PATH] [-g] [-s]
```
to run the performance measurements for RQ2-3 described in Section 7 and Appendix D and generate the corresponding graphs.

The options are as follows:

  * **Required**: `option` (possible values are `Enfpoly`, `WhyEnf`, and `WhyMon`) to select the tool to use as a backend;
  * `-e` to provide the path to the `Enfpoly` or `WhyMon` executable (required iff `OPTION = Enfpoly` or `WhyMon`);
  * `-g` to only regenerate the graphs and tables without performing new experiments;
  * `-s` to only run a smoke test without performing the full experiments.

This script uses the replayer script in `replayer.py`.

The experiments will use the following files:

  * The logs and signature file, as before;
  * The formulae in `examples/formulae_{tool}/`, where `{tool}` is one of `enfpoly`, `whyenf`, or `whymon`. The formulae in each of these folders adhere to the input grammar of the corresponding tool.

In `evaluate_rq2.py`,

For installing Enfpoly, see instructions at [Enfpoly's repository](https://bitbucket.org/jshs/monpoly/src/enfpoly/).

For installing WhyMon, see instructions at [WhyMon's repository](https://github.com/runtime-monitoring/whymon/tree/e44aee7bb86df2abfef3aa07482f59de22f7a06b). **Important**: check out commit `e44aee7b` before compiling.

After running the script, you will find:

  * Figure 8 (Sec. 7) at `out_whyenf/summary.png` (after running with `OPTION = WhyEnf`);
  * Figure 9 (Sec. 7) printed on standard input (after running with all three options);
  * Figure 13 (App. D) at `out_whymon/summary.png` (after running with `OPTION = WhyMon`);
  * Figure 14 (App. D) at `out_enfpoly/summary.png` (after running with `OPTION = Enfpoly`);
  * Figure 15 (App. D) at `out_whyenf/consent_400000.png`, `out_whyenf/information_1600000.png`, and `out_whyenf/sharing_1600000` (after running with `OPTION = WhyEnf`).

Note that for every experiment performed, the time profile is plotted to `out_{tool}/{formula}_{acceleration}.png`.

## Step 4. Reproducing the measurements with synthetic traces for RQ3.

Indicative duration: 1-3 hours.

You can run
```
python3 evaluate_rq3.py option [-e EXECUTABLE_PATH] [-g] [-s]
```
to run the performance measurements described in Section 7. The options are as in Step 3.

This script uses the replayer script in `replayer.py` and the trace generator in `generator.py`.

The experiments will use the following files:

  * A synthetic log that will be saved into `examples/synthetic.log`;
  * The signature file, as before;
  * The formulae in the `examples/formulae_{tool}/` folders.

After running the script, you will find:

  * Figure 10 (Sec. 7) printed on standard input (after running with all three options).

Note that for every experiment performed, the time profile is plotted to `out_{tool}/{formula}_{n}_{k}.png` where $n$ and $k$ are as in the paper.
