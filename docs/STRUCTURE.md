# Opinionated Angular Project Structure

This document defines the canonical folder structure and conventions for Angular projects using this plugin.
It is derived from a production-scale Angular 20 application and modernised for Angular's standalone-first defaults.

Skills and commands in this plugin reference these conventions when generating or reviewing code.

---

## Project Layout

```
src/
├── app/
│   ├── core/                        # Singleton services, app-wide providers (loaded once)
│   │   ├── guards/                  # App-level functional route guards
│   │   ├── interceptors/            # HTTP interceptors
│   │   ├── services/                # App-wide singleton services
│   │   └── index.ts                 # Barrel export
│   │
│   ├── shared/                      # Reusable across all features
│   │   ├── components/              # Presentational / dumb components
│   │   ├── directives/              # Attribute and structural directives
│   │   ├── pipes/                   # Pure transform pipes
│   │   ├── services/                # Shared utility services (not singleton)
│   │   ├── guards/                  # Reusable functional guards
│   │   ├── utils/                   # Pure functions, helpers
│   │   ├── enums/                   # TypeScript enums
│   │   ├── interfaces/              # TypeScript interfaces and types
│   │   ├── constants/               # App-wide constants
│   │   ├── testing/                 # Test utilities, mocks, stubs
│   │   └── index.ts
│   │
│   ├── layouts/                     # Layout shell components (sidebar, topbar, page wrapper)
│   │   ├── default/
│   │   │   ├── default.layout.component.ts
│   │   │   ├── default.layout.component.html
│   │   │   └── default.layout.component.scss
│   │   └── index.ts
│   │
│   ├── pages/                       # Feature areas — each lazy-loaded via routes
│   │   └── {feature}/
│   │       ├── {feature}.component.ts
│   │       ├── {feature}.component.html
│   │       ├── {feature}.component.scss
│   │       ├── {feature}.routes.ts  # Standalone route config (NOT routing.module.ts)
│   │       ├── components/          # Local components used only by this feature
│   │       ├── services/            # Feature-scoped services
│   │       ├── pipes/
│   │       ├── directives/
│   │       ├── guards/
│   │       ├── interfaces/
│   │       ├── enums/
│   │       ├── store/               # NgRx feature store (if applicable)
│   │       │   ├── actions.ts
│   │       │   ├── reducer.ts
│   │       │   ├── selectors.ts
│   │       │   ├── effects.ts
│   │       │   └── index.ts
│   │       └── index.ts
│   │
│   ├── store/                       # Root NgRx store (if app uses NgRx globally)
│   │   ├── actions.ts
│   │   ├── reducer.ts
│   │   ├── selectors.ts
│   │   ├── effects.ts
│   │   └── index.ts
│   │
│   ├── app.component.ts             # Root component (standalone)
│   ├── app.component.html
│   ├── app.component.scss
│   ├── app.config.ts                # Application config (replaces AppModule)
│   └── app.routes.ts                # Root route definitions
│
├── assets/                          # Static files (images, fonts, icons)
├── environments/                    # Environment-specific config
│   ├── environment.ts
│   └── environment.prod.ts
└── styles/                          # Global SCSS (variables, mixins, resets)
    ├── _variables.scss
    ├── _mixins.scss
    └── styles.scss
```

---

## Per-Feature Page Structure

Each feature under `pages/{feature}/` follows this pattern:

```
pages/dashboard/
├── dashboard.ts                     # Smart/container component (Angular 20: no .component. suffix)
├── dashboard.html
├── dashboard.scss
├── dashboard.spec.ts                # Unit test
├── dashboard.routes.ts              # Route config for this feature
├── components/
│   ├── dashboard-stats/
│   │   ├── dashboard-stats.ts
│   │   ├── dashboard-stats.html
│   │   ├── dashboard-stats.scss
│   │   └── dashboard-stats.spec.ts
│   └── index.ts
├── services/
│   ├── dashboard.service.ts
│   ├── dashboard.service.spec.ts
│   └── index.ts
├── interfaces/
│   ├── dashboard.interface.ts
│   └── index.ts
├── enums/
│   ├── dashboard-status.enum.ts
│   └── index.ts
└── index.ts
```

---

## NgRx Store Layout

Each feature store follows this structure:

```
store/
├── actions.ts        # createAction with props — prefixed [FeatureName]
├── reducer.ts        # createReducer with on() handlers
├── selectors.ts      # createSelector + createFeatureSelector
├── effects.ts        # createEffect — side effects only, no business logic
└── index.ts          # Barrel: exports feature state, reducer, selectors, effects
```

Example action naming: `[Dashboard] Load Data`, `[Dashboard] Load Data Success`, `[Dashboard] Load Data Failure`

---

## Naming Conventions

