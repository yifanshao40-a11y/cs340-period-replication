# Extension Experiment Design: Effects of Thread Count on Concurrency Bug Detection with PERIOD

- **Name:** Yifan Shao
- **Student ID:** 1240027211
- **Document Version:** 1.0 - Design Proposal
- **Internal Completion Deadline:** October 30, 2026, at 18:00
- **Planned GitHub Submission Deadline:** October 30, 2026, at 21:00
- **Time Zone:** These deadlines retain the original project plan's China Standard Time (UTC+08:00).
- **Status:** Experimental design completed. Detailed source inspection, implementation, and experimental execution remain pending. No experimental measurements are reported.

## 1. Research Questions and Scope

Table 2 of the original paper reports results for CS.reorder_3_bad, CS.reorder_4_bad, and CS.reorder_5_bad. Section 4.2 discusses differences between parallel and serialized scheduling.

This work will first reproduce these three benchmarks, then introduce proposed six-thread and eight-thread configurations to investigate:

1. Under the same search bounds, how does thread count affect PERIOD's target-bug detection, schedules explored before the first target bug is found, and total schedules explored?
2. Once Serial's provenance and execution procedure have been verified, how do the two methods compare at the same thread count?

The study does not assume that metrics will change monotonically or that either method will always perform better. Conclusions will be limited to the selected programs, environment, and search bounds.

## 2. Experimental Subjects and Modification Plan

| Subject | Purpose |
|---|---|
| `evaluation/CS/reorder_3/` | Reproduce the original three-thread benchmark. |
| `evaluation/CS/reorder_4/` | Reproduce the original four-thread benchmark. |
| `evaluation/CS/reorder_5/` | Reproduce the original five-thread benchmark and establish the extension baseline. |
| Proposed six-thread and eight-thread configurations | Examine additional thread counts. |

Before implementation, compare the original three-thread, four-thread, and five-thread source code and document:

- The definition of thread count, worker-thread creation and joining, and the number and role of each thread type.
- How the original programs scale. Extensions must create additional participating threads; changing only array sizes or loop bounds does not establish an increase in thread count.
- All changes to thread creation, initialization, joining, and assertions. Preserve the original shared-state logic, thread-operation rules, and target-bug criterion.
- If common parameterized source generates the extension configurations, whether its five-thread configuration preserves the original program's behavior and target bug. Disclose source changes.
- Whether additional threads increase total work. If so, runtime changes will not be attributed entirely to scheduling overhead.

This source inspection and the corresponding code changes remain pending and are not claimed as completed deliverables.

## 3. Experiment Matrix and Parameters

| Thread Count | PERIOD | Serial, After Verification |
|---|---:|---:|
| 5 | 10 runs | 10 runs |
| 6 | 10 runs | 10 runs |
| 8 | 10 runs | 10 runs |

The PERIOD-only study requires 30 formal runs. Including Serial requires 60 formal runs in total. Record pilot runs, equivalence checks, and debugging runs separately.

Existing five-thread results may be reused only when the source and executable, instrumentation, hardware and container environment, parameters, and stopping rules are identical, and complete raw logs are available. Otherwise, rerun the baseline. If ten eligible baseline runs exist for each method, 40 additional formal runs are required.

| Parameter | Proposed Setting |
|---|---|
| Maximum bug depth | 3, matching the paper's SCTBench setting. |
| Maximum schedules per test run | 10,000, matching the budget generally used in the paper. |
| Timeout for one execution of the program under test | Initially 5 seconds, subject to pilot validation. This is not the timeout for the entire test run. |
| Repetitions | 10 runs per thread-count and method combination, restarting the program each time. |
| Environment | Use member A's validated shared environment. Record image digest, source commit, compiler, kernel, and machine information. |
| Execution procedure | Run configurations sequentially on the same machine, record their order, and avoid concurrent experiments. |

