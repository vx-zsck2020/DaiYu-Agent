# 黛玉Agent · 调用示例

## 口令

黛玉
黛玉 连续 <目标>
继续黛玉

```text
六闸
六闸 修 cmdk 分类误判
六闸 连续 把 P3-17 提示词收尾做完
六闸 到方案
六闸 到审查
继续六闸
继续六闸 连续
6gates fix login 429
6gates go
```

## Lead 启动后正确行为（验收用例）

### U1 — `黛玉 修 X`

1. 创建 `work/DaiYu-Agent/<slug>/ledger.md`
2. 创建 Goal 标识并将 Goal 状态设为 `ACTIVE`
3. 派①摸底 Task（不写码，绑定同一 Goal）
4. 一页结论等人确认目标（默认模式 CHECKPOINT）
5. **此时不得**出现前端/后端写码 Task

### U2 — `黛玉 连续 修 X`

1. 建台账 `mode: 连续`
2. ①→②自冻：`plan.md` 必须含非空验收清单
3. ③最多同时 2 个写码 Task，并记录同一 `parallel_batch_id`
4. ④打回或⑤测红 → STOP

### U7 — 单侧项目也必须并发

1. `ownership.md` 仅列前端或后端路径时，③ 同时派发实现 Task 与独立验证/影响分析 Task
2. 验证槽只读，不得修改产品代码，必须写 `g3-verify.md`
3. 任一并发槽缺报告或未同发 → ③ 不通过，不得进入④

### U8 — Goal 恢复

1. `继续黛玉` 必须读取原 ledger 的 Goal 标识与 `goal_status`
2. `PAUSED`/`BLOCKED` 只从 `resume_from` 继续，不得新建 Goal 或重派已完成闸
3. 扫不到 ledger → CHECKPOINT 问人，禁止静默新建
4. 只有⑥验收全绿并经人确认，才可写 `goal_status: COMPLETED`

### U3 — 失忆恢复

1. 发现已有 `ledger.md` 且①②已勾
2. 从③继续
3. 不得重派①「再摸底一遍」覆盖台账

### U4 — 反例（必须拒绝）

- 用户未说黛玉/六闸，只要「把这行 typo 改了」→ 不用本 skill
- Lead 自己改完 FE+BE 再假装走过六闸 → 违规
- Lead 或③写码槽自己写 `g4-review.md` → 违规

### U5 — 审查未对照验收

1. ④报告无「## 质量审查」或未勾验收清单 → Lead **不得**勾选④通过，必须重派
2. ⑤报告无命令与退出码 → 判红并重派

### U6 — Token 装箱

1. 子 Agent prompt 不得包含 `SKILL.md` 全文或 `plan.md` 全文
2. ④ 只给验收摘录 + ownership glob + `packed_diff_path`
3. diff 超过 200 行必须落盘后只传路径

## Agent 口令映射

### U9 — 前端、后端与 Token 预算门禁

1. ② 识别管理后台/普通前端/混合形态并锁定对应 DevUI 资源与图标规则。
2. ② 生成 `stack-decision.md`，按项目特性比较后端候选技术栈并记录最终选择。
3. ② 生成 `token-budget.md`，声明 Goal/闸/Task 预算、装箱清单和压缩阈值。
4. 缺少任一决策或预算证据时，方案不得冻结，③不得开槽。

| 用户 | 第一步 |
|------|--------|
| `黛玉` / `六闸` | 若无目标则问一句；否则建台账+① |
| `黛玉 <目标>` | 建台账+① |
| `黛玉 连续 <目标>` | 建台账 mode=连续，①起自动推 |
| `黛玉 到方案` | ①（需要时）→②后停 |
| `继续黛玉` / `继续六闸` | 扫/定位 ledger → 从下一未勾闸恢复；不重跑已勾 |
| `solo-team` | 等同 `黛玉` |
