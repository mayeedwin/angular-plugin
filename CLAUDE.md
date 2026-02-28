# angular-plugin — Claude Code Instructions

You are contributing to an **open-source Claude Code plugin for Angular developers**.
The "code" here is primarily markdown — skills, commands, and agent definitions that Claude reads at runtime.
Every word in a skill or command file has a cost: keep content precise and concise.

---

## What this repo is

| Directory | Purpose |
|---|---|
| `commands/` | User-invoked slash commands (`/ng:*`) — markdown files |
| `skills/` | Model-invoked skills (`SKILL.md`) — Claude reads these automatically |
| `agents/` | Subagent definitions — specialist personas |
| `hooks/` | PostToolUse event handlers |
| `scripts/` | Shell utilities (lint hook, install-hooks) |
| `docs/` | Reference docs — `STRUCTURE.md` is the canonical Angular structure |
| `.claude-plugin/` | Plugin manifest only |

---

## Always-apply rules

- Arrow functions only — never `function` keyword (in any `.js` files)
- Keep `description` frontmatter to **one line** — it appears in `/help` and skill selectors
- Never add comments to skill/command files unless the instruction is genuinely non-obvious
- All Angular decisions must reference **https://angular.dev/llms.txt**
- `docs/STRUCTURE.md` is the single source of truth for Angular project structure
- Do NOT run install scripts or package managers unless explicitly asked
- Commit scope must match the area changed — run `git branch --show-current` first

---

## Commit format

```
type(scope): description
```

**Types:** `feat` | `fix` | `docs` | `style` | `refactor` | `test` | `chore` | `perf` | `ci` | `build` | `hotfix`

**Scopes:** `skills` | `commands` | `agents` | `hooks` | `docs` | `plugin` | `scripts` | `readme`

```bash
# Examples
feat(skills): add angular-signals skill
fix(commands): correct generate path resolution
docs(readme): update installation instructions
chore(plugin): bump version to 1.0.0
```

Install the commit hook after cloning: `bash scripts/install-hooks.sh`

---

## Writing skills

Skills are model-invoked — Claude decides when to use them based on the `description`.

- `description` must say **when** Claude should invoke the skill (not just what it does)
- Content should be lookup-style reference, not prose — tables and code blocks over paragraphs
- Every code template must compile — never generate code with syntax errors
- Angular version matters: check `package.json` before applying version-specific patterns
- Default to Angular 20 patterns unless the project's version requires otherwise

## Writing commands

Commands are user-invoked — clarity of the `$ARGUMENTS` interface is critical.

- Always show 3+ concrete usage examples in the command file
- State explicitly what Claude should do when `$ARGUMENTS` is empty or ambiguous
- Commands should detect project context (standalone vs module, Jest vs Karma) before acting

## Updating `docs/STRUCTURE.md`

This file is referenced by skills at runtime. When editing it:
- Keep the directory tree accurate
- Update the naming conventions table when Angular changes defaults
- Note the Angular version where a pattern was introduced

---

## Engineer setup (once after clone)

```bash
bash scripts/install-hooks.sh
```
