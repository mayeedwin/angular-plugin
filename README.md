# ng — Angular Plugin for Claude Code

An opinionated Angular development assistant for Claude Code. Generate, review, test, migrate, and document Angular apps following a battle-tested, production-proven structure — updated for Angular 20 standalone-first defaults.

## Install

> Requires Claude Code v1.0.33 or later. Run `claude --version` to check.

### Option 1 — Inside Claude Code (recommended)

Open Claude Code in any project and run these two commands:

```
# Step 1: add the marketplace
/plugin marketplace add mayeedwin/angular-plugin

# Step 2: install the plugin (user scope — available in all your projects)
/plugin install ng@angular-plugin
```

Verify it worked — run `/help` and look for `ng:*` commands in the list.

### Option 2 — CLI (non-interactive)

```bash
# Add the marketplace to your user settings
claude plugin install ng@angular-plugin
```

### Option 3 — Official Anthropic marketplace (pending review)

Once approved, no marketplace step needed:

```
/plugin install ng
```

### Option 4 — Local development / testing

```bash
git clone https://github.com/mayeedwin/angular-plugin
claude --plugin-dir ./angular-plugin
```

---

## Installation scopes

By default the plugin is installed to your **user** scope — available across all your projects.

| Scope | What it means | Install flag |
|---|---|---|
| `user` *(default)* | Available in all your projects | *(no flag needed)* |
| `project` | Checked into `.claude/settings.json` — shared with your team | `--scope project` |
| `local` | Project-specific, gitignored | `--scope local` |

**Share with your team** — install at project scope so everyone who clones the repo gets it:

```
/plugin install ng@angular-plugin --scope project
```

Or add to `.claude/settings.json` manually so Claude Code prompts teammates on first open:

```json
{
  "extraKnownMarketplaces": {
    "angular-plugin": {
      "source": { "source": "github", "repo": "mayeedwin/angular-plugin" }
    }
  },
  "enabledPlugins": {
    "ng@angular-plugin": true
  }
}
```

---

## Manage the plugin

All commands work both inside Claude Code (with `/`) and from the terminal (with `claude plugin`):

| Action | Inside Claude Code | Terminal |
|---|---|---|
| Update | `/plugin update ng@angular-plugin` | `claude plugin update ng@angular-plugin` |
| Disable (keep installed) | `/plugin disable ng@angular-plugin` | `claude plugin disable ng@angular-plugin` |
| Re-enable | `/plugin enable ng@angular-plugin` | `claude plugin enable ng@angular-plugin` |
| Uninstall | `/plugin uninstall ng@angular-plugin` | `claude plugin uninstall ng@angular-plugin` |

## Commands

| Command                              | Description                                                             |
| ------------------------------------ | ----------------------------------------------------------------------- |
| `/ng:generate [type] [name] [path?]` | Scaffold any Angular artifact — mirrors `ng generate`                   |
| `/ng:review [path?]`                 | Code review with categorised issues (blockers / warnings / suggestions) |
| `/ng:store [feature] [path?]`        | Generate a complete NgRx feature store                                  |
| `/ng:test [file-path]`               | Generate unit tests for any Angular artifact                            |
| `/ng:migrate [type] [path?]`         | Migrate deprecated patterns to modern Angular                           |
| `/ng:docs [file-path]`               | Add TSDoc comments and documentation                                    |

### Generate examples (mirrors Angular CLI)

```bash
/ng:generate component user-profile pages/users
/ng:generate service auth core/services
/ng:generate guard auth core/guards
/ng:generate interceptor jwt core/interceptors
/ng:generate pipe currency shared/pipes
/ng:generate directive click-outside shared/directives
/ng:generate routes dashboard pages/dashboard
/ng:generate store products pages/products
```

### Migrate examples

```bash
/ng:migrate standalone src/app/pages/users   # NgModule → standalone
/ng:migrate control-flow src/app             # *ngIf/*ngFor → @if/@for
/ng:migrate inject src/app/pages/dashboard   # constructor → inject()
/ng:migrate cleanup src/app                  # ngOnDestroy → takeUntilDestroyed()
/ng:migrate signals src/app/pages/products   # observables → signals
```

## Auto-invoked Skills

These run automatically based on what Claude is working on — no command needed:

| Skill                 | Triggers when...                         |
| --------------------- | ---------------------------------------- |
| `angular-generate`    | Creating any Angular file                |
| `angular-testing`     | Writing `.spec.ts` files                 |
| `ngrx-patterns`       | Working with NgRx store files            |
| `angular-rxjs`        | Using observables in Angular context     |
| `angular-migration`   | Editing `*.module.ts` or deprecated APIs |
| `angular-performance` | Reviewing component or routing code      |

