---
name: angular-generate
description: >
  Generate Angular artifacts (components, services, pipes, directives, guards, interceptors, routes, stores).
  Use automatically when the user asks to create any Angular code, scaffold a feature, or add a new file
  to an Angular project. Mirrors Angular CLI conventions.
---

# Angular Generate Skill

**Primary reference**: https://angular.dev/llms.txt — always consult Angular documentation for current API.

## Before Generating — Detect Project Context

1. Check for `app.config.ts` (standalone app) vs `app.module.ts` (module-based app)
2. Read `tsconfig.json` to find path aliases (`@shared/*`, `@core/*`, etc.)
3. Check `package.json` for Angular version and installed packages (NgRx, signals API availability)
4. Look at 1-2 existing components to match the project's style (imports used, patterns preferred)
5. Check if Jest (`jest.config.js`) or Karma (`karma.conf.js`) is the test runner

## Artifact Reference (mirrors `ng generate`)

> **Angular 20+**: Component files use `{name}.ts` (no `.component.` suffix) with matching `{name}.html`, `{name}.scss`, `{name}.spec.ts`.
> All other artifacts retain their type suffix (`.service.ts`, `.pipe.ts`, etc.).

| Angular CLI | Plugin equivalent | Output |
|---|---|---|
| `ng g c {name}` | `/ng:generate component {name}` | `{name}.ts` + `{name}.html` + `{name}.scss` + `{name}.spec.ts` |
| `ng g s {name}` | `/ng:generate service {name}` | `{name}.service.ts` + `{name}.service.spec.ts` |
| `ng g p {name}` | `/ng:generate pipe {name}` | `{name}.pipe.ts` + `{name}.pipe.spec.ts` |
| `ng g d {name}` | `/ng:generate directive {name}` | `{name}.directive.ts` + `{name}.directive.spec.ts` |
| `ng g g {name}` | `/ng:generate guard {name}` | `{name}.guard.ts` + `{name}.guard.spec.ts` |
| `ng g interceptor {name}` | `/ng:generate interceptor {name}` | `{name}.interceptor.ts` + `{name}.interceptor.spec.ts` |
| `ng g r {name}` | `/ng:generate routes {name}` | `{name}.routes.ts` |
| — | `/ng:generate store {name}` | NgRx feature store (actions/reducer/selectors/effects/index) |

## Directory Placement (per docs/STRUCTURE.md)

- **Shared/reusable artifact**: `src/app/shared/{type}s/{artifact-name}/`
- **Feature-scoped artifact**: `src/app/pages/{feature}/{type}s/{artifact-name}/`
- **App-wide singleton service**: `src/app/core/services/`
- **App-wide guard/interceptor**: `src/app/core/guards/` or `src/app/core/interceptors/`
- **New feature page**: `src/app/pages/{feature}/`

Always create an `index.ts` barrel in the containing directory if one does not already exist.

## Component Template (standalone, OnPush)

```typescript
import { ChangeDetectionStrategy, Component, inject } from '@angular/core';

@Component({
  selector: 'app-{name}',
  standalone: true,
  imports: [],
  templateUrl: './{name}.component.html',
  styleUrl: './{name}.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class {Name}Component {
  // Use inject() — never constructor injection
  // private readonly service = inject({Name}Service);
}
```

HTML template — use new Angular control flow:
```html
<!-- @if / @for / @switch — never *ngIf / *ngFor -->
```

## Service Template (`providedIn: 'root'` default)

```typescript
import { inject, Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({ providedIn: 'root' })
export class {Name}Service {
  private readonly http = inject(HttpClient);
}
```

Use feature-level `providers` array in routes config when service must be scoped to a lazy route.

## Pipe Template (standalone)

```typescript
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({ name: '{name}', standalone: true, pure: true })
export class {Name}Pipe implements PipeTransform {
  transform(value: unknown, ...args: unknown[]): unknown {
    return value;
  }
}
```

