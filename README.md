
## Assignment 03: Extension Assignment Rubric Requirements

### Tools and Packages Used
- **State Management**: `flutter_riverpod` (Modern, robust provider-based state management).
- **Local Persistence**: `hive` and `hive_flutter` (Lightweight, fast NoSQL key-value database for offline caching).
- **Path Provider**: `path_provider` (Required for Hive initialization).
- **Networking**: `http` (Standard REST API calls).

### Branch Name
- `feature/offline-cache-and-state-manangement`

### Short Explanation of Offline and State Management Approach
- **State Management (Riverpod)**: Replaced `ChangeNotifier` with Riverpod's `AsyncNotifier`. This abstracts away the complexity of handling `loading`, `data`, and `error` states. The UI natively binds to these states using `ConsumerWidget`.
- **Offline Cache (Hive)**: Integrated a localized caching layer. Whenever course data is fetched successfully from the API, it is instantly serialized and stored in a Hive box.
- **Repository Pattern**: Created `CourseRepository` to act as a mediator. It attempts to fetch from `CourseService` (API). If the network request fails (e.g., offline mode), it catches the exception and falls back to loading data from `LocalStorageService` (Hive).
- **Optimistic UI Updates**: All write operations (add, update, delete) immediately manipulate the Riverpod UI state. The API call is triggered in the background. If the API fails, the state gracefully rolls back to its previous snapshot and displays an error SnackBar, ensuring no data loss and a highly responsive UX.

### Architecture Explanation
The application is structured into clearly separated layers adhering to Clean Architecture principles:
1. **UI Layer (`ConsumerWidget`)**: Listens reactively to Riverpod providers. Handles purely visual rendering and user input.
2. **State Management Layer (`AsyncNotifierProvider`)**: Manages the business logic state and optimistic UI updates.
3. **Repository Layer (`CourseRepository`)**: The single source of truth for data. It abstracts the decision between local cache and remote API.
4. **Service/Data Layer (`CourseService` & `LocalStorageService`)**: Handles raw data retrieval (HTTP requests and Hive box reads/writes).

---

## Assignment 03: Offline Cache & State Management Screenshots

### Extension Screenshots Preview
![Pull to Refresh](screenshots/Pull%20to%20refresh.png)
![Search Filter](screenshots/Search%20Filter.png)
![Search Empty](screenshots/Search%20Empty.png)
![Optimistic Rollback](screenshots/Optimistic%20Roll%20BAck.png)
