# 鸿智 Agent

鸿智 Agent 是 HarmonyOS NEXT 原生一句话个人助理：用户用自然语言描述需求，Agent 规划并调用提醒、日历、天气、文件、搜索和记忆等工具完成任务。

## 当前技术基线

- HarmonyOS NEXT Stage 模型，ArkTS + ArkUI，API 26
- OpenAI 风格 HTTP/SSE 接口与 Function Calling
- RAG 知识库、会话记忆、Core Speech Kit 和多设备协同按里程碑逐步接入
- 工程入口：`entry/src/main/ets/entryability/EntryAbility.ets`
- 页面：`entry/src/main/ets/pages/`
- 纯逻辑核心：`entry/src/main/ets/core/`

## 构建与验证

```powershell
hvigorw assembleHap --no-daemon
.\scripts\build-harmony.ps1
.\scripts\check-standard.ps1
```

HAP 默认输出到 `entry/build/default/outputs/default/`。项目开发日志在 [changes.md](changes.md)，任务状态在 [tasks.md](tasks.md)。

## 目录约定

```text
entry/src/main/ets/
├── pages/       # 页面编排
├── components/  # 可复用 UI
├── core/        # Agent、LLM、RAG、记忆纯逻辑
├── tools/       # Function Calling 工具
├── service/     # 系统能力和持久化服务
├── model/       # 数据模型
└── common/      # DesignTokens 与共享常量
```

产品设计真源是 `docs/design.html`，项目约束和验收门禁见 `AGENTS.md`。