## Directive Template (standalone)

```typescript
import { Directive, inject } from '@angular/core';

@Directive({ selector: '[app{Name}]', standalone: true })
export class {Name}Directive {
  // private readonly el = inject(ElementRef);
}
```

## Guard Template (functional — NOT class-based)

```typescript
import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';

export const {name}Guard: CanActivateFn = (route, state) => {
  const router = inject(Router);
  // return true | false | UrlTree
  return true;
};
```

## Interceptor Template (functional — NOT class-based)

```typescript
import { inject } from '@angular/core';
import { HttpInterceptorFn } from '@angular/common/http';

export const {name}Interceptor: HttpInterceptorFn = (req, next) => {
  return next(req);
};
```

## Routes Template

```typescript
import { Routes } from '@angular/router';
import { {Name}Component } from './{name}.component';

export const {NAME}_ROUTES: Routes = [
  {
    path: '',
    component: {Name}Component,
  },
];
```

## NgRx Store Template

`actions.ts`:
```typescript
import { createAction, props } from '@ngrx/store';

export const load{Name} = createAction('[{Name}] Load');
export const load{Name}Success = createAction('[{Name}] Load Success', props<{ data: {Name}[] }>());
export const load{Name}Failure = createAction('[{Name}] Load Failure', props<{ error: string }>());
```

`reducer.ts`:
```typescript
import { createReducer, on } from '@ngrx/store';
import * as {Name}Actions from './actions';

export interface {Name}State {
  data: {Name}[];
  loading: boolean;
  error: string | null;
}

const initialState: {Name}State = { data: [], loading: false, error: null };

export const {name}Reducer = createReducer(
  initialState,
  on({Name}Actions.load{Name}, state => ({ ...state, loading: true, error: null })),
  on({Name}Actions.load{Name}Success, (state, { data }) => ({ ...state, loading: false, data })),
  on({Name}Actions.load{Name}Failure, (state, { error }) => ({ ...state, loading: false, error })),
);
```

`selectors.ts`:
```typescript
import { createFeatureSelector, createSelector } from '@ngrx/store';
import { {Name}State } from './reducer';

export const select{Name}State = createFeatureSelector<{Name}State>('{name}');
export const select{Name}Data = createSelector(select{Name}State, s => s.data);
export const select{Name}Loading = createSelector(select{Name}State, s => s.loading);
export const select{Name}Error = createSelector(select{Name}State, s => s.error);
```

`effects.ts`:
```typescript
import { inject } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { catchError, map, of, switchMap } from 'rxjs';
import * as {Name}Actions from './actions';
import { {Name}Service } from '../services/{name}.service';

export const load{Name}Effect = createEffect(
  (actions$ = inject(Actions), service = inject({Name}Service)) =>
    actions$.pipe(
      ofType({Name}Actions.load{Name}),
      switchMap(() =>
        service.getAll().pipe(
          map(data => {Name}Actions.load{Name}Success({ data })),
          catchError(err => of({Name}Actions.load{Name}Failure({ error: err.message }))),
        ),
      ),
    ),
  { functional: true },
);
```

## RxJS Subscription Cleanup

Always use `takeUntilDestroyed()` — never `ngOnDestroy` + Subject pattern:

```typescript
private readonly destroyRef = inject(DestroyRef);

ngOnInit() {
  this.service.data$
    .pipe(takeUntilDestroyed(this.destroyRef))
    .subscribe(data => { /* ... */ });
}
```

## Barrel Export Pattern

After creating any artifact in a directory, ensure `index.ts` exports it:

```typescript
export * from './{name}.component';
export * from './{name}.service';
// etc.
```

## Strict TypeScript Rules

- Never use `any` — use `unknown` and narrow, or define an interface
- All function return types must be explicit
- All `@Input()` and `@Output()` must be typed
- Use `readonly` for injected dependencies and `signal()` values that should not be reassigned
