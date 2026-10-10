import {
  AgentDecision,
  AgentExecutor,
  AgentFinalDecision,
  AgentPlanner,
  AgentRunResult,
  AgentStep,
  AgentToolCall,
  AgentToolDecision,
  AgentLoop
} from './AgentLoop';
import { ToolRegistry } from '../../tools/ToolRegistry';
import { ToolRequest } from '../../model/ToolModels';

export class LocalDemoAgent {
  private readonly registry: ToolRegistry = new ToolRegistry();

  async run(input: string): Promise<AgentRunResult> {
    const planner: AgentPlanner = async (userInput: string, steps: AgentStep[]): Promise<AgentDecision> => {
      if (steps.length === 0 && userInput.indexOf('提醒') >= 0) {
        const call: AgentToolCall = {
          name: 'reminder.create',
          arguments: JSON.stringify({ time: '明天 10:00', title: '周会' })
        };
        const toolDecision: AgentToolDecision = {
          kind: 'tool',
          call: call
        };
        return toolDecision;
      }
      const finalDecision: AgentFinalDecision = {
        kind: 'final',
        content: '已收到你的需求，后续会继续处理。'
      };
      return finalDecision;
    };

    const executor: AgentExecutor = async (call: AgentToolCall): Promise<string> => {
      const request: ToolRequest = {
        name: call.name,
        arguments: call.arguments
      };
      return this.registry.execute(request);
    };

    return new AgentLoop(planner, executor).run(input);
  }
}
