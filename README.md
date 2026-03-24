# Codex Team MobaDev

一个面向 Roblox 项目的 Codex 原生开发骨架，特别适合需要长期迭代的玩法型项目，尤其适合 MOBA、团队对抗、局内成长、轻中度 live game 这类“系统边界必须清楚”的项目。

它不是单纯的空仓库模板，而是一套把“概念设计 -> 系统拆分 -> 代码实现 -> Playtest 验证 -> 会话接力”串起来的协作结构。

---

## 为什么做这个仓库

很多 AI 协作开发项目前期推进很快，但很容易在中期失控：

- 需求只存在聊天记录里
- 系统边界越来越模糊
- 客户端、服务端、共享代码混在一起
- 改功能时找不到设计依据
- 一次会话结束后，下次很难恢复上下文

这个仓库就是为了解决这些问题。

它改造自 `Claude Code Game Studios`，但不依赖 Claude 的专属目录结构，而是重建成更适合 Codex 的版本：

- 用 `AGENTS.md` 作为仓库级说明入口
- 用 `codex/skills-src/` 管理可安装的 Codex skills
- 用中文模板管理概念文档、系统总表和系统设计文档
- 用 `production/session-state/active.md` 维护会话接力
- 用 Roblox Studio MCP 工作流承接验证和联调

---

## 这套结构适合做什么项目

最适合：

- Roblox MOBA 或小队对抗类项目
- 有明确局内循环的 PvP / PvE
- Tycoon / Simulator / Incremental
- 战斗闯关、塔防、生存、小型合作项目
- 1 到 5 人团队维护的中小型 live game

推荐规模：

- 团队人数：`1 到 5 人`
- 开发周期：`1 到 9 个月`
- 核心系统数：`3 到 12 个`
- 最佳阶段：`从原型验证到中型持续迭代`

不建议直接把它当成最终治理结构的项目：

- 超大型 MMO
- 多 Experience 平台化产品
- 以 UGC 创作生态为核心的平台
- 强依赖复杂后端平台的大型产品

详细建议见 [项目适配与规模建议](docs/项目适配与规模建议.md)。

---

## 仓库里有什么

- [AGENTS.md](AGENTS.md)
  - Codex 进入项目后的第一份说明
- `src/`
  - Roblox 代码主目录，按 `client / server / shared` 拆分
- `design/`
  - 概念文档、系统总表、系统设计文档
- `docs/`
  - 中文说明文档和模板
- `production/session-state/active.md`
  - 会话接力文档
- `codex/skills-src/`
  - 仓库内维护的 Codex skills 源码
- `scripts/`
  - 安装技能、检查仓库状态等辅助脚本

---

## 内置工作流

仓库目前内置 5 个核心 skills：

- `roblox-start`
  - 识别当前项目状态，推荐下一个动作
- `roblox-map-systems`
  - 把概念文档拆成系统总表
- `roblox-design-system`
  - 为单个系统编写详细设计文档
- `roblox-implement-feature`
  - 根据文档落地代码实现
- `roblox-playtest-report`
  - 联动 Roblox Studio 做验证并输出报告

---

## 快速开始

### 1. 安装仓库自带 skills

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-codex-skills.ps1
```

### 2. 检查当前仓库状态

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-project.ps1
```

### 3. 选择起步路径

如果你是新项目：

1. 先完善 [design/gdd/game-concept.md](design/gdd/game-concept.md)
2. 再运行 `roblox-map-systems`
3. 选出第一个 MVP 系统，运行 `roblox-design-system`
4. 然后进入 `roblox-implement-feature`
5. 最后用 `roblox-playtest-report` 做验证

如果你已经有 Roblox 代码基础：

1. 先用 `roblox-start` 盘点当前状态
2. 反写或补写概念文档
3. 生成系统总表
4. 只为当前正在改的系统补详细设计文档
5. 再继续实现和验证

---

## 推荐目录结构

```text
src/
  client/        客户端逻辑、输入、镜头、UI、表现层
  server/        服务端权威逻辑、结算、存档、反作弊
  shared/        共享常量、枚举、协议、配置、纯工具模块
design/
  gdd/           项目级文档，如概念文档、系统总表
  systems/       单系统详细设计文档
docs/
  templates/     模板
production/
  session-state/ 会话接力
tests/
  playtest/      测试与回归报告
codex/
  skills-src/    仓库内技能源码
```

详细说明见 [目录结构说明](docs/目录结构说明.md)。

---

## 文档导航

- [仓库工作约定](AGENTS.md)
- [工作流总览](docs/工作流总览.md)
- [项目适配与规模建议](docs/项目适配与规模建议.md)
- [目录结构说明](docs/目录结构说明.md)
- [概念文档模板](docs/templates/game-concept.md)
- [系统总表模板](docs/templates/systems-index.md)
- [系统设计模板](docs/templates/system-design-document.md)
- [Playtest 报告模板](docs/templates/playtest-report.md)

---

## 当前仓库状态

当前仓库已经完成：

- Git 初始化
- 中文化核心文档
- 中文化模板
- 可安装的 Codex skills
- 基础检查脚本
- 会话接力文件

下一步最推荐的动作是：先把 [design/gdd/game-concept.md](design/gdd/game-concept.md) 填成第一版，然后再生成 `systems-index.md`。
