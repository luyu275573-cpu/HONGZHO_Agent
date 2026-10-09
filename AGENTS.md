# AGENTS.md — 鸿智 Agent 项目上下文（AI 编码智能体必读）

> 本文档是 Codex / Claude / DeepSeek 等智能体在本项目工作时的唯一事实来源。

## 1. 项目一句话
「鸿智 Agent」：HarmonyOS NEXT 原生一句话个人助理，用户以自然语言描述需求，AI 自主规划、调用系统工具（提醒/日历/天气/文件/搜索/记忆）完成任务，支持多模型接入、流式对话、RAG 知识库、语音交互、智能体生态（意图框架/元服务/小艺 Claw）与多设备协同。

## 2. 技术栈（锁定，不得擅自更换）
- 平台：HarmonyOS NEXT（API 12+，本机 DevEco Studio 26 + OpenHarmony SDK API 26）
- 语言：ArkTS（纯 ArkTS）
- UI：ArkUI
- 大模型：HTTP/SSE，兼容 OpenAI 风格接口（DeepSeek-R1 / 通义 Qwen3 / Kimi K2 / 智谱 GLM）
- 工具调用：Function Calling（JSON Schema 定义工具）
- 知识库：RAG（切分 + 向量化 + 检索）
- 语音：Core Speech Kit（ASR/TTS）
- 智能体生态：意图框架 + 元服务 + 小艺 Claw
- 存储：RDB（会话/记忆）+ 文件（知识库）

## 3. 必读文档（本仓库 docs/）
| 文件 | 内容 |
|---|---|
| `docs/design.html` | UI 设计图（风格/配色/功能/5 屏）——**设计真源** |
| `docs/development-doc.md` | 详细开发文档 |
| `docs/agent-spec.md` | 智能体开发约束与规范 |

## 4. 目录结构（目标，重点：core/ 为 AI 核心层）
```
entry/src/main/ets/
├── entryability/
├── pages/              # Chat / Settings / Knowledge
├── components/         # MessageBubble / ToolCallCard（工具调用过程可视化）
├── core/               # ★ AI 核心层
│   ├── agent/          # AgentLoop / Planner / ToolExecutor
│   ├── llm/            # LLMClient / StreamParser(SSE)
│   ├── rag/            # DocumentLoader / Embedder / Retriever
│   └── memory/         # ConversationMemory / LongTermMemory
├── tools/              # WeatherTool / ReminderTool / CalendarTool / SearchTool ...
├── service/            # ReminderService / CalendarService
├── model/
└── common/DesignTokens.ets
```

## 5. 功能需求 + 验收清单
### 核心能力
1. **对话主页**：一句话任务、多轮追问、流式回答、Markdown 渲染
2. **工具编排**：规划 → 工具调用 → 结果回填 → 完成 可视化（25+ 系统工具）
3. **知识库**：文档上传/切分、RAG 检索问答、引用来源标注
4. **技能配置**：JSON 技能包热插拔、工具开关
5. **语音 + 多设备**：ASR/TTS、任务跨设备同步

### 验收（核心）
- [ ] 一句话「明天十点提醒我开会」→ 正确调用 reminder 工具并建提醒
- [ ] Agent 循环有 MAX_LOOPS 上限 + 循环检测，不死循环
- [ ] SSE 流式输出逐字渲染，工具调用过程可视化
- [ ] RAG 问答返回带编号出处（文档名/章节/片段）
- [ ] API Key 不硬编码（走服务端中转或安全存储）

## 6. 设计 Token（UI 必须引用，禁止硬编码色值）
见 `entry/src/main/ets/common/DesignTokens.ets`。
关键值：深底 `#0B1120`、天青 `#38BDF8`、紫罗兰 `#8B5CF6`、成功绿 `#22C55E`、
运行琥珀 `#F59E0B`；状态色约定：规划=蓝 / 执行=琥珀 / 完成=绿。

## 7. 编码约束（硬性规则）
1. 增量修改，禁止大文件覆盖式重写。
2. 颜色/字号/圆角引用 DesignTokens，禁止硬编码。
3. 多模型接口统一成 OpenAI 风格（baseUrl + apiKey 配置化）。
4. 工具调用必须有超时/空返回处理与循环上限。
5. API Key 不进代码库，走环境变量或安全存储。
6. core/ 层保持纯逻辑、可单测。
7. 每任务输出：改动说明 / 涉及文件 / 验证方式 / 遗留风险。

## 8. 构建与运行命令
```bash
hvigorw assembleHap             # 构建 HAP
hdc install <hap路径>           # 真机安装
# 模型联调：先本地起一个 mock OpenAI 兼容服务，或配置真实 baseUrl
```

## 9. 验收门禁
L1 构建通过 → L2 core 单测（Agent 循环/SSE 解析/工具参数）→ L3 真机跑通「一句话建提醒」链路（截图）→ L4 人工 review + 上架前检测。

## 10. 当前进度与第一步
- 当前：仓库已建，有本文件 + docs + 设计 Token；DevEco 工程骨架待生成。
- 第一步：用 DevEco Studio 新建空 Ability 工程（或手动补齐 hvigorfile.ts/module.json5/oh-package.json5），
  然后实现「对话主页」：消息气泡 + 工具调用过程卡片（ToolCallCard）+ 底部输入栏，对照 docs/design.html 第一、二屏；先用本地假数据。
- 每完成一个可验证单元就 git 提交。
