---
description: Generate TSDoc comments and documentation for Angular code. Usage: /ng:docs [file-path]
---

# Angular Docs Generator

Add TSDoc comments to `$ARGUMENTS` (file path or directory).

**Examples:**
```
/ng:docs src/app/shared/services/auth.service.ts
/ng:docs src/app/pages/dashboard/dashboard.component.ts
/ng:docs src/app/shared/pipes/currency.pipe.ts
```

If `$ARGUMENTS` is empty, document the most recently edited file.

## Instructions

Read the target file(s) and add TSDoc comments. Do not change any logic — only add documentation.

## Documentation Rules

### Components
- Class-level `/** */` with: what the component does, selector, and key `@example` usage
- Document all `@Input()` properties: type, purpose, default value
- Document all `@Output()` events: what triggers them, payload type
- Document public methods called from templates

```typescript
/**
 * Displays a user's profile card with avatar and details.
 *
 * @example
 * <app-user-card [user]="currentUser" (edit)="onEdit($event)" />
 */
@Component({ selector: 'app-user-card', ... })
export class UserCardComponent {
  /** The user to display. Required. */
  @Input({ required: true }) user!: User;

  /** Emits the user when the edit button is clicked. */
  @Output() edit = new EventEmitter<User>();
}
```

### Services
- Class-level comment explaining what the service manages
- Every public method: what it does, `@param`, `@returns`, `@throws` if applicable

```typescript
/**
 * Manages authentication state and token lifecycle.
 */
@Injectable({ providedIn: 'root' })
export class AuthService {
  /**
   * Authenticates the user with email and password.
   * @param credentials - User login credentials
   * @returns Observable that emits the authenticated user or throws on failure
   */
  login(credentials: LoginCredentials): Observable<User> { ... }
}
```

### Pipes
- Class-level comment with transform description and `@example`
- `transform()` method: `@param`, `@returns`

### Interfaces / Types
- Interface-level comment describing what it represents
- Each property: inline comment explaining the field

```typescript
/** Represents a product in the catalog. */
export interface Product {
  /** Unique identifier. */
  id: string;
  /** Display name shown in listings. */
  name: string;
  /** Price in cents to avoid floating point issues. */
  priceInCents: number;
}
```

### NgRx Selectors
- Brief inline comment per selector explaining what it selects

### Enums
- Enum-level comment + each value

## Output

Show the full file with documentation added. Keep existing comments — only add where missing.
