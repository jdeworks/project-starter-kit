import { invoke } from "@tauri-apps/api/core";

const form = document.getElementById("greet-form") as HTMLFormElement;
const input = document.getElementById("greet-input") as HTMLInputElement;
const output = document.getElementById("greet-output") as HTMLParagraphElement;

form.addEventListener("submit", async (e) => {
  e.preventDefault();
  const name = input.value.trim();
  if (!name) return;
  const message = await invoke<string>("greet", { name });
  output.textContent = message;
});
