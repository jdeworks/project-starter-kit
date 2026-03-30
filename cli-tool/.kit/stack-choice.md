# Stack choice — CLI frameworks

This variant uses Node.js + Commander as its primary example. This doc explains when
to choose a different stack.

## Choose Node.js (Commander / oclif) when

- Your team knows JavaScript/TypeScript
- Distribution via `npx` is sufficient
- You need rich ecosystem (chalk, ora, inquirer, listr)
- Startup time is not critical (~200ms for Node)

## Choose Go (Cobra / Kong) when

- You need a single static binary with no runtime dependency
- Startup time matters (Go CLIs start in ~5ms)
- Cross-compilation is important (one `go build` for any OS/arch)
- Your CLI is performance-sensitive or processes large files

## Choose Rust (clap / argh) when

- Maximum performance and smallest binary size
- Memory safety is critical (processing untrusted input)
- You're building a tool that will be widely distributed
- Your team knows Rust or is willing to invest

## Choose Python (Click / Typer) when

- Your team is Python-first
- The CLI wraps Python libraries (ML, data processing, scripting)
- Distribution is internal (not public-facing) — Python dependency management is harder
- Rapid prototyping is the priority

## Mapping kit patterns to your stack

| Kit concept | Node.js | Go | Rust | Python |
|-------------|---------|-----|------|--------|
| Arg parsing | Commander / yargs | Cobra / Kong | clap / argh | Click / Typer |
| Colors | chalk | fatih/color | colored | click.style |
| Progress | ora / listr | schollz/progressbar | indicatif | tqdm / rich |
| Test runner | Vitest | `go test` | `cargo test` | pytest |
| Distribution | npm / pkg | `go build` | `cargo build` | pip / PyInstaller |
| Config files | cosmiconfig | viper | config-rs | dynaconf |
