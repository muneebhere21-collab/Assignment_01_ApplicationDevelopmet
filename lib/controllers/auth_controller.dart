// ============================================================
// FILE: lib/controllers/auth_controller.dart
// ============================================================
//
// WHAT IS A CONTROLLER?
// A Controller is the "brain" between your UI and your data/logic.
// The UI (screens) only handle what the user SEES and TAPS.
// The Controller handles WHAT HAPPENS as a result.
//
// This follows a pattern called MVC (Model-View-Controller):
//   Model      = user_model.dart   (the data structure)
//   View       = screens/*.dart    (what the user sees)
//   Controller = auth_controller.dart (the logic)
//
// WHY ChangeNotifier?
// ChangeNotifier is a Flutter class. When you call notifyListeners(),
// every widget that is "listening" to this controller will rebuild
// itself with the new data — like a live update.
//
// FLOW EXAMPLE:
//   1. User taps Login button
//   2. LoginScreen calls authController.login(email, password)
//   3. Controller sets status = AuthStatus.loading, calls notifyListeners()
//   4. LoginScreen sees status changed → shows loading spinner
//   5. Controller finishes → sets status = success, stores user
//   6. LoginScreen sees success → navigates to Dashboard
// ============================================================

import 'package:flutter/foundation.dart'; // provides ChangeNotifier
import '../enums/app_enums.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  // ── State Variables ────────────────────────────────────────
  // These are the pieces of data the controller tracks.
  // 'private' by convention (starts with _) — only changed inside this class.

  AuthStatus _status = AuthStatus.idle;
  String _errorMessage = '';
  UserModel? _currentUser; // null means no user is logged in
  bool _rememberMe = false;

  // In-memory "database" — stores registered users as a Map.
  // Map<String, UserModel>: key = email, value = user data.
  // In a real app this would be a real backend/database.
  final Map<String, UserModel> _registeredUsers = {};

  // ── Getters ────────────────────────────────────────────────
  // Getters are read-only access points for private variables.
  // Outside code can READ _status via authController.status
  // but cannot directly SET it — only this controller can.
  AuthStatus get status => _status;
  String get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get rememberMe => _rememberMe;
  bool get isLoggedIn => _currentUser != null;

  // ── Register Method ────────────────────────────────────────
  // Called when the user submits the Registration form.
  // async/await: this pretends to be async (like a real network call)
  // using Future.delayed to simulate a loading delay.
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required Gender gender,
  }) async {
    // Step 1: Set status to loading so UI shows a spinner
    _status = AuthStatus.loading;
    _errorMessage = '';
    notifyListeners(); // ← tells all listening widgets to rebuild

    // Step 2: Simulate a network delay (like calling a real API)
    await Future.delayed(const Duration(seconds: 1));

    // Step 3: Check if email already exists
    if (_registeredUsers.containsKey(email.toLowerCase())) {
      _status = AuthStatus.error;
      _errorMessage = 'An account with this email already exists.';
      notifyListeners();
      return; // stop here — don't register
    }

    // Step 4: Create user and save to our in-memory "database"
    final newUser = UserModel(
      fullName: fullName,
      email: email.toLowerCase(),
      password: password,
      gender: gender,
    );
    _registeredUsers[email.toLowerCase()] = newUser;

    // Step 5: Registration successful
    _status = AuthStatus.success;
    notifyListeners();
  }

  // ── Login Method ───────────────────────────────────────────
  // Called when the user submits the Login form.
  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = '';
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Check if the email exists in our "database"
    final user = _registeredUsers[email.toLowerCase()];

    if (user == null) {
      _status = AuthStatus.error;
      _errorMessage = 'No account found with this email.';
      notifyListeners();
      return;
    }

    // Check if password matches
    if (user.password != password) {
      _status = AuthStatus.error;
      _errorMessage = 'Incorrect password. Please try again.';
      notifyListeners();
      return;
    }

    // Login successful — store current user
    _currentUser = user;
    _rememberMe = rememberMe;
    _status = AuthStatus.success;
    notifyListeners();
  }

  // ── Logout Method ──────────────────────────────────────────
  void logout() {
    _currentUser = null;
    _status = AuthStatus.idle;
    _errorMessage = '';
    notifyListeners();
  }

  // ── Toggle Remember Me ─────────────────────────────────────
  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  // ── Reset Status ───────────────────────────────────────────
  // Called when navigating to a new screen so old error messages
  // don't show up on the new screen.
  void resetStatus() {
    _status = AuthStatus.idle;
    _errorMessage = '';
    notifyListeners();
  }
}
