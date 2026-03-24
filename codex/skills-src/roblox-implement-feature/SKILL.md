---
name: roblox-implement-feature
description: 根据设计文档实现或重构 Roblox 功能，把方案落到实际代码中，并在需要时结合 Studio 做验证。
---

# Roblox Implement Feature

当用户希望真正改代码，而不是只讨论方案时，使用这个 skill。

## 先读取

1. `AGENTS.md`
2. 如果相关，读取 `production/session-state/active.md`
3. 如果功能仍然受概念约束，读取 `design/gdd/game-concept.md`
4. 如果有助于判断边界和归属，读取 `design/gdd/systems-index.md`
5. 读取目标系统在 `design/systems/` 下的文档
6. 读取 `src/client/`、`src/server/`、`src/shared/` 下相关源码

## 实现规则

- 成长、奖励、购买、持久化以及所有信任敏感逻辑，默认由服务端最终裁决。
- 共享协议、枚举、配置和纯工具函数优先放到 `src/shared/`。
- 客户端代码聚焦于表现、输入手感和本地响应。
- 以“能完整交付这个功能的最小一致改动集”为目标，不要无关扩散。
- 如果用户要求运行时验证，或者真实逻辑只存在于 Studio 中，修改前要确认正确的 Studio 实例：
  - 调用 `list_roblox_studios`
  - 必要时调用 `set_active_studio`

## 验证要求

完成实现后，尽可能做下面这些验证：

- 回读修改后的文件
- 在合适时运行 `scripts/check-project.ps1` 等仓库脚本
- 如果任务涉及实时状态，检查对应的 Studio 脚本或实例
- 清楚说明哪些部分还没有验证到

## 完成规则

- 更新 `production/session-state/active.md`，记录改动文件、关键决策和下一步验证动作。
- 如果实现过程暴露出设计缺口，要明确写出应该补到 `design/systems/` 还是 `design/gdd/`。
