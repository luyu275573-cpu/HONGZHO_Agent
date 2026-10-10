# 2026-10-11 远程 Agent 构建证据

- 命令：`.\scripts\check-standard.ps1`
- 结果：`STANDARD CHECK PASSED`
- 命令：`.\scripts\build-harmony.ps1`
- 结果：`BUILD SUCCESSFUL`
- 产物：`entry/build/default/outputs/default/entry-default-unsigned.hap`
- 大小：`118715 bytes`
- 变更覆盖：`core/agent/RemoteAgent.ets` 和 OpenAI 工具 schema 转换编译通过。
- 设备：`127.0.0.1:5557` 模拟器。
- 安装：`hdc install -r` 返回 `install bundle successfully`。
- 启动：`aa start -a EntryAbility -b com.example.hongzhiagent` 返回 `start ability successfully`。
- 截图：`docs/qa/screenshots/2026-10-11-remote-agent.jpeg`，可见“鸿智 Agent”对话主页和本地提醒工具调用卡片。
- 说明：本次设备回归验证默认聊天页仍使用本地演示 Agent，未配置真实模型地址或 API Key。
