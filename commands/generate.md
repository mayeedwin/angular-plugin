---
description: >
  Generate Angular artifacts following the opinionated project structure.
  Usage: /ng:generate [type] [name] [path?]
  Types: component, service, pipe, directive, guard, interceptor, routes, store
  Mirrors Angular CLI (ng generate) conventions.
---

# Angular Generate

Generate Angular artifacts using `$ARGUMENTS` in the format: `[type] [name] [optional-path]`

**Examples:**
```
/ng:generate component user-profile pages/users
/ng:generate service auth core/services
/ng:generate guard auth core/guards
/ng:generate store products pages/products
/ng:generate pipe currency shared/pipes
/ng:generate routes dashboard pages/dashboard
```

## Instructions

You are acting as the Angular CLI (`ng generate`), adapted for this project's opinionated structure.

Parse `$ARGUMENTS` to extract:
1. **type** — one of: `component` | `service` | `pipe` | `directive` | `guard` | `interceptor` | `routes` | `store`
2. **name** — the artifact name in kebab-case
3. **path** (optional) — target directory relative to `src/app/`. If omitted, infer from type:
   - `component` → `shared/components/{name}/` (if no feature context) or `pages/{feature}/components/{name}/`
   - `service` → `core/services/` (singleton) or infer from context
   - `pipe`, `directive` → `shared/{type}s/{name}/`
   - `guard`, `interceptor` → `core/{type}s/`
   - `routes` → `pages/{name}/`
   - `store` → `pages/{name}/store/` or `store/`

If `$ARGUMENTS` is empty or ambiguous, ask the user:
- "What would you like to generate? (component | service | pipe | directive | guard | interceptor | routes | store)"
- "What should it be named?"
- "Where should it live? (e.g., pages/dashboard, shared, core)"

## Project Detection

Before generating, read the codebase to detect:
- `src/app/app.config.ts` → standalone project (default)
- `src/app/app.module.ts` → module-based project (adjust templates)
- `tsconfig.json` paths → available path aliases
- `package.json` → Angular version, NgRx presence

## Generation Rules

Follow all conventions in `docs/STRUCTURE.md`:

1. **Standalone** components by default (unless module-based project detected)
2. **`ChangeDetectionStrategy.OnPush`** on all components
3. **`inject()`** for all dependency injection — never constructor
4. **`@if` / `@for` / `@switch`** in templates — never `*ngIf` / `*ngFor`
5. **Functional** guards and interceptors — never class-based
6. **`takeUntilDestroyed()`** for subscription cleanup
7. Always create **`index.ts`** barrel alongside generated files
8. Use **path aliases** from tsconfig (e.g., `@shared/`, `@core/`) in imports
9. Include **.spec.ts** test file for every artifact (except routes and store index)
10. File names in **kebab-case**, classes in **PascalCase**

## Output

For each generated artifact, show:
1. The full file path
2. The complete file contents
3. Any updates needed in parent `index.ts` barrels
4. Any route registration needed in `app.routes.ts` or the parent feature routes

For a `store` type, generate all 5 files: `actions.ts`, `reducer.ts`, `selectors.ts`, `effects.ts`, `index.ts`

## After Generating

Tell the user:
- What was created and where
- Any manual steps needed (e.g., registering a route, providing a service)
- The import path to use when consuming the artifact (using path aliases)
