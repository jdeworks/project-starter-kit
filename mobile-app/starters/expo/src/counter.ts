export interface Counter {
  readonly value: number;
}

export function createCounter(initial = 0): Counter {
  return { value: initial };
}

export function increment(counter: Counter): Counter {
  return { value: counter.value + 1 };
}

export function decrement(counter: Counter): Counter {
  return { value: counter.value - 1 };
}

export function reset(): Counter {
  return { value: 0 };
}

export function getCount(counter: Counter): number {
  return counter.value;
}
