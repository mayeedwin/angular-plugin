---
description: >
  Review Angular code for best practices, performance, and correctness.
  Checks components, services, templates, routing, NgRx, and RxJS patterns.
  Flags anti-patterns with specific fix suggestions.
---

# Angular Code Review

Review the Angular code specified in `$ARGUMENTS` (file path, directory, or "current file").
If `$ARGUMENTS` is empty, review the currently open or most recently edited Angular files.

**Examples:**
```
/ng:review
/ng:review src/app/pages/dashboard
/ng:review src/app/shared/components/user-card
```

## Instructions

You are a senior Angular architect performing a code review. Read the specified files and
check each category below. For every issue found, provide:
- The file and line number
- What the problem is
- The corrected code

**Primary reference**: https://angular.dev/llms.txt for current Angular best practices.

---

## Review Checklist

### 1. Standalone & Architecture
- [ ] Components are `standalone: true` (flag if using NgModule declarations unnecessarily)
- [ ] `app.config.ts` used instead of `AppModule` (for new apps)
- [ ] No barrel imports from wrong layer (pages importing from other pages directly)
- [ ] Feature services are provided at the correct scope (route vs root)

### 2. Change Detection
- [ ] All components use `ChangeDetectionStrategy.OnPush`
- [ ] Components using `Default` change detection — flag and suggest `OnPush`
- [ ] `async` pipe or signals used in templates instead of manual subscribe + assign

### 3. Dependency Injection
- [ ] `inject()` function used — flag constructor injection pattern
- [ ] No `@Optional()` or `@Self()` decorators used without clear reason

### 4. Template Quality
- [ ] New control flow syntax: `@if`, `@for`, `@switch` — flag `*ngIf`, `*ngFor`, `*ngSwitch`
- [ ] `@for` has `track` expression (required, not optional)
- [ ] No complex logic in templates — computed values belong in the component class
- [ ] No direct DOM manipulation (`document.getElementById`, etc.) — use `inject(ElementRef)` or `@ViewChild`
- [ ] XSS risk: `[innerHTML]` binding without `DomSanitizer`

### 5. RxJS & Subscriptions
- [ ] All subscriptions cleaned up with `takeUntilDestroyed()` or `async` pipe
- [ ] No `ngOnDestroy` + Subject unsubscribe pattern — flag, suggest `takeUntilDestroyed()`
- [ ] No `subscribe()` inside another `subscribe()` — flag, suggest `switchMap`/`mergeMap`
- [ ] No `.subscribe()` return value ignored when the observable is finite
- [ ] `catchError` present on HTTP observables

### 6. TypeScript Strictness
- [ ] No `any` type — flag every occurrence, suggest typed alternative
- [ ] All function return types are explicit (especially service methods)
- [ ] All `@Input()` and `@Output()` are typed
- [ ] No non-null assertions (`!`) without explanation
- [ ] Interfaces defined for all HTTP response shapes

### 7. Routing
- [ ] Lazy loading used for all feature routes (`loadChildren` or `loadComponent`)
- [ ] Functional guards used — flag class-based `CanActivate` guards
- [ ] Route resolvers are functional — flag class-based resolvers
- [ ] No hardcoded route strings — suggest route constants or typed router

### 8. NgRx (if present)
- [ ] Selectors are memoized with `createSelector` — flag direct store state access in components
- [ ] Effects handle errors with `catchError` returning a failure action
- [ ] No business logic in effects — effects orchestrate, services contain logic
- [ ] No store dispatches inside effects (use `tap` + dispatch if needed)
- [ ] `EntityAdapter` used for collections instead of manual array manipulation
- [ ] Actions follow `[Feature] Event` naming convention

### 9. Performance
- [ ] Images use `NgOptimizedImage` (`ngSrc`) if `@angular/common` is available
- [ ] Large lists use `@for` with `track` (required) — flag missing `track`
- [ ] `@defer` used for heavy components below the fold
- [ ] No unnecessary `detectChanges()` calls in `OnPush` components

### 10. File & Directory Structure
- [ ] Files follow naming convention: `{name}.ts` for components, `{name}.{type}.ts` for all other artifacts
- [ ] `index.ts` barrel exists in each directory
- [ ] Path aliases used in imports (not deep relative paths `../../../../`)
- [ ] Feature code is not imported directly between page features (must go through shared)

---

## Output Format

Structure the review as:

### Summary
- Total issues: N
- Critical: N | Warnings: N | Suggestions: N

### Issues

**[Critical | Warning | Suggestion]** `path/to/file.ts:line`
> **Issue**: Description of the problem
> **Fix**:
> ```typescript
> // corrected code
> ```

### What looks good
Brief praise for well-written patterns found in the code.
