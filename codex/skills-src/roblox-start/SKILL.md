---
name: roblox-start
description: 通过检查仓库状态、设计文档、代码布局和当前会话状态，帮助用户启动或恢复一个 Roblox 项目，并明确下一步最合适的动作。
---

# Roblox Start

当用户想开始项目、恢复中断的工作，或者不知道这个仓库下一步该做什么时，使用这个 skill。

## 工作流程

1. 读取 `AGENTS.md`。
2. 如果存在，读取 `production/session-state/active.md`。
3. 检查工作区中是否存在：
   - `design/gdd/game-concept.md`
   - `design/gdd/systems-index.md`
   - `design/systems/` 下的系统文档
   - `src/` 下的 Luau 脚本
4. 如果任务涉及实时验证、Studio 内对象或在线脚本，改动前先确认 Roblox Studio 状态：
   - 调用 `list_roblox_studios`
   - 必要时调用 `set_active_studio`
5. 用简短语言总结项目当前状态，并只推荐一个最合理的下一步。

## 推荐顺序

- 如果没有概念文档：建议先基于 `docs/templates/game-concept.md` 补 `design/gdd/game-concept.md`
- 如果概念文档已存在但没有系统总表：推荐 `roblox-map-systems`
- 如果系统总表已存在但目标功能没有系统设计文档：推荐 `roblox-design-system`
- 如果系统文档已经具备且用户要开始改代码：使用 `roblox-implement-feature`
- 如果代码已改完，用户要验证或回归：使用 `roblox-playtest-report`

## 行为规则

- 优先做合理假设，不要连续抛出多个开放问题。
- 如果缺少的信息会导致明显返工，最多只问一个阻塞性问题。
- 如果用户的意图是“开始做”，那就直接帮用户推进，而不是只给建议。
- 完成较大阶段后，更新 `production/session-state/active.md`。
