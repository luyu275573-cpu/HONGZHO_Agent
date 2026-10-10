# 开发日志

## 2026-10-10

### HZ-002 AgentLoop 纯逻辑核心

- 目标：建立 AgentLoop 纯逻辑核心，约束循环上限和工具结果边界。
- 当前状态：`done`。
- 改动：新增 `AgentLoop`、工具调用契约、MAX_LOOPS、重复调用检测、规划异常、空结果和工具异常收敛。
- 验证：`scripts/check-standard.ps1` 返回 `STANDARD CHECK PASSED`；`scripts/build-harmony.ps1` 构建成功。
- 产物：`entry/build/default/outputs/default/entry-default-unsigned.hap`，98662 bytes。
- 遗留：真实 LLM、工具注册表和 core 单测将在后续接入阶段补充。

## 2026-10-10

### HZ-001 三页基础界面

- 用户目标：继续推进项目基本雏形。
- 改动：新增 Chat、Knowledge、Settings 页面和底部导航，保留本地假数据工具调用轨迹。
- 文件：`entry/src/main/ets/pages/Index.ets`、`Chat.ets`、`Knowledge.ets`、`Settings.ets`。
- 验证：`hvigorw assembleHap --no-daemon`，结果 `BUILD SUCCESSFUL`。
- 提交：`9af0078`。
- 遗留：真实模型、语音、真机和签名按用户要求延后。

### HZ-000 对话主页骨架

- 改动：消息气泡、三段 ToolCallCard、输入栏和 DesignTokens 字号。
- 验证：`hvigorw assembleHap --no-daemon`，结果 `BUILD SUCCESSFUL`。
- 提交：`d0a24f5`。
