import { describe, it, expect } from "vitest";
import { render, screen, fireEvent } from "@testing-library/react";
import "@testing-library/jest-dom";
import Counter from "../src/components/Counter";

describe("Counter", () => {
  it("renders with initial count of 0", () => {
    render(<Counter />);
    expect(screen.getByText("0")).toBeInTheDocument();
  });

  it("increments when + is clicked", () => {
    render(<Counter />);
    fireEvent.click(screen.getByLabelText("Increment"));
    expect(screen.getByText("1")).toBeInTheDocument();
  });

  it("decrements when - is clicked", () => {
    render(<Counter />);
    fireEvent.click(screen.getByLabelText("Decrement"));
    expect(screen.getByText("-1")).toBeInTheDocument();
  });
});
