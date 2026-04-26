// ============================================================
// FILE: lib/models/user_model.dart
// ============================================================
//
// WHAT IS A MODEL?
// A Model is a class that represents a piece of data in your
// app. Think of it as a blueprint for an object. Here, UserModel
// describes what a "user" looks like — what data they have.
//
// WHY SEPARATE MODELS FROM UI?
// • If you need to change how user data is structured, you only
//   change it here — not in every screen.
// • Models have no Flutter widgets — they are pure Dart. This
//   means they are easy to test independently.
// • It follows the principle: "each file has one job".
//
// USE CASE: After registration, we create a UserModel and pass
// it from Login → Dashboard → DetailScreen without re-fetching.
// ============================================================

import '../enums/app_enums.dart';

class UserModel {
  // The actual data fields for a user
  final String fullName;
  final String email;
  final String password; // In a real app, NEVER store plain password!
  final Gender gender;

  // Constructor — 'required' means the caller MUST provide these
  // Named parameters (wrapped in {}) mean you call it like:
  //   UserModel(fullName: 'Ali', email: 'ali@x.com', ...)
  // This is safer than positional parameters because you can't
  // accidentally mix up the order of arguments.
  const UserModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.gender,
  });

  // copyWith — creates a new UserModel with some fields changed.
  // WHY? Models are immutable (final fields). To "update" a user
  // you create a new one with the changed fields.
  // Example: user.copyWith(fullName: 'New Name')
  UserModel copyWith({
    String? fullName,
    String? email,
    String? password,
    Gender? gender,
  }) {
    return UserModel(
      fullName:
          fullName ?? this.fullName, // ?? means "use new value OR keep old"
      email: email ?? this.email,
      password: password ?? this.password,
      gender: gender ?? this.gender,
    );
  }
}

// ── Subject Model ────────────────────────────────────────────
// Represents one subject shown on the Dashboard screen.
// When tapped, this data is passed to the Detail screen.
class SubjectModel {
  final String name; // e.g. "Mobile App Development"
  final String code; // e.g. "MAD-401"
  final String description; // Course overview text
  final String schedule; // e.g. "Monday & Wednesday, 10:00 AM"
  final String instructor; // Teacher name
  final String iconEmoji; // Emoji used as visual icon (no image file needed)
  final int colorValue; // Color for the card background

  const SubjectModel({
    required this.name,
    required this.code,
    required this.description,
    required this.schedule,
    required this.instructor,
    required this.iconEmoji,
    required this.colorValue,
  });
}
