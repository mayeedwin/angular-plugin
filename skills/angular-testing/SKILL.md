---
name: angular-testing
description: >
  Write Angular unit tests. Use automatically when creating .spec.ts files, when asked to test
  Angular components/services/pipes/directives/guards, or when reviewing test coverage.
  Supports Jest and Jasmine/Karma. Mirrors Angular testing documentation.
---

# Angular Testing Skill

**Primary reference**: https://angular.dev/guide/testing — always consult for current testing APIs.

## Before Writing Tests — Detect Test Runner

1. Check `package.json` for `jest` (Jest) vs `karma` (Jasmine/Karma)
2. Check for `jest.config.js` or `jest.config.ts` (Jest)
3. Check for `karma.conf.js` (Karma/Jasmine)
4. Default assumption if neither: Jest (recommended for Angular 20)

Use `jest.fn()` for Jest mocks, `jasmine.createSpy()` for Jasmine mocks.

---

## Component Testing

### Standalone Component (default)

```typescript
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { {Name}Component } from './{name}.component';

describe('{Name}Component', () => {
  let component: {Name}Component;
  let fixture: ComponentFixture<{Name}Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [{Name}Component],  // standalone: import directly, not declarations
    }).compileComponents();

    fixture = TestBed.createComponent({Name}Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
```

### Component with Service Dependency

```typescript
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { {Name}Component } from './{name}.component';
import { {Name}Service } from '../services/{name}.service';

// Jest
const mockService = {
  getData: jest.fn().mockReturnValue(of([])),
};

// Jasmine
// const mockService = jasmine.createSpyObj('{Name}Service', ['getData']);

describe('{Name}Component', () => {
  let component: {Name}Component;
  let fixture: ComponentFixture<{Name}Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [{Name}Component],
      providers: [
        { provide: {Name}Service, useValue: mockService },
      ],
    }).compileComponents();

    fixture = TestBed.createComponent({Name}Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should load data on init', () => {
    expect(mockService.getData).toHaveBeenCalled();
  });
});
```

### Testing with Signals

```typescript
it('should update count signal', () => {
  component.increment();
  fixture.detectChanges();
  expect(component.count()).toBe(1);
});
```

---

## Service Testing

### Basic Service (no HTTP)

```typescript
import { TestBed } from '@angular/core/testing';
import { {Name}Service } from './{name}.service';

describe('{Name}Service', () => {
  let service: {Name}Service;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject({Name}Service);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
```

### Service with HTTP (HttpTestingController)

```typescript
import { TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting, HttpTestingController } from '@angular/common/http/testing';
import { {Name}Service } from './{name}.service';

describe('{Name}Service', () => {
  let service: {Name}Service;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        provideHttpClient(),
        provideHttpClientTesting(),
      ],
    });
    service = TestBed.inject({Name}Service);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => httpMock.verify());

  it('should fetch data', () => {
    const mockData = [{ id: 1 }];

    service.getAll().subscribe(data => {
      expect(data).toEqual(mockData);
    });

    const req = httpMock.expectOne('/api/{name}');
    expect(req.request.method).toBe('GET');
    req.flush(mockData);
  });
});
```

---

## Pipe Testing

```typescript
import { {Name}Pipe } from './{name}.pipe';

describe('{Name}Pipe', () => {
  const pipe = new {Name}Pipe();

  it('should transform value', () => {
    expect(pipe.transform('input')).toBe('expected-output');
  });

  it('should handle null/undefined', () => {
    expect(pipe.transform(null)).toBe('');
  });
});
```

---

## Directive Testing

```typescript
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Component } from '@angular/core';
import { {Name}Directive } from './{name}.directive';

@Component({
  standalone: true,
  imports: [{Name}Directive],
  template: `<div app{Name}>test</div>`,
})
class TestHostComponent {}

describe('{Name}Directive', () => {
  let fixture: ComponentFixture<TestHostComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [TestHostComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(TestHostComponent);
    fixture.detectChanges();
  });

  it('should apply directive', () => {
    const el = fixture.nativeElement.querySelector('[app{Name}]');
    expect(el).toBeTruthy();
  });
});
```

---

## NgRx Testing

### Reducer (pure function — no TestBed needed)

```typescript
import { {name}Reducer, initialState } from './reducer';
import * as {Name}Actions from './actions';

describe('{name}Reducer', () => {
  it('should set loading true on load action', () => {
    const state = {name}Reducer(initialState, {Name}Actions.load{Name}());
    expect(state.loading).toBe(true);
  });

  it('should populate data on success', () => {
    const data = [{ id: 1 }];
    const state = {name}Reducer(initialState, {Name}Actions.load{Name}Success({ data }));
    expect(state.data).toEqual(data);
    expect(state.loading).toBe(false);
  });
});
```

### Selectors

```typescript
import { select{Name}Data } from './selectors';

describe('{name} selectors', () => {
  const state = { data: [{ id: 1 }], loading: false, error: null };

  it('should select data', () => {
    expect(select{Name}Data.projector(state)).toEqual(state.data);
  });
});
```

### Effects (with provideMockActions)

```typescript
import { TestBed } from '@angular/core/testing';
import { provideMockActions } from '@ngrx/effects/testing';
import { Observable, of } from 'rxjs';
import { cold, hot } from 'jest-marbles'; // or 'jasmine-marbles'
import { load{Name}Effect } from './effects';
import { {Name}Service } from '../services/{name}.service';
import * as {Name}Actions from './actions';

describe('load{Name}Effect', () => {
  let actions$: Observable<any>;
  const mockService = { getAll: jest.fn() };

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        provideMockActions(() => actions$),
        { provide: {Name}Service, useValue: mockService },
      ],
    });
  });

  it('should dispatch success on load', () => {
    const data = [{ id: 1 }];
    mockService.getAll.mockReturnValue(of(data));
    actions$ = hot('-a', { a: {Name}Actions.load{Name}() });
    const expected = cold('-b', { b: {Name}Actions.load{Name}Success({ data }) });
    expect(TestBed.runInInjectionContext(() => load{Name}Effect())).toBeObservable(expected);
  });
});
```

---

## Guard Testing (functional)

```typescript
import { TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { {name}Guard } from './{name}.guard';
import { AuthService } from '@core/services/auth.service';

describe('{name}Guard', () => {
  let authService: jest.Mocked<AuthService>;
  let router: jest.Mocked<Router>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        { provide: AuthService, useValue: { isAuthenticated: jest.fn() } },
        { provide: Router, useValue: { navigate: jest.fn() } },
      ],
    });
    authService = TestBed.inject(AuthService) as jest.Mocked<AuthService>;
    router = TestBed.inject(Router) as jest.Mocked<Router>;
  });

  it('should allow access when authenticated', () => {
    authService.isAuthenticated.mockReturnValue(true);
    const result = TestBed.runInInjectionContext(() =>
      {name}Guard({} as ActivatedRouteSnapshot, {} as RouterStateSnapshot)
    );
    expect(result).toBe(true);
  });
});
```

---

## Testing Rules

- Always `afterEach(() => httpMock.verify())` when using `HttpTestingController`
- Use `fixture.detectChanges()` after state mutations in component tests
- Test reducers as pure functions without TestBed
- Test selectors using `.projector()` — no store setup needed
- Use `TestBed.runInInjectionContext()` to test functional guards/effects
- Mock all external dependencies — never make real HTTP calls in unit tests
- Cover: happy path, error path, edge cases (null, empty, boundary values)
