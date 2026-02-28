---
description: Scaffold a complete NgRx feature store. Usage: /ng:store [feature-name] [path?]
---

# NgRx Store Generator

Scaffold a complete NgRx feature store for `$ARGUMENTS` (format: `[feature-name] [optional-path]`).

**Examples:**
```
/ng:store products pages/products
/ng:store auth core
/ng:store dashboard
```

## Instructions

Parse `$ARGUMENTS`:
- **feature-name**: the feature in kebab-case (e.g., `products`, `user-profile`)
- **path** (optional): parent directory relative to `src/app/`. Defaults to `pages/{feature-name}/store/`

Check `package.json` to confirm NgRx is installed. If not, tell the user to run:
```bash
ng add @ngrx/store @ngrx/effects @ngrx/store-devtools
```

## Files to Generate

Generate these 5 files at `src/app/{path}/store/`:

1. **`actions.ts`** — `createAction` with `props`, three actions per operation (load / success / failure)
2. **`reducer.ts`** — `createReducer` with `on()` handlers, typed state interface
3. **`selectors.ts`** — `createFeatureSelector` + `createSelector` for each state property
4. **`effects.ts`** — functional `createEffect` with `{ functional: true }`, error handling
5. **`index.ts`** — barrel re-exporting everything

## Templates

### `actions.ts`
```typescript
import { createAction, props } from '@ngrx/store';
import { {Name} } from '../interfaces/{name}.interface';

export const load{Name}s = createAction('[{Name}] Load');
export const load{Name}sSuccess = createAction(
  '[{Name}] Load Success',
  props<{ items: {Name}[] }>()
);
export const load{Name}sFailure = createAction(
  '[{Name}] Load Failure',
  props<{ error: string }>()
);
```

### `reducer.ts`
```typescript
import { createReducer, on } from '@ngrx/store';
import * as {Name}Actions from './actions';
import { {Name} } from '../interfaces/{name}.interface';

export const {NAME}_FEATURE_KEY = '{name}';

export interface {Name}State {
  items: {Name}[];
  loading: boolean;
  error: string | null;
}

export const initial{Name}State: {Name}State = {
  items: [],
  loading: false,
  error: null,
};

export const {name}Reducer = createReducer(
  initial{Name}State,
  on({Name}Actions.load{Name}s, state => ({ ...state, loading: true, error: null })),
  on({Name}Actions.load{Name}sSuccess, (state, { items }) => ({ ...state, loading: false, items })),
  on({Name}Actions.load{Name}sFailure, (state, { error }) => ({ ...state, loading: false, error })),
);
```

### `selectors.ts`
```typescript
import { createFeatureSelector, createSelector } from '@ngrx/store';
import { {Name}State, {NAME}_FEATURE_KEY } from './reducer';

export const select{Name}State = createFeatureSelector<{Name}State>({NAME}_FEATURE_KEY);
export const select{Name}Items = createSelector(select{Name}State, s => s.items);
export const select{Name}Loading = createSelector(select{Name}State, s => s.loading);
export const select{Name}Error = createSelector(select{Name}State, s => s.error);
```

### `effects.ts`
```typescript
import { inject } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { catchError, map, of, switchMap } from 'rxjs';
import * as {Name}Actions from './actions';
import { {Name}Service } from '../services/{name}.service';

export const load{Name}sEffect = createEffect(
  (actions$ = inject(Actions), service = inject({Name}Service)) =>
    actions$.pipe(
      ofType({Name}Actions.load{Name}s),
      switchMap(() =>
        service.getAll().pipe(
          map(items => {Name}Actions.load{Name}sSuccess({ items })),
          catchError(err => of({Name}Actions.load{Name}sFailure({ error: err.message }))),
        ),
      ),
    ),
  { functional: true },
);
```

### `index.ts`
```typescript
export * from './actions';
export * from './reducer';
export * from './selectors';
export * from './effects';
```

## After Generating

Show the user how to register the store in their app config or feature routes:

```typescript
// app.config.ts (root store)
provideStore({ [{NAME}_FEATURE_KEY]: {name}Reducer }),
provideEffects([load{Name}sEffect]),

// or in feature routes providers
providers: [
  provideState({NAME}_FEATURE_KEY, {name}Reducer),
  provideEffects([load{Name}sEffect]),
],
```
