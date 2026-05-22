# EduTrack - Student Portal Application

A complete multi-screen Flutter application featuring user authentication, form validation, and session persistence.

## Student Information
- **Name:** Muneeb Ur Rehman 
- **ID:** SE-221039

## Features
- **Authentication System:** Secure registration and login flow with mock backend logic.
- **Form Validation:** Comprehensive real-time validation for all input fields.
- **Session Persistence:** "Remember Me" functionality using `shared_preferences`.
- **Clean Architecture:** Proper separation of UI, business logic (controllers), and data models.
- **Premium UI:** Modern design with collapsing app bars, custom gradients, and responsive layouts.

## Screens
1. **Registration Screen:** Collects First Name, Last Name, Email, Gender, and Password. Includes complex password strength validation.
2. **Login Screen:** Authenticates users and offers session persistence. Features a password visibility toggle.
3. **Dashboard:** Displays user profile info and a list of academic subjects.
4. **Detail Screen:** Provides in-depth information about selected subjects including description and schedule.

## Tech Stack
- **Framework:** Flutter
- **Language:** Dart
- **State Management:** ChangeNotifier / ListenableBuilder
- **Networking:** HTTP (http package)
- **Local Persistence:** SharedPreferences

## Course API Integration

A dedicated Course Management module has been integrated into the student portal using RESTful API calls to JSONPlaceholder.

