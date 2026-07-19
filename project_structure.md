# RouteX Project Structure & Architecture

## Feature-Based Architecture

RouteX utilizes a highly scalable, enterprise-grade **Feature-Based Architecture**. In contrast to a role-based architecture (e.g., separating by Passenger, Conductor, Admin), organizing the codebase by business features ensures maximum reusability, modularity, and separation of concerns.

### Why Feature-Based Architecture?
- **Reusability Across Roles:** A feature like `tickets` or `dashboard` can be accessed by both a Passenger and a Conductor without duplicating code. Role-specific behavior can be handled at the routing, presentation, or provider level.
- **Scalability:** As the application grows to support more roles and modules (Transport Manager, Super Admin), adding new features won't clutter existing domains.
- **Maintainability:** Developers can work on isolated features independently without causing merge conflicts in global folders. Each feature acts as a self-contained micro-app.

---

## Folder Responsibilities

### `lib/features/`
Contains isolated business features. Each feature contains its own clean architecture layers:
- **`presentation/`**: Contains the UI and state management elements.
  - `pages/`: Full screen widgets and routable screens (e.g., `home_page.dart`).
  - `widgets/`: Local UI components specific to this feature.
  - `providers/`: Riverpod state management and view-models specifically driving the UI state of this feature.
- **`domain/`**: Contains the business rules and contracts.
  - `repositories/`: Abstract classes (interfaces) defining how data is accessed for this feature.
- **`data/`**: Contains the data layer implementation.
  - `models/`: Data classes, DTOs, and serialization logic (from/to JSON).

### `lib/core/`
Contains application-wide configurations and essential foundational code that isn't specific to any single feature.
- `network/`: API clients, interceptors, and HTTP configuration.
- `errors/`: Custom exception classes, failure models, and global error handling.
- `storage/`: Local database, SharedPreferences, or secure storage logic.
- `di/`: Dependency injection setup or global provider definitions.

### `lib/shared/`
Contains reusable UI elements and visual components used across multiple distinct features.
- `components/`: Generic generic buttons, text fields, cards, and styling wrappers.
- `dialogs/`: Application-wide modal dialogs, alerts, and bottom sheets.
- `loading/`: Standardized loading indicators, spinners, and shimmer effects.
- `snackbar/`: Global notification banners, toasts, and snackbars.

---

## Best Practices

1. **Isolation:** A feature should never directly depend on the internal implementation (`data` layer) of another feature. If sharing is required, expose interfaces in the `domain` layer or move shared logic appropriately.
2. **No Role Silos:** Avoid creating folders for user roles. Features dictate *what* the application does, while router/permissions dictate *who* can access them.
3. **Immutability:** Always use immutable state and models to prevent unintended side-effects.
4. **Scoping:** Keep Riverpod providers scoped to their most relevant layer.

---

## Naming Conventions

Consistent naming is enforced across the entire RouteX project:

- **Folders & Directories:** `snake_case` (e.g., `transport_manager`, `ticket_booking`)
- **Files:** `snake_case.dart` (e.g., `home_page.dart`, `user_model.dart`)
- **Classes & Enums:** `PascalCase` (e.g., `HomePage`, `UserModel`, `AuthRepository`)
- **Variables & Methods:** `camelCase` (e.g., `userName`, `fetchTickets()`, `isLoading`)