## Agents

| Agent               | Purpose                                            |
| ------------------- | -------------------------------------------------- |
| `angular-architect` | Feature design, state strategy, module boundaries  |
| `angular-reviewer`  | Production readiness, security, performance review |

## Opinionated Structure

Based on a production-scale Angular 20 app. See [docs/STRUCTURE.md](./docs/STRUCTURE.md) for the full spec.

```
src/app/
├── core/           # Singletons: services, guards, interceptors
├── shared/         # Reusable: components, pipes, directives, utils
├── layouts/        # Shell layouts
├── pages/          # Feature areas (lazy-loaded)
│   └── {feature}/
│       ├── {feature}.ts         # Component (Angular 20: no .component. suffix)
│       ├── {feature}.routes.ts
│       ├── components/
│       ├── services/
│       ├── store/               # NgRx (optional)
│       └── index.ts
├── store/          # Root NgRx store (optional)
├── app.config.ts
└── app.routes.ts
```

### Key defaults

| Pattern                    | Default                                                    |
| -------------------------- | ---------------------------------------------------------- |
| Component files            | `{name}.ts` (Angular 20 — no `.component.` suffix)         |
| Service files              | `{name}.service.ts`                                        |
| Pipe/directive/guard files | `{name}.pipe.ts`, `{name}.directive.ts`, `{name}.guard.ts` |
| Components                 | `standalone: true` + `OnPush`                              |
| DI                         | `inject()` — not constructor                               |
| Template control flow      | `@if` / `@for` — not `*ngIf` / `*ngFor`                    |
| RxJS cleanup               | `takeUntilDestroyed()`                                     |
| Guards                     | Functional (`CanActivateFn`)                               |
| Modules                    | Not generated by default                                   |
| Barrels                    | `index.ts` in every directory                              |
| Path aliases               | `@shared/*`, `@core/*`, `@pages/*`                         |

## DX Features

- **Auto-lint hook** — runs ESLint + Prettier on every `.ts`/`.html`/`.scss` write
- **TypeScript LSP** — configures `typescript-language-server` for code intelligence

## Angular Reference

All patterns reference [angular.dev/llms.txt](https://angular.dev/llms.txt).

## Roadmap

- [x] Commands: `generate`, `review`, `store`, `test`, `migrate`, `docs`
- [x] Skills: `angular-generate`, `angular-testing`, `ngrx-patterns`, `angular-rxjs`, `angular-migration`, `angular-performance`
- [x] Agents: `angular-architect`, `angular-reviewer`
- [x] Hooks: auto-lint on file writes
- [x] LSP: TypeScript language server config
- [x] Self-hosted marketplace via GitHub (`/plugin marketplace add mayeedwin/angular-plugin`)
- [ ] Publish to Anthropic plugin marketplace (submitted — pending review)

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md). Issues and PRs welcome at [github.com/mayeedwin/angular-plugin](https://github.com/mayeedwin/angular-plugin).

### Setup (once after cloning)

```bash
bash scripts/install-hooks.sh
```

This installs a local `commit-msg` hook that validates your commit messages.

### Commit style

```
type(scope): description
```

| Part    | Values                                                                             |
| ------- | ---------------------------------------------------------------------------------- |
| `type`  | `feat` `fix` `docs` `style` `refactor` `test` `chore` `perf` `ci` `build` `hotfix` |
| `scope` | `skills` `commands` `agents` `hooks` `docs` `plugin` `scripts` `readme`            |

```bash
feat(skills): add angular-signals skill
fix(commands): correct generate path resolution
docs(readme): update installation instructions
chore(plugin): bump version to 1.0.0
```

## AI support

This repo ships instructions for Claude Code, GitHub Copilot, and other AI agents:

| File                                                                   | Purpose                                      |
| ---------------------------------------------------------------------- | -------------------------------------------- |
| [`CLAUDE.md`](./CLAUDE.md)                                             | Claude Code — detailed rules and conventions |
| [`AGENTS.md`](./AGENTS.md)                                             | Other AI agents (Codex, Gemini, etc.)        |
| [`.github/copilot-instructions.md`](./.github/copilot-instructions.md) | GitHub Copilot                               |

When using Claude Code in this repo, it automatically reads `CLAUDE.md` and applies the conventions.

## License

[MIT](./LICENSE) © [Maye Edwin](https://github.com/mayeedwin)
