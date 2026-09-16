# 黛玉Agent · Task 派发协议（平台中立）

派发前必须读取 [agent-registry.md](agent-registry.md) 与 [control-plane.md](control-plane.md)；报告按 [evidence-schema.md](evidence-schema.md) 生成。

Lead 用 `Task` 工具开槽。每条派发 = **一个槽、一个报告文件**。  
**禁止**把 `SKILL.md`、`examples.md`、`diagrams.md` 或 `plan.md` 全文贴进 prompt。

## Token 装箱（MUST）

按此顺序组装，不得颠倒、不得另附仓库全文：

1. 通用外壳（本节模板，≤25 行）
2. 槽位 Done：只引用 [slot-prompts.md](slot-prompts.md) 对应节标题，或摘 ≤8 行
3. 稳定前缀：Goal 标识、闸、`batch_id`、`parallel_batch_id`、`allowed_paths` glob、`token_budget`、`output_max_lines`、`registry_profile`
4. 指针：`plan.md` 的「验收清单」节、`ownership.md`、本闸报告路径（只给路径）
5. 增量：③④⑤ 优先 `git diff -- <allowed_paths>`；超过 200 行则写入 `reports/_diff-<task_id>.txt`，prompt 只传该路径（`packed_diff_path`）

Lead fan-in：先读报告 YAML 头字段；`STATUS: DONE` 且 schema 齐全则不把报告正文再贴回对话。

默认 `output_max_lines`：scout 80、planner 150、fe/be/impl 120、verifier 80、reviewer 100、tester 80、closer 60。  
默认 `token_budget`（Goal=100）：scout 8、planner 12、fe/be/impl 22、verifier 22、reviewer 12、tester 14、closer 10。用量优先读宿主 usage；没有则 `estimated`，阈值按本 Task 预算。

## 通用外壳

```text
你是黛玉Agent「<槽名>」槽。严格按槽位规则工作。
禁止：<禁区摘要>
完成定义：<Done>

工作区：<repo>/work/DaiYu-Agent/<slug>/
必读（按路径打开，不要等人再贴全文）：
- ledger.md（只读进度，勿重做已勾闸）
- plan.md#验收清单（若已存在）
- ownership.md（写码槽必读）
- 槽位细则：slot-prompts.md 中「<槽>」节
- packed_diff_path：<路径或 none>

本闸报告必须写入：work/DaiYu-Agent/<slug>/reports/<file>.md
对话最终只输出：
STATUS: DONE|DONE_WITH_CONCERNS|NEEDS_CONTEXT|BLOCKED|SKIP
SUMMARY: <≤20字>
REPORT: <报告相对路径>
```

再追加本闸「输入」块（目标、Goal 标识与状态、批次、`allowed_paths`、并发批次 ID、`token_budget`、`usage_source`、`output_max_lines`、`context_files`、`packed_diff_path`、registry profile）。

## 按闸推荐

| 闸 | description（短标题） | subagent_type | 并行 | 报告文件 |
|----|----------------------|---------------|------|----------|
| ① | 黛玉①摸底 | `explore` 或 `generalPurpose` | 否 | `g1-scout.md` |
| ② | 黛玉②方案 | `generalPurpose` | 否 | `plan.md` + `ownership.md` + `stack-decision.md` + `token-budget.md`；摘要 `g2-plan.md` |
| ③FE | 黛玉③前端 | `generalPurpose` 或 `coldbrew-ishii` | **必须并发** | `g3-fe.md` |
| ③BE | 黛玉③后端 | `generalPurpose` 或 `coldbrew-ishii` | **必须并发** | `g3-be.md` |
| ③V | 黛玉③独立验证/影响分析 | `explore` 或 `generalPurpose` | 与单侧实现同发 | `g3-verify.md` |
| ④ | 黛玉④质量审查 | `generalPurpose` | 否 | `g4-review.md`（须含「## 质量审查」） |
| ⑤ | 黛玉⑤功能测试 | `generalPurpose` | 否 | `g5-test.md`（须含命令与退出码） |
| ⑥ | 黛玉⑥收口 | Lead 或 `explore` | 否 | `g6-close.md` |

`model`：默认 `inherit`。单文件机械修复可用 `composer-2.5-fast`。  
**禁止**编造列表外的 model slug。

## ③ 并行检查单（同发前）

