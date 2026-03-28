/**
 * Pure greeting logic shared between main and renderer processes.
 */
export function greet(name: string): string {
  const trimmed = name.trim();
  if (!trimmed) {
    return "Hello, stranger!";
  }
  return `Hello, ${trimmed}!`;
}
