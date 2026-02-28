# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] — 2026-02-28

### Added
- `/ng:generate` — scaffold Angular artifacts (component, service, pipe, directive, guard, interceptor, routes, store)
- `/ng:review` — Angular code review with categorised issues (blockers / warnings / suggestions)
- `/ng:store` — generate complete NgRx feature store (actions, reducer, selectors, effects, index)
- `/ng:test` — generate unit tests for any Angular artifact
- `/ng:migrate` — migrate deprecated patterns (standalone, control-flow, inject, cleanup, signals)
- `/ng:docs` — generate TSDoc comments for components, services, pipes, and interfaces
- `skills/angular-generate` — auto-invoked generation skill following opinionated structure
- `skills/angular-testing` — auto-invoked testing skill (Jest + Jasmine support)
- `skills/ngrx-patterns` — NgRx best practices (actions, reducers, selectors, functional effects)
- `skills/angular-rxjs` — RxJS patterns and signals interop
- `skills/angular-migration` — migration from deprecated to modern Angular patterns
- `skills/angular-performance` — OnPush, defer, virtual scroll, lazy loading, images
- `agents/angular-architect` — architecture design and feature planning
- `agents/angular-reviewer` — production readiness code review
- `hooks/hooks.json` — PostToolUse hook: auto-lint on `.ts`/`.html`/`.scss` writes
- `scripts/lint-angular.sh` — ESLint + Prettier runner triggered by hooks
- `.lsp.json` — TypeScript Language Server configuration
- `docs/STRUCTURE.md` — canonical opinionated Angular project structure reference
