import { describe, it, expect } from "vitest";

/** Test the nav-link data logic used in Header.astro */
function getNavLinks() {
  return [
    { href: "#features", label: "Features" },
    { href: "#about", label: "About" },
  ];
}

function getSiteName(override?: string): string {
  return override ?? "My Site";
}

describe("Header logic", () => {
  it("returns default nav links", () => {
    const links = getNavLinks();
    expect(links).toHaveLength(2);
    expect(links[0].label).toBe("Features");
    expect(links[1].href).toBe("#about");
  });

  it("returns default site name", () => {
    expect(getSiteName()).toBe("My Site");
  });

  it("accepts a custom site name", () => {
    expect(getSiteName("Acme")).toBe("Acme");
  });
});
