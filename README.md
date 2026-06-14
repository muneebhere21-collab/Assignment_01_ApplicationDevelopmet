<div align="center">
  <h1>🎓 EduTrack - Student Portal Application</h1>
  <p>
    A complete, multi-screen Flutter application featuring secure user authentication, real-time form validation, and robust session persistence.
  </p>

  [![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
</div>

---

## 👨‍🎓 Student Information
- **Name:** Muneeb Ur Rehman 
- **ID:** SE-221039
- **Institution:** [Insert University Name]
- **Course:** Application Development

---

## ✨ Features
- **Authentication System:** Secure registration and login flow with mock backend logic.
- **Form Validation:** Comprehensive real-time validation for all input fields.
- **Session Persistence:** "Remember Me" functionality using `shared_preferences`.
- **Clean Architecture:** Proper separation of UI, business logic (controllers), and data models.
- **Premium UI:** Modern design with collapsing app bars, custom gradients, and responsive layouts.

## 📱 Screens
1. **Registration Screen:** Collects First Name, Last Name, Email, Gender, and Password. Includes complex password strength validation.
2. **Login Screen:** Authenticates users and offers session persistence. Features a password visibility toggle.
3. **Dashboard:** Displays user profile info and a list of academic subjects.
4. **Detail Screen:** Provides in-depth information about selected subjects including description and schedule.

## 🛠 Tech Stack
- **Framework:** Flutter
- **Language:** Dart
- **State Management:** ChangeNotifier / ListenableBuilder
- **Networking:** HTTP (`http` package)
- **Local Persistence:** SharedPreferences

---

## 🌐 Course API Integration

A dedicated Course Management module has been integrated into the student portal using RESTful API calls to JSONPlaceholder.

### API Specifications & Reference
- **API Target:** JSONPlaceholder REST API (simulated on `/posts`)
- **Documentation Reference:** [JSONPlaceholder Guide](https://jsonplaceholder.typicode.com/guide/)
- **Methods Implemented:**
  - `GET /posts`: Retrieve the directory of courses.
  - `POST /posts`: Create a new course record (simulated).
  - `PUT /posts/{id}`: Modify an existing course record (simulated).
  - `DELETE /posts/{id}`: Remove a course record (simulated).

### Clean Architecture Directory Structure
The course integration follows clean, decoupled architectural patterns:
```text
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

### API Integration Flow Overview
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

## 🚀 Getting Started
To set up and run the application locally:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/muneebhere21-collab/Assignment_01_ApplicationDevelopmet.git
   cd Assignment_01_ApplicationDevelopmet
   ```
2. **Fetch dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run unit tests (optional):**
   ```bash
   flutter test test/course_controller_test.dart
   ```
4. **Run the application:**
   ```bash
   flutter run
   ```

---

## 📸 Screenshots Overview

The application features a modern UI with full API CRUD integration. Screenshots are available in the `screenshots/` directory.

### Core Screenshots Preview
<div align="center">
  <img width="800" alt="Dashboard Preview" src="https://github.com/user-attachments/assets/765fc1f5-6cc1-45c5-be4a-82f8b4c1612f" />
  <br/><br/>
  <img width="800" alt="Login Preview" src="https://github.com/user-attachments/assets/e0d3a6e9-553f-4a3a-a597-b4e17632130b" />
  <br/><br/>
  <img width="800" alt="List Preview" src="https://github.com/user-attachments/assets/1d491b54-7d5f-4339-905b-116a0848040c" />
</div>

> [!NOTE]
> **API Persistence Notice:**
> JSONPlaceholder is a mock REST API. Creating, updating, or deleting courses sends requests that return simulated HTTP success statuses (e.g., `201 Created`, `200 OK`) and mock payloads, but changes are not permanently stored on the server. The application state updates reactively to display these operations locally.

---
<div align="center">
  <i>Developed with ❤️ for Academic Excellence</i>
</div>
