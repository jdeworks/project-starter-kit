#!/usr/bin/env node

import { Command } from "commander";
import { registerGreetCommand } from "./commands/greet.js";
import { registerCountCommand } from "./commands/count.js";

const program = new Command();

program
  .name("my-cli")
  .version("1.0.0")
  .description("A simple CLI tool built with Commander");

registerGreetCommand(program);
registerCountCommand(program);

program.parse();
