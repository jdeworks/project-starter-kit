/**
 * Pure greeting logic — no Tauri dependency.
 * Used for unit testing without the Tauri runtime.
 */
export function greet(name: string): string {
  if (!name.trim()) {
    return "Hello, stranger!";
  }
  return `Hello, ${name.trim()}!`;
}