- [ ] `plan.md` 已冻结且验收清单非空
- [ ] `ownership.md` 已写，FE/BE 路径无交集（契约文件最多一侧）
- [ ] `stack-decision.md` 与 `token-budget.md` 已写（快路径允许 `mode: reuse` stub）
- [ ] ledger / plan 已写 `fast_path: true|false`
- [ ] 两个 Task 的 `prompt` 都含 **只改所有权内路径**
- [ ] 除此之外无第三个写码 Task
- [ ] **并发硬门槛：至少两个 Task 已同发；单侧项目为实现 + 独立验证/影响分析**
- [ ] 记录 `parallel_batch_id`、两个 Task 的启动时间、报告路径和完成状态

## ③V 派发要点

- 只读；与实现槽同发；不得修改产品代码
- `fast_path: true`：报告只有「## 影响清单」3–5 条；禁止过/打回、禁止粘贴 diff；`output_max_lines` 40
- `fast_path: false`：可列越权/契约/遗漏，仍不得代替④下结论
- Lead：快路径下出现审查结论标签或 diff 正文 → 判③未过并重派 ③V

## ④ 独立质量审查派发要点

- reviewer **不得**是本批③写码槽；Lead 不得代写 `g4-review.md`
- prompt 写明：**禁止修改产品代码**；只对照验收清单；diff 只给 `packed_diff_path`
- 装箱：验收清单摘录、ownership glob、`packed_diff_path`、g3 报告路径；禁止全库 grep、禁止粘贴 g3 全文与 diff 正文
- `fast_path: true`：只逐条勾验收；禁止复述 ③V
- 报告必须有 **「## 质量审查」** 与结论标签：过 / 打回方案 / 打回前端 / 打回后端 / 仅修测障
- Lead：无该专节、越权写码、或快路径下复述 diff → 判未过并重派，禁止进⑤

## ⑤ 功能测试派发要点

- prompt 写明：必须真跑功能命令；禁止未跑报绿
- 遵守仓库 `background-test-verify` / `post-task-review`（若存在）
- 必读：`plan.md` 验收清单 + ④结论为「过」
- 红：归属标签 + 复现命令；临时文件测完删除
- Lead：无命令或退出码 → 判红并重派

## Lead 收报告后

1. 读 `REPORT` 文件的 YAML 头（不要只信 SUMMARY）
2. 校验统一 evidence schema：Goal 标识、`gate`、`batch_id`、`task_id`、`attempt_id`、`parallel_batch_id`、`status`、`evidence_path`、`commands`、`exit_codes`。不一致则当前闸失败
3. 校验③是否确有至少两个并发 Task 报告，并核对同一 `parallel_batch_id` 的启动/完成记录；不足则不得进入④
4. 校验④有「## 质量审查」、⑤有命令与退出码；若 `fast_path: true`，再校验 ③V 仅有影响清单且④未粘贴 diff
5. 更新 `ledger.md` 勾选、Goal 状态与闸日志
6. 默认模式 → 一页结论等人（含审查/测试结论和 Goal 状态）
7. 连续模式 → 按 SKILL 自进或 STOP（打回/测红/阻塞必停）

## 修复单派发

```text
batch: fix-<n>
goal_id: <same-goal-id>
原因标签: 打回前端|打回后端|仅修测障|打回方案
只修审查/测试指出的项；禁止顺手重构。
仍须③→④→⑤。
```

## 控制面批次协议（MUST）

每次派发前先在 ledger 写入批次清单，再调用 Task。fan-out 要求所有预期 Task 同一调度回合发出并记录启动证据；heartbeat 必须包含 task_id、Goal 标识、parallel_batch_id、status、started_at、finished_at；fan-in 仅在所有报告存在且绑定同一 Goal/批次、无越界写入时将批次标记 JOINED。

Task 状态映射：`DONE|DONE_WITH_CONCERNS` 可计入 completed；`SKIP` 仅当预期槽明确标记 optional；`NEEDS_CONTEXT|BLOCKED` 保持批次 OPEN；`STALE` 可重派新 `attempt_id`；`FAILED` 结束当前 attempt 并按控制面规则暂停/重试。

每次重派必须写 `retry_of`、`attempt_id`、`terminal_reason`，不得复用终态 `task_id`。

超时一回合标记 STALE，连续两回合先重派一次，仍无心跳则 FAILED 并停闸。终态 task_id 不得重复派发；修复批次使用新 batch_id。