Freeze parameters before formal testing. If pilot testing requires changes, apply the same revised settings across compared configurations, document the reason, and repeat affected formal runs. Reaching a search bound does not mean that every possible schedule has been explored.

## 4. Data Recording and Statistical Analysis

Record each run's identifier, method, thread count, source revision, environment version, full command, search bounds, start and end times, exit status, and raw-log location.

| Metric | Recording and Interpretation |
|---|---|
| Target-bug detection | Confirm bug type and triggering location; report how many of ten runs expose the target bug. |
| Schedules explored before the first target bug is found | Use `NA` if not found, and record the stopping reason. Do not substitute zero. |
| Total schedules explored | Record the observed count and whether the schedule budget was reached. |
| Schedules exposing the target bug | Record separately from other bug types and timeout counts. |
| Total runtime | Use consistent timing boundaries as a supplementary cost metric. |
| Run status | Distinguish search completion, budget exhaustion, external interruption, and execution failure. Count individual program-execution timeouts separately. |

Report means, standard deviations, and sample counts for valid runs. If mean schedules to the first target bug uses only runs that find the bug, state that sample count alongside detection counts and non-detection cases.

Failures caused by missing dependencies or insufficient permissions are not valid runs in which no target bug was found. If deterministic metrics are identical across repetitions, report a standard deviation of zero without introducing artificial variation.

Store raw logs in `results/C/raw/` and summaries and figures in `results/C/summary/`. Check `.gitignore` to ensure required raw logs are retained in the repository.

## 5. Analysis, Dependencies, and Deliverables

### Original-Paper Reproduction

Prepare a paper-versus-ours comparison table for the three-thread, four-thread, and five-thread benchmarks.

### Extension Analysis

Plot schedules to the first target bug, total schedules explored, and runtime for the five-thread, six-thread, and eight-thread configurations. Mark non-detection cases and runs that reach a search bound separately.

### Method Comparison

Member A will provide a verifiable source, version, and execution procedure for Serial. An independently implemented baseline will not be described as the paper's original Serial implementation without verification.

If Serial is temporarily unavailable, proceed with the PERIOD-only thread-count study. Report the missing method comparison and do not claim verified superiority over Serial.

### Limitations

Discuss source changes, changes in total work, platform differences, fixed search bounds, and sample size.

### Final Deliverables

- Extension source code and modification notes.
- Execution configurations.
- Raw logs and statistical summaries.
- Comparison figures.
- Written analysis, discrepancy explanations, and limitations.

The October 30 submission is this design proposal. Experimental results will be added after execution.

## 6. Schedule

The following milestones retain the existing group plan.

| Completion Date in 2026 | Member C's Deliverable |
|---|---|
| October 30 | Submit the design proposal, including parameters, source-inspection requirements, dependencies, and deliverables. |
| November 5 | Run the assigned original benchmarks and complete pilot testing using the validated shared environment. |
| November 11 | Complete three-thread, four-thread, and five-thread reproduction experiments and preliminary statistics. |
| November 14 | Complete extension configurations, formal extension runs, and discrepancy checks. |
| November 17 | Deliver written analysis, figures, references, configurations, and log locations to member D. |

Design work can proceed independently. Formal execution depends on the shared environment delivered by member A. Push completed work promptly.

## 7. References and AI Assistance Statement

- [Original PERIOD paper: Sections 4.1.3 and 4.2, and Table 2](https://wcventure.github.io/pdf/ICSE2022_PERIOD.pdf)
- [Authors' original repository](https://github.com/wcventure/PERIOD)
- [Authors' execution script: options and default values](https://raw.githubusercontent.com/wcventure/PERIOD/main/tool/DBDS/run_PDS.py)

This proposal was prepared using the paper, publicly available author materials, and the group plan, with GPT assistance for experimental-design refinement and writing. Unperformed source inspection, implementation, and experiments remain explicitly marked as pending. The document will be updated using actual execution records.
