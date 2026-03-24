---
name: roblox-playtest-report
description: 对 Roblox 项目执行一次聚焦型 playtest 或 QA 检查，结合控制台输出和行为观察，产出简洁可执行的测试报告。
---

# Roblox Playtest Report

当用户需要 QA 检查、Bug 复现、玩法验证，或者修改后的回归结果总结时，使用这个 skill。

## 工作流程

1. 读取 `AGENTS.md`。
2. 如果存在，读取 `design/systems/` 下相关的系统文档。
3. 在和实时游戏交互前确认 Studio 上下文：
   - 调用 `list_roblox_studios`
   - 必要时调用 `set_active_studio`
4. 如果安全且有必要，进入 Play 模式。
5. 收集证据：
   - `get_console_output`
   - 有针对性的实例检查
   - 仅在有助于复现问题时，再做角色移动或输入模拟
6. 除非用户明确要求保持运行，否则结束 Play 模式。

## 报告输出

把报告写到 `tests/playtest/YYYY-MM-DD-<topic>.md`，至少包含：

- 摘要
- 版本或上下文
- 复现步骤
- 预期结果
- 实际结果
- 控制台证据
- 严重程度
- 疑似影响区域
- 下一步建议

## 行为规则

- 优先给出可执行结论，不写空泛叙述。
- 如果没有发现问题，也要明确说明，并写清本次没有覆盖哪些内容。
- 报告要短而可扫描。
- 更新 `production/session-state/active.md`，记录报告路径和最高优先级后续动作。
