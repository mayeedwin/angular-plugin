---
name: angular-migration
description: Migrate deprecated Angular patterns to modern equivalents. Auto-invoked when editing NgModule files or using deprecated APIs.
---

# Angular Migration Skill

**Reference**: https://angular.dev/update-guide

## Detection — What to Flag

When reading Angular files, flag these patterns for migration:

| Deprecated pattern | Modern replacement |
|---|---|
| `*.module.ts` with declarations | Standalone components |
| `*ngIf`, `*ngFor`, `*ngSwitch` | `@if`, `@for`, `@switch` |
| `constructor(private svc: Service)` | `inject(Service)` |
| `ngOnDestroy` + Subject + `takeUntil` | `takeUntilDestroyed()` |
| Class-based `CanActivate` guard | `CanActivateFn` functional guard |
| Class-based `HttpInterceptor` | `HttpInterceptorFn` functional interceptor |
| `APP_INITIALIZER` + factory | `provideAppInitializer(() => ...)` |
| `RouterModule.forRoot()` | `provideRouter(routes)` in `app.config.ts` |
| `HttpClientModule` import | `provideHttpClient()` in `app.config.ts` |
| `BrowserModule` import | Remove — not needed for standalone |
| `platformBrowserDynamic().bootstrapModule` | `bootstrapApplication(AppComponent, appConfig)` |
| `Zone.js` dependency only | Consider zoneless: `provideExperimentalZonelessChangeDetection()` |

## Standalone Migration Rules

When converting a module-based component:
1. Add `standalone: true` to `@Component`
2. Copy `NgModule.imports` entries to component's `imports` array
3. Remove from `NgModule.declarations`
4. If module is now empty, delete it
5. Update parent routes to use `loadComponent` instead of `loadChildren`

## Control Flow Migration

Replace all structural directives in templates:

```html
<!-- Old → New -->
<div *ngIf="show">...</div>
→ @if (show) { <div>...</div> }

<div *ngIf="show; else other">...</div>
<ng-template #other>...</ng-template>
→ @if (show) { <div>...</div> } @else { ... }

<li *ngFor="let item of items; trackBy: trackById">...</li>
→ @for (item of items; track item.id) { <li>...</li> }

<div [ngSwitch]="status">
  <span *ngSwitchCase="'active'">Active</span>
</div>
→ @switch (status) { @case ('active') { <span>Active</span> } }
```

After migrating control flow, remove `CommonModule` if it was only providing `NgIf`/`NgFor`.

## `app.config.ts` Migration

```typescript
// Old: main.ts + AppModule
platformBrowserDynamic().bootstrapModule(AppModule);

// New: main.ts
bootstrapApplication(AppComponent, appConfig);

// New: app.config.ts
export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideHttpClient(withInterceptors([authInterceptor])),
    provideAnimationsAsync(),
    provideStore(),
    provideEffects(),
  ],
};
```

## Functional Guards Migration

```typescript
// Old
@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private auth: AuthService, private router: Router) {}
  canActivate(): boolean {
    return this.auth.isLoggedIn() || (this.router.navigate(['/login']), false);
  }
}

// New
export const authGuard: CanActivateFn = () => {
  return inject(AuthService).isLoggedIn() || inject(Router).createUrlTree(['/login']);
};
```

## Version-Specific Notes

- **Angular 14**: standalone components opt-in
- **Angular 15**: standalone stable, directive composition API
- **Angular 16**: required inputs, `DestroyRef`, `takeUntilDestroyed`
- **Angular 17**: `@if`/`@for`/`@switch` stable, `@defer` stable
- **Angular 18**: zoneless experimental, stable resource API
- **Angular 19**: incremental hydration, route-level render mode
- **Angular 20**: resource API stable, linked signals

Always check `package.json` Angular version before suggesting a migration — don't suggest APIs unavailable in the project's version.
