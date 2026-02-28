---
name: angular-performance
description: Angular performance patterns — OnPush, signals, defer, lazy loading, virtual scroll. Auto-invoked when reviewing or optimizing Angular code.
---

# Angular Performance Skill

**Reference**: https://angular.dev/guide/performance

## Change Detection

### Always use `OnPush`

```typescript
@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
})
```

With `OnPush`, the component only re-renders when:
- An `@Input()` reference changes
- An event originates from the component or its children
- `async` pipe emits
- `signal()` or `computed()` changes
- `markForCheck()` is called manually

### Signals over observables for local state

```typescript
// Prefer signals for component-local state — no zone involvement
readonly count = signal(0);
readonly doubled = computed(() => this.count() * 2);

// Use toSignal() to bridge observables
readonly users = toSignal(this.userService.getAll(), { initialValue: [] });
```

## Template Optimisation

### `@for` — `track` is mandatory

```html
<!-- Always provide a unique track expression -->
@for (item of items(); track item.id) {
  <app-item [item]="item" />
}
```

Poor `track` (avoid):
```html
@for (item of items(); track $index) { }  <!-- Forces full re-render on reorder -->
```

### `@defer` for below-the-fold content

```html
<!-- Defer heavy components until visible -->
@defer (on viewport) {
  <app-heavy-chart [data]="data()" />
} @placeholder {
  <div class="chart-skeleton"></div>
} @loading (minimum 200ms) {
  <app-spinner />
}
```

Use `@defer` triggers:
- `on viewport` — when element enters viewport
- `on idle` — when browser is idle
- `on interaction` — on click/focus
- `when condition` — when expression is true
- `on timer(2s)` — after delay

### Avoid function calls in templates

```html
<!-- Bad — called on every change detection cycle -->
<span>{{ formatDate(item.date) }}</span>

<!-- Good — computed once -->
<!-- In component: readonly formattedDate = computed(() => formatDate(this.item()?.date)); -->
<span>{{ formattedDate() }}</span>
```

## Images

Use `NgOptimizedImage` for all `<img>` tags:

```typescript
imports: [NgOptimizedImage]
```

```html
<!-- Automatic: lazy loading, size hints, LCP priority -->
<img ngSrc="/assets/hero.jpg" width="800" height="400" priority />
<img ngSrc="/assets/product.jpg" width="200" height="200" />
```

## Lazy Loading

### Routes — always lazy-load features

```typescript
{
  path: 'products',
  loadChildren: () => import('@pages/products/products.routes').then(m => m.PRODUCTS_ROUTES),
}
// or for single component:
{
  path: 'about',
  loadComponent: () => import('@pages/about/about.component').then(m => m.AboutComponent),
}
```

### Preloading strategy for key routes

```typescript
provideRouter(routes, withPreloading(PreloadAllModules))
// or custom: withPreloading(QuicklinkStrategy) from ngx-quicklink
```

## Virtual Scrolling

For lists with more than ~50 items:

```typescript
imports: [ScrollingModule]  // from @angular/cdk/scrolling
```

```html
<cdk-virtual-scroll-viewport itemSize="72" class="list-viewport">
  @for (item of items; track item.id) {
    <app-list-item *cdkVirtualFor="let item of items" [item]="item" />
  }
</cdk-virtual-scroll-viewport>
```

## Bundle Size

Flag these patterns as potential bundle bloat:
- Importing entire lodash: use `lodash-es` and named imports
- Large icon libraries: use SVG sprites or on-demand loading
- Importing entire moment.js: use `date-fns` or `dayjs`
- Not using `provideAnimationsAsync()` (defers animations module)

Check bundle budgets in `angular.json`:
```json
"budgets": [
  { "type": "initial", "maximumWarning": "500kb", "maximumError": "1mb" },
  { "type": "anyComponentStyle", "maximumWarning": "4kb" }
]
```

## Server-Side Rendering (SSR)

For public-facing apps, recommend:
```typescript
provideClientHydration(withEventReplay())
```

For pages that don't need SSR hydration, use render mode:
```typescript
// app.routes.server.ts
export const serverRouteConfig: ServerRoute[] = [
  { path: '/admin/**', mode: RenderMode.Client },
  { path: '/**', mode: RenderMode.Prerender },
];
```

## Zoneless (Angular 18+)

For maximum performance with signals-based apps:
```typescript
// app.config.ts
provideExperimentalZonelessChangeDetection()
```
Remove `zone.js` from `polyfills` in `angular.json` after enabling.
