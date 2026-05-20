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
  final String firstName;
  final String lastName;
  final String email;
  final String password; // In a real app, NEVER store plain password!
  final Gender gender;

  // Constructor — 'required' means the caller MUST provide these
  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
  });

  // Helper for full name
  String get fullName => '$firstName $lastName';

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'gender': gender.index,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      gender: Gender.values[json['gender']],
    );
  }

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    Gender? gender,
  }) {
    return UserModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
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
