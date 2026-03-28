const form = document.getElementById("greet-form") as HTMLFormElement;
const input = document.getElementById("greet-input") as HTMLInputElement;
const output = document.getElementById("greet-output") as HTMLParagraphElement;

form.addEventListener("submit", async (e) => {
  e.preventDefault();
  const name = input.value.trim();
  if (!name) return;

  // In a real app this would use contextBridge/preload for IPC.
  // For the starter, we call the shared greet logic directly.
  const { greet } = await import("../shared/greet");
  output.textContent = greet(name);
});
