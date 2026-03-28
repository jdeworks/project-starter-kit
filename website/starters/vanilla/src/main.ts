import { createCounter } from "./counter";

const container = document.querySelector<HTMLDivElement>("#counter");
if (container) {
  createCounter(container);
}
