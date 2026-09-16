# 黛玉Agent Evidence Schema

每份报告必须包含以下字段：

```yaml
goal_id: <same-goal-id>
gate: 1|2|3|4|5|6
batch_id: <batch-id>
task_id: <task-id>
attempt_id: <attempt-id>
retry_of: <task-id-or-null>
parallel_batch_id: <parallel-batch-id-or-null>
status: DONE|DONE_WITH_CONCERNS|NEEDS_CONTEXT|BLOCKED|SKIP
started_at: <ISO-8601>
finished_at: <ISO-8601>
changed_files: []
commands: []
exit_codes: []
findings: []
risks: []
next_action: <text>
evidence_path: <relative-report-path>
terminal_reason: <text-or-null>
registry_profile: <scout|planner|frontend|backend|verifier|reviewer|tester|closer>
capabilities: []
allowed_paths: []
network_profile: none|local
context_files: []
packed_diff_path: <relative-path-or-none>
output_max_lines: <int>
usage_source: tool|provider-usage|estimated
token_event: none|compress|stop-exploration|close-only|overflow
```

缺少 Goal 标识、Task 标识、命令/退出码（⑤）或证据路径时，报告不可用于 fan-in。
