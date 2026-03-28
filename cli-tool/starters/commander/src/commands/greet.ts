import type { Command } from "commander";

/** Pure function: build a greeting message. */
export function greetMessage(name: string): string {
  return `Hello, ${name}!`;
}

export function registerGreetCommand(program: Command): void {
  program
    .command("greet <name>")
    .description("Greet someone by name")
    .action((name: string) => {
      console.log(greetMessage(name));
    });
}
