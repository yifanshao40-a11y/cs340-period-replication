# Member C: Original-Benchmark Pilot Report

- Name: Yifan Shao
- Student ID: 1240027211
- Group role: C
- Internal milestone: November 5, 2026
- Actual experimental completion: October 28, 2026, 04:24:49 UTC (12:24:49 China Standard Time, UTC+08:00)
- GitHub submission time: not yet submitted; record the actual commit time separately.
- Session: `launch-3067-20011`
- Status: the three assigned PERIOD pilots completed and reproduced the target assertion.

## 1. Objective and Scope

The November 5 milestone requires member C to run the assigned original programs, complete at least one pilot round, and check that execution evidence and summaries can be saved correctly. This session tested the original `reorder_3_bad`, `reorder_4_bad`, and `reorder_5_bad` programs once each.

These are pilot results. Ten-run formal replication, six-thread/eight-thread extensions, statistical comparisons, and Serial experiments are not claimed as completed.

## 2. Provenance and Environment

- Group source: [cs340-period-replication](https://github.com/yifanshao40-a11y/cs340-period-replication).
- Source commit: `c6eebe0588ed8cc1dfb9a715b11f326e43b40d06`.
- Docker image: `wcventure/period@sha256:8f47d8b9148f2db579627842026e722d0f205ddeab13e70ee41a8df3dbd59fbc`.
- Docker Desktop: 4.97.0; Docker Engine: 29.9.2; Linux/amd64.
- Container operating system: Ubuntu 18.04.5 LTS.
- Kernel: `6.18.33.2-microsoft-standard-WSL2`.
- CPU reported inside the container: Intel Core i9-13900H, 20 logical CPUs.
- Compiler: Clang 10.0.0; Python: 3.6.9.

The author's prebuilt toolchain was retained at `/workdir/PERIOD`. Only the selected benchmark inputs were copied from the group checkout into the image-local benchmark directories. The original checked-out input bytes were preserved separately; staged shell-script line endings were normalized for Linux. Input hashes, staged hashes, and tool hashes are retained with the session.

The container used `--cap-add=SYS_NICE --security-opt seccomp=unconfined`, as in the group startup script. No `sched_setattr` failure was found in the captured experiment evidence.

## 3. Procedure

For each program, the original `build.sh` compiled LLVM bitcode, performed static analysis, and built the instrumented executable. The three programs were then tested sequentially in the order 3, 4, 5.

The engine command for each program was:

```bash
python3 -u /workdir/PERIOD/tool/DBDS/run_PDS.py -y -d 3 -f 10000 -t 5 ./reorder_N_bad
```

The maximum bug depth was 3, the schedule budget was 10,000 per program, and the timeout for an individual tested execution was 5 seconds. An additional 1,800-second outer limit applied per program. No program reached either the schedule budget or outer timeout.

The original binaries were used without runtime arguments. Their worker-thread counts were confirmed from engine output as 3, 4, and 5, each with `MaxKpNum: 2`. The main thread is excluded from those worker-thread labels.

## 4. Observed Results

| Program | Worker threads | Engine-reported tested schedules | Error interleavings | Timeout interleavings | Target assertion confirmed |
|---|---:|---:|---:|---:|---|
| reorder_3_bad | 3 | 27 | 6 | 0 | Yes |
| reorder_4_bad | 4 | 100 | 12 | 0 | Yes |
| reorder_5_bad | 5 | 225 | 20 | 0 | Yes |

All build, testing-process, and log-writing exit codes were zero. Each run contained both `Start Testing!` and `End Testing!`, and the number of observed test labels matched its reported total. No swallowed engine exception or recognized infrastructure error was detected.

All 38 saved controlled-schedule error diagnostics contain the original `checkThread` assertion at `reorder_bad.c:80`. The assertion failures are the intended concurrency-bug evidence. They are distinct from a failure to build or execute the experiment infrastructure.

The testing engine reported elapsed times of 4.74204, 12.76751, and 16.51458 seconds respectively. These are the engine's testing intervals for one pilot each, not build/download time, means, or performance-comparison conclusions.

## 5. Evidence and Validation

Relative to this package, the complete real session is stored under:

`results/C/launch-3067-20011/`

- `session.env` and `environment.log`: parameters, source revision, image digest, environment and tool hashes.
- `reorder_N/status.env`: build, testing-process and log-writing exit codes and timestamps.
- `reorder_N/build.command.sh`, `build.log`, `run.command.sh`, `run.log`: exact commands and raw output.
- `reorder_N/source/`, `source_sha256.txt`, `staged_sha256.txt`: input provenance and staged script hashes.
- `reorder_N/artifacts/out_reorder_N_bad_1/Errors/`: preserved controlled-schedule diagnostics.
- `summary.json`, `summary.csv`, `summary.md`: automatically extracted results.

Docker version, image inspection, image digest and the successful launcher exit status are stored separately under `results/launch-3067-20011/`. The stopped container `period-c-launch-3067-20011` is retained for diagnosis.

The parser was tested with temporary synthetic fixtures before the real session. Those fixtures were removed and are not included as experiment evidence. The real results above come from the actual container execution.

## 6. Limitations and Next Steps

This session establishes that the three original programs can be built, tested, and summarized in the local environment. It does not establish exact agreement with all paper results or superiority over another method.

There is one pilot per program; no mean or standard deviation is reported. `Last New Find` is not interpreted as the first target-bug round. A search bounded by depth and schedule count is not an exhaustive search of all possible schedules.

Serial remains unverified and unrun. The proposed six-worker and eight-worker configurations have been inspected at source level but have not been executed. The next milestones are formal repeated experiments and validation of those extension configurations.

## 7. Contribution and AI Assistance

Yifan Shao prepared member C's experiment design and directed the local setup and pilot execution. GPT assisted with source inspection, launcher and parser preparation, log validation, and English documentation. The user started the launcher once because the assistant's execution tool could not access Docker's local control interface. Experimental measurements were obtained from the real runs and preserved without editing the raw output.
