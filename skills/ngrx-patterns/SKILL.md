---
name: ngrx-patterns
description: NgRx best practices for actions, reducers, selectors, and effects. Auto-invoked when working with NgRx store files.
---

# NgRx Patterns Skill

**Reference**: https://angular.dev/llms.txt | https://ngrx.io

## Actions

- Use `createAction` with `props<T>()` — never string literals
- Name pattern: `[Feature] Event Description` (e.g., `[Products] Load Success`)
- Three-action pattern per async operation: trigger / success / failure
- Keep action props minimal — only what the reducer/effect needs

```typescript
export const loadProducts = createAction('[Products] Load');
export const loadProductsSuccess = createAction('[Products] Load Success', props<{ items: Product[] }>());
export const loadProductsFailure = createAction('[Products] Load Failure', props<{ error: string }>());
```

## Reducers

- Use `createReducer` with typed state interface
- `on()` handlers must be pure — no side effects, no mutation
- Always spread state: `{ ...state, changed: value }`
- Export `FEATURE_KEY` constant alongside reducer

```typescript
export const PRODUCTS_FEATURE_KEY = 'products';

export interface ProductsState {
  items: Product[];
  loading: boolean;
  error: string | null;
}

const initialState: ProductsState = { items: [], loading: false, error: null };

export const productsReducer = createReducer(
  initialState,
  on(ProductActions.loadProducts, state => ({ ...state, loading: true, error: null })),
  on(ProductActions.loadProductsSuccess, (state, { items }) => ({ ...state, loading: false, items })),
  on(ProductActions.loadProductsFailure, (state, { error }) => ({ ...state, loading: false, error })),
);
```

## Selectors

- Always use `createSelector` — never access store state directly in components
- Use `createFeatureSelector` as the root for a feature slice
- Each selector projects one piece of state

```typescript
export const selectProductsState = createFeatureSelector<ProductsState>(PRODUCTS_FEATURE_KEY);
export const selectProductItems = createSelector(selectProductsState, s => s.items);
export const selectProductsLoading = createSelector(selectProductsState, s => s.loading);

// Derived selectors — compose from primitives
export const selectActiveProducts = createSelector(
  selectProductItems,
  items => items.filter(p => p.active)
);
```

Test selectors with `.projector()` — no store needed:
```typescript
expect(selectActiveProducts.projector(mockItems)).toEqual(expected);
```

## Effects

- Use functional effects with `{ functional: true }`
- Effects handle side effects only — no business logic (that lives in services)
- Always handle errors with `catchError` returning a failure action
- Use `switchMap` for cancellable ops (search), `concatMap` for ordered, `mergeMap` for parallel, `exhaustMap` for non-interruptible (login)

```typescript
export const loadProductsEffect = createEffect(
  (actions$ = inject(Actions), service = inject(ProductsService)) =>
    actions$.pipe(
      ofType(ProductActions.loadProducts),
      switchMap(() =>
        service.getAll().pipe(
          map(items => ProductActions.loadProductsSuccess({ items })),
          catchError(err => of(ProductActions.loadProductsFailure({ error: err.message }))),
        ),
      ),
    ),
  { functional: true },
);
```

## Entity Collections

Use `EntityAdapter` for collections instead of arrays + manual manipulation:

```typescript
import { createEntityAdapter, EntityAdapter, EntityState } from '@ngrx/entity';

export interface ProductsState extends EntityState<Product> {
  loading: boolean;
  error: string | null;
}

export const adapter: EntityAdapter<Product> = createEntityAdapter<Product>();
export const initialState: ProductsState = adapter.getInitialState({ loading: false, error: null });

// Reducer
on(ProductActions.loadProductsSuccess, (state, { items }) =>
  adapter.setAll(items, { ...state, loading: false })
),

// Selectors (auto-generated)
const { selectAll, selectEntities, selectIds, selectTotal } = adapter.getSelectors();
export const selectAllProducts = createSelector(selectProductsState, selectAll);
```

## Store Registration

For standalone apps, register in `app.config.ts` or feature `providers`:

```typescript
// Root (app.config.ts)
provideStore(),
provideEffects(),
provideStoreDevtools({ maxAge: 25 }),

// Feature (lazy route providers)
provideState(PRODUCTS_FEATURE_KEY, productsReducer),
provideEffects([loadProductsEffect]),
```

## Component Usage

```typescript
export class ProductsComponent {
  private readonly store = inject(Store);

  readonly products = this.store.selectSignal(selectAllProducts);
  readonly loading = this.store.selectSignal(selectProductsLoading);

  ngOnInit() {
    this.store.dispatch(ProductActions.loadProducts());
  }
}
```

Prefer `selectSignal()` over `select()` + `async` pipe for signal-based components.
