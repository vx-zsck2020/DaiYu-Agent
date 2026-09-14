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
attack_scope: static-only|local|authorized-target|not-applicable
attack_act: executed|skipped_no_auth|not-applicable
auth_evidence: <path-or-null>
residual_risk: <text-or-null>
registry_profile: <scout|planner|frontend|backend|verifier|reviewer|tester|closer>
capabilities: []
allowed_paths: []
network_profile: none|local|authorized
usage_source: tool|provider-usage|estimated
token_event: none|compress|stop-exploration|close-only|overflow
```

缺少 `goal_id`、Task 标识、命令/退出码或证据路径时，报告不可用于 fan-in。
