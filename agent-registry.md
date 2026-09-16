# 黛玉Agent Agent Registry

每个 Task 派发前先选择一个 registry profile；未登记能力不得开槽。

| profile | 读写权限 | 并发角色 | 必须产物 | 默认上限 |
|---|---|---|---|---|
| `scout` | 只读 | ①摸底 | `g1-scout.md` | 1 Task |
| `planner` | 只读 | ②方案 | `plan.md`、`ownership.md`、`stack-decision.md`、`token-budget.md` | 1 Task |
| `frontend` | ownership 前端路径 | ③FE | `g3-fe.md` | 1 写码槽 |
| `backend` | ownership 后端路径 | ③BE | `g3-be.md` | 1 写码槽 |
| `verifier` | 只读 | ③V | `g3-verify.md` | 1 Task |
| `reviewer` | 只读 | ④ | `g4-review.md` | 1 Task；不得由本批写码槽担任 |
| `tester` | 本地测试 | ⑤ | `g5-test.md` | 1 Task |
| `closer` | 只读 | ⑥ | `g6-close.md` | 1 Task |

每个 profile 必须声明：Goal 标识、`parallel_batch_id`、`allowed_paths`、`network_profile`、`token_budget`、`output_max_lines`、`context_files`。
