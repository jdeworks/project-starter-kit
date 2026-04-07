import { defineConfig } from "vite";

export default defineConfig({
  root: ".",
  build: {
    outDir: "dist",
  },
  server: {
    watch: {
      ignored: ["**/.claude/**", "**/.kit/**", "**/CHANGES.md", "**/SESSION_SUMMARY.md", "**/server/**"],
    },
  },
});
