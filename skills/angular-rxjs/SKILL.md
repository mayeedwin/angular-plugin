---
name: angular-rxjs
description: RxJS patterns in Angular — operators, signals interop, cleanup, and common recipes. Auto-invoked when using observables in Angular files.
---

# Angular RxJS Skill

**Reference**: https://angular.dev/ecosystem/rxjs-interop

## Operator Selection Guide

| Use case | Operator |
|---|---|
| Cancel previous on new emit (search, autocomplete) | `switchMap` |
| Sequential, ordered (form saves, queue) | `concatMap` |
| Parallel, all results needed (batch requests) | `mergeMap` |
| Ignore new while in-flight (login button) | `exhaustMap` |
| Combine latest from multiple streams | `combineLatest` |
| One-shot parallel requests | `forkJoin` |
| Transform each value | `map` |
| Filter values | `filter` |
| Side effects without transforming | `tap` |
| Catch and recover from errors | `catchError` |
| Retry on error | `retry({ count: 3, delay: 1000 })` |
| Emit only distinct consecutive values | `distinctUntilChanged` |
| Delay between key presses | `debounceTime(300)` |

## Signals Interop

### Observable → Signal (`toSignal`)

```typescript
import { toSignal } from '@angular/core/rxjs-interop';

readonly products = toSignal(this.productService.getAll(), { initialValue: [] });
// Use in template: products() — no async pipe needed
```

### Signal → Observable (`toObservable`)

```typescript
import { toObservable } from '@angular/core/rxjs-interop';

readonly searchTerm = signal('');
readonly results$ = toObservable(this.searchTerm).pipe(
  debounceTime(300),
  distinctUntilChanged(),
  switchMap(term => this.api.search(term)),
);
```

### `takeUntilDestroyed` — preferred cleanup

```typescript
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

private readonly destroyRef = inject(DestroyRef);

ngOnInit() {
  this.service.data$
    .pipe(takeUntilDestroyed(this.destroyRef))
    .subscribe(data => this.data.set(data));
}
```

## Common Angular Recipes

### Search with debounce

```typescript
readonly searchControl = new FormControl('');

readonly results = toSignal(
  this.searchControl.valueChanges.pipe(
    debounceTime(300),
    distinctUntilChanged(),
    switchMap(term => term ? this.api.search(term) : of([])),
    catchError(() => of([])),
  ),
  { initialValue: [] }
);
```

### Parallel HTTP requests

```typescript
readonly data = toSignal(
  forkJoin({
    users: this.userService.getAll(),
    roles: this.roleService.getAll(),
  }),
);
```

### Polling

```typescript
readonly liveData = toSignal(
  interval(5000).pipe(
    startWith(0),
    switchMap(() => this.api.getStatus()),
    takeUntilDestroyed(this.destroyRef),
  ),
);
```

### HTTP with loading + error state

```typescript
readonly vm = toSignal(
  this.trigger$.pipe(
    switchMap(() =>
      this.api.getData().pipe(
        map(data => ({ data, loading: false, error: null })),
        startWith({ data: null, loading: true, error: null }),
        catchError(err => of({ data: null, loading: false, error: err.message })),
      ),
    ),
  ),
);
```

## Error Handling

Always include `catchError` on HTTP chains — never let unhandled errors terminate streams:

```typescript
this.service.getItems().pipe(
  catchError(err => {
    console.error(err);
    return of([]);     // recover with fallback
  }),
)
```

Use `retry` for transient errors:
```typescript
this.api.call().pipe(
  retry({ count: 3, delay: 1000 }),
  catchError(err => of(null)),
)
```

## Rules

- Prefer `toSignal()` over `async` pipe for new code — integrates with signals
- Never `subscribe()` inside `subscribe()` — flatten with `switchMap`/`mergeMap`
- Every `subscribe()` in a component must be cleaned up (prefer `toSignal` or `takeUntilDestroyed`)
- Avoid `BehaviorSubject` when a `signal()` or `computed()` will do
- Use `Subject` only for event buses or imperative triggers
- Use `ReplaySubject(1)` when late subscribers need the last value
