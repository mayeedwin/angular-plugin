---
description: Generate unit tests for an Angular file. Usage: /ng:test [file-path]
---

# Angular Test Generator

Generate unit tests for `$ARGUMENTS` (a file path or directory).

**Examples:**
```
/ng:test src/app/pages/dashboard/dashboard.component.ts
/ng:test src/app/shared/services/auth.service.ts
/ng:test src/app/pages/products/store/reducer.ts
/ng:test src/app/shared/pipes/currency.pipe.ts
```

If `$ARGUMENTS` is empty, generate tests for the most recently edited Angular file.

## Instructions

1. Read the source file at the given path
2. Detect the artifact type (component / service / pipe / directive / guard / reducer / selector / effect)
3. Detect the test runner from `package.json` (Jest or Karma/Jasmine)
4. Generate a `.spec.ts` file alongside the source file

Follow all patterns in `skills/angular-testing/SKILL.md`.

## What to Cover

**Components**: create, render, input binding, output emit, service interaction, template assertions
**Services**: creation, method return values, HTTP interactions (HttpTestingController), error handling
**Pipes**: transform with valid input, edge cases (null, undefined, empty), boundary values
**Directives**: host element mutations, input changes, event responses
**Guards**: permit access, deny access, redirect
**Reducers**: initial state, each `on()` case (load/success/failure)
**Selectors**: `.projector()` with mock state
**Effects**: success path, failure path (using mock actions$)

## Test File Placement

Place test at same location as source:
```
src/app/pages/dashboard/dashboard.component.ts
src/app/pages/dashboard/dashboard.component.spec.ts  ← here
```

## Output

Show the complete generated `.spec.ts` contents. Then tell the user:
- How to run just this test: `npx jest {filename}` or `ng test --include={path}`
- Any test utilities that should be added to `shared/testing/` if they'll be reused
