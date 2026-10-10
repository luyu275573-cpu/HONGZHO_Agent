import {
  AgentDecision,
  AgentExecutor,
  AgentFinalDecision,
  AgentLoop,
  AgentPlanner,
  AgentRunResult,
  AgentStep,
  AgentToolCall,
  AgentToolDecision
} from './AgentLoop';
import { ChatResponse, LLMConfig, Message, ToolSchema } from '../llm/LLMModels';
import { LLMClient } from '../llm/LLMClient';
import { ToolRegistry } from '../../tools/ToolRegistry';
import { ToolSchema as RegistryToolSchema, ToolRequest } from '../../model/ToolModels';

/**
 * 使用 OpenAI 兼容模型进行规划的 Agent 适配层。
 *
 * 远程模型只负责决定下一步动作，实际工具仍由本地 ToolRegistry 执行。
 * 这样可以复用 AgentLoop 的最大循环次数、重复调用检测和异常收敛逻辑。
 */
export class RemoteAgent {
  private readonly config: LLMConfig;
  private readonly registry: ToolRegistry;

  constructor(config: LLMConfig, registry?: ToolRegistry) {
    this.config = config;
    this.registry = registry === undefined ? new ToolRegistry() : registry;
  }

  async run(input: string): Promise<AgentRunResult> {
    const messages: Message[] = [
      {
        role: 'system',
        content: '你是鸿智 Agent。请根据用户需求选择合适工具；工具结果会以文本回填。无需工具时直接给出简洁答复。'
      },
      { role: 'user', content: input }
    ];
    const tools: ToolSchema[] = this.buildToolSchemas();

    const planner: AgentPlanner = async (
      _userInput: string,
      _steps: AgentStep[]
    ): Promise<AgentDecision> => {
      const response: ChatResponse = await LLMClient.chat(this.config, messages, tools);
      if (response.toolCalls.length > 0) {
        const remoteCall = response.toolCalls[0];
        messages.push({
          role: 'assistant',
          content: response.content.length > 0
            ? response.content
            : '准备调用工具：' + remoteCall.name
        });
        const call: AgentToolCall = {
          name: remoteCall.name,
          arguments: remoteCall.arguments
        };
        const toolDecision: AgentToolDecision = {
          kind: 'tool',
          call: call
        };
        return toolDecision;
      }

      const finalDecision: AgentFinalDecision = {
        kind: 'final',
        content: response.content.trim().length > 0
          ? response.content
          : '模型没有返回可展示内容。'
      };
      return finalDecision;
    };

    const executor: AgentExecutor = async (call: AgentToolCall): Promise<string> => {
      const request: ToolRequest = {
        name: call.name,
        arguments: call.arguments
      };
      const result: string = await this.registry.execute(request);
      messages.push({
        role: 'user',
        content: '工具调用结果（' + call.name + '）：' + result
      });
      return result;
    };

    return new AgentLoop(planner, executor).run(input);
  }

  private buildToolSchemas(): ToolSchema[] {
    const registered: RegistryToolSchema[] = this.registry.listSchemas();
    const schemas: ToolSchema[] = [];
    for (let index = 0; index < registered.length; index++) {
      const registeredSchema: RegistryToolSchema = registered[index];
      const properties: Record<string, Object> = {};
      const required: string[] = [];
      for (let parameterIndex = 0; parameterIndex < registeredSchema.parameterNames.length; parameterIndex++) {
        const parameterName: string = registeredSchema.parameterNames[parameterIndex];
        properties[parameterName] = {
          type: 'string',
          description: '工具参数：' + parameterName
        };
        required.push(parameterName);
      }
      schemas.push({
        name: registeredSchema.name,
        description: registeredSchema.description,
        parameters: {
          type: 'object',
          properties: properties,
          required: required
        }
      });
    }
    return schemas;
  }
}
