import { useState } from "react";

export default function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div className="counter">
      <button onClick={() => setCount((c) => c - 1)} aria-label="Decrement">
        -
      </button>
      <span className="count">{count}</span>
      <button onClick={() => setCount((c) => c + 1)} aria-label="Increment">
        +
      </button>
    </div>
  );
}
