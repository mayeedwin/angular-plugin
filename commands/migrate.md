---
description: Migrate Angular patterns to modern equivalents. Usage: /ng:migrate [type] [path?]
---

# Angular Migrate

Migrate Angular code to modern patterns. Parse `$ARGUMENTS` as `[type] [optional-path]`.

**Migration types:**
```
/ng:migrate standalone        # NgModule → standalone components
/ng:migrate control-flow      # *ngIf/*ngFor → @if/@for
/ng:migrate inject            # constructor DI → inject()
/ng:migrate cleanup           # ngOnDestroy+Subject → takeUntilDestroyed()
/ng:migrate signals           # manual state → Angular signals
```

If no type given, scan the target path and suggest which migrations apply.

---

## `standalone` — NgModule → Standalone

For each component in the target path:

1. Add `standalone: true` to `@Component` decorator
2. Move `NgModule.imports` to component's `imports` array
3. Remove the component from its `NgModule.declarations`
4. If the module is now empty (no declarations), offer to delete it
5. Update any `entryComponents` references (no longer needed)

```typescript
// Before
@NgModule({
  declarations: [UserCardComponent],
  imports: [CommonModule, RouterModule],
})
export class UserModule {}

@Component({ selector: 'app-user-card', templateUrl: '...' })
export class UserCardComponent {}

// After — module deleted, component is self-contained
@Component({
  selector: 'app-user-card',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: '...',
})
export class UserCardComponent {}
```

For routing modules, convert to `Routes` arrays:
```typescript
// Before: UserRoutingModule with RouterModule.forChild(routes)
// After: user.routes.ts
export const USER_ROUTES: Routes = [{ path: '', component: UserComponent }];
```

---

## `control-flow` — Template Syntax Migration

Replace deprecated structural directives with Angular 17+ control flow:

| Old | New |
|---|---|
| `*ngIf="x"` | `@if (x) { }` |
| `*ngIf="x; else tpl"` | `@if (x) { } @else { }` |
| `*ngFor="let i of items; trackBy: fn"` | `@for (i of items; track i.id) { }` |
| `*ngSwitch` / `*ngSwitchCase` | `@switch` / `@case` |
| `<ng-template #tpl>` (for else) | inline `@else { }` block |

Also remove `CommonModule` imports that were only needed for `NgIf`/`NgFor`.

---

## `inject` — Constructor DI → `inject()`

```typescript
// Before
constructor(
  private readonly userService: UserService,
  private readonly router: Router,
) {}

// After
private readonly userService = inject(UserService);
private readonly router = inject(Router);
```

Remove empty constructors after migration. Keep constructors only if they have logic.

---

## `cleanup` — `ngOnDestroy` + Subject → `takeUntilDestroyed()`

```typescript
// Before
private readonly destroy$ = new Subject<void>();

ngOnInit() {
  this.service.data$.pipe(takeUntil(this.destroy$)).subscribe(...);
}

ngOnDestroy() {
  this.destroy$.next();
  this.destroy$.complete();
}

// After
private readonly destroyRef = inject(DestroyRef);

ngOnInit() {
  this.service.data$.pipe(takeUntilDestroyed(this.destroyRef)).subscribe(...);
}
// ngOnDestroy removed entirely
```

---

## `signals` — Manual State → Signals

```typescript
// Before
items: Product[] = [];
loading = false;

ngOnInit() {
  this.service.getProducts().subscribe(items => {
    this.items = items;
    this.loading = false;
  });
}

// After — no subscribe needed
readonly items = toSignal(this.service.getProducts(), { initialValue: [] });
readonly loading = computed(() => this.items() === undefined);
```

---

## After Migration

For each file modified, show:
- What changed (summary)
- Any imports added/removed
- Whether any files can be deleted (empty modules, etc.)
- Any manual follow-up needed (e.g., registering standalone component in route)
