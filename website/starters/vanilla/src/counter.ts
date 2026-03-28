export function increment(count: number): number {
  return count + 1;
}

export function decrement(count: number): number {
  return count - 1;
}

export function createCounter(element: HTMLElement): void {
  let count = 0;

  const render = () => {
    element.innerHTML = `
      <div class="counter">
        <button id="dec" aria-label="Decrement">-</button>
        <span class="count">${count}</span>
        <button id="inc" aria-label="Increment">+</button>
      </div>
    `;
    element
      .querySelector("#inc")
      ?.addEventListener("click", () => {
        count = increment(count);
        render();
      });
    element
      .querySelector("#dec")
      ?.addEventListener("click", () => {
        count = decrement(count);
        render();
      });
  };

  render();
}
