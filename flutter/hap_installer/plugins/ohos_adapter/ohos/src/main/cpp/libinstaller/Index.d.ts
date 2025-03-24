export const startServer: () => number;
export const cmd: (cmd: string, callback: (result: number) => void) => number;
export const packTool: (cmd: string, callback: (result) => void) => number;