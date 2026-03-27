# CLI tool starter

Command-line tools and utilities — argument parsing, output formatting, and distribution.

**Example stack:** Node.js + Commander (works with Go, Rust, Python — see [docs/stack-choice.md](docs/stack-choice.md))

## Get started

```bash
bash <(curl -sL https://raw.githubusercontent.com/jdeworks/project-starter-kit/dev/cli/get.sh) cli-tool my-cli
```

<details>
<summary>Manual setup</summary>

```bash
git clone --filter=blob:none --no-checkout --depth=1 -b dev \
  https://github.com/jdeworks/project-starter-kit.git /tmp/_psk
cd /tmp/_psk && git sparse-checkout init --cone
git sparse-checkout set base cli-tool cli && git checkout dev
bash cli/compose.sh --variant cli-tool --mode full --target ~/my-cli --yes
rm -rf /tmp/_psk && cd ~/my-cli
```

</details>

## What you get

```
my-cli/
├── AGENTS.md
├── Makefile
├── docs/
│   ├── cli-design.md       # Commands, subcommands, flags, error messages
│   ├── output-and-ux.md    # stdout/stderr, colors, progress, tables
│   ├── testing-clis.md     # Unit, integration, snapshot testing
│   ├── distribution.md     # npm, Homebrew, GitHub Releases, binaries
│   └── stack-choice.md     # Node.js vs Go vs Rust vs Python
├── scripts/
└── .claude/
```

## Next step

> Read AGENTS.md and tell me what mode we're in and what commands are available.
