import type { Command } from "commander";

/** Pure function: generate a count sequence from 1 to n. */
export function countSequence(n: number): number[] {
  return Array.from({ length: n }, (_, i) => i + 1);
}

export function registerCountCommand(program: Command): void {
  program
    .command("count <n>")
    .description("Count from 1 to n")
    .action((n: string) => {
      const num = parseInt(n, 10);
      if (isNaN(num) || num < 1) {
        console.error("Error: <n> must be a positive integer");
        process.exit(1);
      }
      countSequence(num).forEach((i) => console.log(i));
    });
}
