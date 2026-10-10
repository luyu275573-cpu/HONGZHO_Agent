export interface ToolSchema {
  name: string;
  description: string;
  parameterNames: string[];
}

export interface ToolRequest {
  name: string;
  arguments: string;
}

export interface ToolRegistration {
  schema: ToolSchema;
  execute: (argumentsJson: string) => Promise<string>;
}