### 1. API Specifications & Reference
- **API Target:** JSONPlaceholder REST API (simulated on `/posts`)
- **Documentation Reference:** [JSONPlaceholder Guide](https://jsonplaceholder.typicode.com/guide/)
- **Methods Implemented:**
  - `GET /posts`: Retrieve the directory of courses.
  - `POST /posts`: Create a new course record (simulated).
  - `PUT /posts/{id}`: Modify an existing course record (simulated).
  - `DELETE /posts/{id}`: Remove a course record (simulated).

### 2. Version Control Branch Details
- **Branch Name:** `feature/course-api-integration`

### 3. Setup and Run Instructions
To set up and run the application locally on this branch:
1. Ensure Flutter SDK is installed (`>=3.0.0 <4.0.0`).
2. Clone the repository and navigate to the project directory:
   ```bash
   cd Assignment_01_ApplicationDevelopmet-main
   ```
3. Checkout the feature branch:
   ```bash
   git checkout feature/course-api-integration
   ```
4. Fetch dependencies (including `http`):
   ```bash
   flutter pub get
   ```
5. Run the unit tests to verify the API layer:
   ```bash
   flutter test test/course_controller_test.dart
   ```
6. Run the application on your connected emulator/device:
   ```bash
   flutter run
   ```

### 4. Clean Architecture Directory Structure
The course integration follows clean, decoupled architectural patterns:
```
lib/
├── models/
│   └── course_model.dart       # Course entity definitions & JSON serialization
├── services/
│   └── course_service.dart      # Low-level network HTTP requests (GET, POST, PUT, DELETE)
├── controllers/
│   └── course_controller.dart   # Business logic, state tracking, notifying listeners via ChangeNotifier
├── widgets/
│   └── course_form_dialog.dart  # Reusable form dialog for inputting and validating titles/descriptions
└── screens/
    ├── course_list_view.dart    # Main CRUD listing screen displaying loaders, error boxes, and cards
    └── course_detail_screen.dart# Deep-dive detail screen displaying complete course body and metadata
```

### 5. API Integration Flow Overview
The data flow and state changes are driven reactively:

```mermaid
sequenceDiagram
    participant UI as Flutter UI (CourseListView / CourseFormDialog)
    participant Ctrl as CourseController (ChangeNotifier)
    participant Service as CourseService (HTTP Client)
    participant API as JSONPlaceholder REST API

    UI->>Ctrl: Request Operation (e.g. addCourse, fetchCourses)
    Note over Ctrl: Sets isLoading = true<br/>Clears errors<br/>Notifies UI
    Ctrl->>Service: Network Call
    Service->>API: HTTP Request (GET/POST/PUT/DELETE)
    API-->>Service: HTTP JSON Response
    Service-->>Ctrl: Returns parsed Model(s) / Success
    Note over Ctrl: Updates local list state<br/>Sets isLoading = false<br/>Notifies UI (ListenableBuilder)
    Ctrl-->>UI: UI Rebuilds with New State
```

---

## Getting Started
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Run the application using `flutter run`.

## Course API Integration CRUD Screenshots Checklist

To submit the assignment, please place your screen captures in a `screenshots/` directory at the root of the project with the following filenames:

| # | Screen Name / Operation | Suggested Filename | Description / Elements to Show | Status |
|---|------------------------|--------------------|---------------------------------|--------|
| 1 | **Login Screen** | `login_screen.png` | Email & Password fields, Validation/UI | Complete |
| 2 | **Dashboard / Home Screen** | `dashboard_screen.png` | Course tab visible, Navigation working | Complete |
| 3 | **Loading State** | `loading_state.png` | Shimmer/Loading skeleton active while fetching | Complete |
| 4 | **Courses Fetched from API** | `courses_loaded.png` | GET list displaying simulated course names and IDs | Complete |
| 5 | **Add Course Screen/Form** | `add_course.png` | POST dialog with form fields and Create button | Complete |
| 6 | **Successful Course Added** | `successful_course_added.png` | Snackbar notification and new item displayed | Complete |
| 7 | **Edit Course Screen** | `edit_course.png` | PUT dialog with pre-filled course title/body | Complete |
| 8 | **Updated Course Result** | `updated_course_result.png` | Updated title/content reflected in the UI list | Complete |
| 9 | **Delete Confirmation Dialog** | `delete_confirmation.png` | Confirmation Alert Dialog ("Are you sure...") | Complete |
| 10 | **Course Deleted Successfully** | `course_deleted_successfully.png` | Item removed from list and deletion Snackbar shown | Complete |
| 11 | **Error State Screen** | `error_state_screen.png` | Offline/Network loss indicator with "Try Again" | Complete |
| 12 | **GitHub Branch Screenshot** | `github_branch_screenshot.png` | Command line or Git GUI showing `feature/course-api-integration` | Complete |
| 13 | **API Service Layer Structure** | `api_service_layer_structure.png` | Folder structure showcasing clean architecture directories | Optional |
| 14 | **README Documentation Screen** | `readme_screenshot.png` | Rendered README showing branch, API ref, and setup steps | Optional |

> [!NOTE]
> **API Persistence Notice:**
> JSONPlaceholder is a fake/mock REST API. Creating, updating, or deleting courses sends requests that return simulated HTTP success statuses (e.g. `201 Created`, `200 OK`) and mock payloads, but changes are not permanently stored on the server. The application state updates reactively to display these operations locally.

---

## Assignment 2 Tasks

The following screenshots demonstrate the completion of the API Integration CRUD assignment operations:

![1](screenshots/1.png)
![2](screenshots/2.png)
![Screenshot 1](screenshots/Screenshot%202026-05-22%20154349.png)
![Screenshot 2](screenshots/Screenshot%202026-05-22%20154427.png)
![Screenshot 3](screenshots/Screenshot%202026-05-22%20154559.png)
![Screenshot 4](screenshots/Screenshot%202026-05-22%20154632.png)
![Screenshot 5](screenshots/Screenshot%202026-05-22%20154708.png)
![Screenshot 6](screenshots/Screenshot%202026-05-22%20154735.png)

---

### Core Screenshots Preview
<img width="1920" height="897" alt="image" src="https://github.com/user-attachments/assets/765fc1f5-6cc1-45c5-be4a-82f8b4c1612f" />
<img width="1908" height="901" alt="image" src="https://github.com/user-attachments/assets/e0d3a6e9-553f-4a3a-a597-b4e17632130b" />
<img width="1851" height="755" alt="image" src="https://github.com/user-attachments/assets/1d491b54-7d5f-4339-905b-116a0848040c" />
<img width="1911" height="854" alt="image" src="https://github.com/user-attachments/assets/5bf2cf7a-cf6f-48a8-b8f8-d46b8ce4bc83" />
<img width="1912" height="890" alt="image" src="https://github.com/user-attachments/assets/cae3ed0b-7cfa-41fe-8ace-5a2f40fe559d" />
<img width="1913" height="903" alt="image" src="https://github.com/user-attachments/assets/40e29602-7149-4150-89e3-f282eed04280" />

