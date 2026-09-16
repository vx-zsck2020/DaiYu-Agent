# Changelog

## 1.1.1 - 2026-09-17

- 增加小范围快路径：验收 ≤5、ownership ≤8、`stack_change: none` 时复用现有栈。
- 快路径下 ③ 仍双槽；③V 只写影响清单；④ 只勾验收清单，禁止复述 diff。

## 1.1.0 - 2026-09-17

- 吸收 Darwin Skill 3.0 的棘轮、CHECKPOINT、失败三段式分支与独立审查隔离。
- 移除安全检测、威胁面冻结和攻防测试闸；④ 改为独立质量审查，⑤ 只保留功能真跑。
- 增强 Token 装箱：稳定前缀 → 闸指针 → packed diff；审查禁止全库漫游；fan-in 先读 YAML 头。

## 1.0.0 - 2026-09-14

- 首次公开发布 DaiYu-Agent（黛玉Agent）。
- 固化 Goal、并发多 Agent、控制面、证据 schema、安全门和 Token 治理。
- 增加 DevUI 默认前端规范与后端自动选型决策要求。
