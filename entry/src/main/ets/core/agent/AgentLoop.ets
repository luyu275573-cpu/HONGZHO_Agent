export interface AgentToolCall {
  name: string;
  arguments: string;
}

export type AgentDecision =
  | { kind: 'final'; content: string }
  | { kind: 'tool'; call: AgentToolCall };

export type AgentStepStatus = 'planning' | 'executing' | 'completed' | 'failed';

export interface AgentStep {
  status: AgentStepStatus;
  toolName: string;
  detail: string;
}

export type AgentStopReason = 'completed' | 'max_loops' | 'loop_detected' | 'planner_error';

export interface AgentRunResult {
  answer: string;
  steps: AgentStep[];
  stoppedReason: AgentStopReason;
}

export type AgentPlanner = (input: string, steps: AgentStep[]) => Promise<AgentDecision>;
export type AgentExecutor = (call: AgentToolCall) => Promise<string>;

/**
 * 纯逻辑 Agent 循环：页面、LLM 和系统工具都通过函数注入，方便后续单测和替换。
 */
export class AgentLoop {
  static readonly MAX_LOOPS: number = 8;

  private planner: AgentPlanner;
  private executor: AgentExecutor;

  constructor(planner: AgentPlanner, executor: AgentExecutor) {
    this.planner = planner;
    this.executor = executor;
  }

  async run(userInput: string): Promise<AgentRunResult> {
    const steps: AgentStep[] = [];
    const seenCalls: string[] = [];

    for (let loop = 0; loop < AgentLoop.MAX_LOOPS; loop++) {
      let decision: AgentDecision;
      try {
        decision = await this.planner(userInput, steps);
      } catch (error) {
        return {
          answer: '暂时无法完成规划，请稍后重试。',
          steps: steps,
          stoppedReason: 'planner_error'
        };
      }

      if (decision.kind === 'final') {
        return {
          answer: decision.content,
          steps: steps,
          stoppedReason: 'completed'
        };
      }

      const signature: string = decision.call.name + ':' + decision.call.arguments;
      if (seenCalls.indexOf(signature) >= 0) {
        return {
          answer: '检测到重复工具调用，任务已停止。',
          steps: steps,
          stoppedReason: 'loop_detected'
        };
      }
      seenCalls.push(signature);
      steps.push({
        status: 'planning',
        toolName: decision.call.name,
        detail: '已生成工具调用计划'
      });

      let output: string = '';
      let failed: boolean = false;
      try {
        output = await this.executor(decision.call);
      } catch (error) {
        failed = true;
        output = '工具执行失败';
      }

      if (output.trim().length === 0) {
        failed = true;
        output = '工具没有返回结果';
      }

      steps.push({
        status: 'executing',
        toolName: decision.call.name,
        detail: '工具执行完成'
      });
      steps.push({
        status: failed ? 'failed' : 'completed',
        toolName: decision.call.name,
        detail: output
      });
    }

    return {
      answer: '任务过于复杂，请拆解后再试。',
      steps: steps,
      stoppedReason: 'max_loops'
    };
  }
}
