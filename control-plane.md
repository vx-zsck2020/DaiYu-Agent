# 黛玉Agent Control Plane

## 批次协议

1. Lead 先向 ledger 预登记 `batch_id`、`parallel_batch_id`、预期 Task 和报告路径。
2. fan-out：同一调度回合派发所有预期 Task，并写入 `started_at`。
3. Task 心跳字段固定为：`task_id`、Goal 标识、`batch_id`、`parallel_batch_id`、`status`、`started_at`、`heartbeat_at`、`finished_at`。
4. fan-in 仅在所有报告存在、Goal/批次一致、路径无越界且状态为 `DONE`/`DONE_WITH_CONCERNS` 时发生。
5. 心跳超时一回合标记 `STALE`；连续两回合先重派一次，仍无心跳标记 `FAILED` 并停闸。终态 Task 不得复用 `task_id`。

## 审查隔离

④ `reviewer` 只读；不得修改产品代码，不得由本批③写码 Agent 或 Lead 代写 `g4-review.md`。

## 事件协议

ledger 的 `last_event_id` 单调递增；事件至少包含 `event_id`、时间、Goal、闸、批次、动作、证据路径和结果。

## 幂等规则

恢复时以 ledger 为唯一真相源；已 JOINED/FAILED 的批次不得重复执行，修复必须创建新 `batch_id`。