> **Angular 20+**: Components no longer require the `.component.` type suffix in filenames.
> The Angular CLI now generates `{name}.ts` by default. All other artifact types retain their suffix.

| Artifact | File name | Class name | Selector |
|---|---|---|---|
| Component | `{name}.ts` | `{Name}Component` | `app-{name}` |
| Service | `{name}.service.ts` | `{Name}Service` | — |
| Pipe | `{name}.pipe.ts` | `{Name}Pipe` | `{name}` |
| Directive | `{name}.directive.ts` | `{Name}Directive` | `[app{Name}]` |
| Guard (functional) | `{name}.guard.ts` | — (function `{name}Guard`) | — |
| Interceptor (functional) | `{name}.interceptor.ts` | — (function `{name}Interceptor`) | — |
| Routes | `{name}.routes.ts` | — (const `{NAME}_ROUTES`) | — |
| Enum | `{name}.enum.ts` | `{Name}` | — |
| Interface | `{name}.interface.ts` | `I{Name}` or `{Name}` | — |
| Barrel | `index.ts` | — | — |
| Component test | `{name}.spec.ts` | — | — |
| Other tests | `{name}.{type}.spec.ts` | — | — |

**Directories**: always `kebab-case`
**Classes**: always `PascalCase`
**Methods/properties**: always `camelCase`
**Constants**: `UPPER_SNAKE_CASE`
**Enums**: `PascalCase` name, `PascalCase` values

---

## Path Aliases (tsconfig.json)

```json
{
  "compilerOptions": {
    "paths": {
      "@core/*":    ["./src/app/core/*"],
      "@shared/*":  ["./src/app/shared/*"],
      "@pages/*":   ["./src/app/pages/*"],
      "@layouts/*": ["./src/app/layouts/*"],
      "@store/*":   ["./src/app/store/*"],
      "@env/*":     ["./src/environments/*"],
      "@app/*":     ["./src/app/*"],
      "@src/*":     ["./src/*"]
    }
  }
}
```

Always use path aliases in imports. Never use deep relative paths like `../../../../shared/`.

---

## TypeScript Configuration

Required `compilerOptions` in `tsconfig.json`:

```json
{
  "compilerOptions": {
    "strict": true,
    "strictTemplates": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "esModuleInterop": true
  }
}
```

- No `any` — use `unknown` and narrow, or define proper interfaces
- All component inputs/outputs must be typed
- All service method return types must be explicit

---

## Angular 20 Modern Patterns (Mandatory)

### Components — always standalone

```typescript
@Component({
  selector: 'app-{name}',
  standalone: true,
  imports: [CommonModule, ...],
  templateUrl: './{name}.component.html',
  styleUrl: './{name}.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class {Name}Component {
  private readonly service = inject({Name}Service);
}
```

### Dependency Injection — always `inject()`, not constructor

```typescript
// Correct
private readonly userService = inject(UserService);

// Avoid
constructor(private userService: UserService) {}
```

### RxJS cleanup — `takeUntilDestroyed()`

```typescript
private readonly destroyRef = inject(DestroyRef);

ngOnInit() {
  this.service.data$
    .pipe(takeUntilDestroyed(this.destroyRef))
    .subscribe(data => this.data = data);
}
```

### Template control flow — new syntax only

```html
@if (user()) {
  <app-profile [user]="user()" />
}

@for (item of items(); track item.id) {
  <app-item [item]="item" />
}

@switch (status()) {
  @case ('active') { <span>Active</span> }
  @default { <span>Inactive</span> }
}
```

Do not use `*ngIf`, `*ngFor`, or `*ngSwitch` in new code.

### Route config — functional, no NgModules

```typescript
// {feature}.routes.ts
export const DASHBOARD_ROUTES: Routes = [
  {
    path: '',
    component: DashboardComponent,
  }
];

// app.routes.ts
{
  path: 'dashboard',
  loadChildren: () =>
    import('@pages/dashboard/dashboard.routes').then(m => m.DASHBOARD_ROUTES),
}
```

### Guards — functional

```typescript
export const authGuard: CanActivateFn = (route, state) => {
  const auth = inject(AuthService);
  return auth.isAuthenticated() || inject(Router).navigate(['/login']);
};
```

### Signals — use for local reactive state

```typescript
readonly count = signal(0);
readonly doubled = computed(() => this.count() * 2);

increment() {
  this.count.update(c => c + 1);
}
```

---

## What NOT to generate by default

- `*.module.ts` — only on explicit request
- `app.module.ts` — use `app.config.ts`
- Class-based guards/interceptors — use functional
- Constructor injection — use `inject()`
- `*ngIf` / `*ngFor` — use `@if` / `@for`
- `ngOnDestroy` + `Subject` for cleanup — use `takeUntilDestroyed()`
