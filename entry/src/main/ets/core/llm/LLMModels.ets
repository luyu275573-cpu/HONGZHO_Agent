/**
 * OpenAI 兼容模型层的最小数据契约。
 *
 * 这些类型只描述请求和响应，不包含网络或 UI 依赖，便于在本地 mock 服务
 * 和后续 AgentLoop 接入时复用。
 */
export type MessageRole = 'system' | 'user' | 'assistant' | 'tool';

export interface Message {
  role: MessageRole;
  content: string;
  name?: string;
  toolCallId?: string;
}

export interface ToolSchema {
  name: string;
  description: string;
  parameters: Object;
}

export interface ToolCall {
  id: string;
  name: string;
  arguments: string;
}

export interface LLMConfig {
  baseUrl: string;
  apiKey: string;
  model: string;
  timeoutMs?: number;
}

export interface ChatResponse {
  content: string;
  toolCalls: ToolCall[];
  finishReason: string;
}
