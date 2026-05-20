// ============================================================
// FILE: lib/enums/app_enums.dart
// ============================================================
//
// WHAT IS AN ENUM?
// An enum (enumeration) is a special type that defines a fixed
// set of named constant values. Instead of using raw strings
// like "male" or "female" everywhere (which can cause typos),
// we use Gender.male and Gender.female — the compiler will
// catch any mistakes for us.
//
// WHY USE ENUMS HERE?
// • Safety: You can't accidentally type "Male" vs "male" — the
//   compiler enforces the exact value.
// • Readability: Code reads like plain English.
// • Maintainability: Adding a new option (e.g. Gender.other)
//   only needs one change in one place.
// ============================================================

// ── Gender Enum ─────────────────────────────────────────────
// Used in the Registration screen dropdown.
// Instead of storing the string "Male", we store Gender.male.
enum Gender { male, female, preferNotToSay }

// Helper extension so we can easily get a display label
// from a Gender enum value, e.g. Gender.male.label == "Male"
extension GenderExtension on Gender {
  String get label {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.preferNotToSay:
        return 'Prefer not to say';
    }
  }
}

// ── AuthStatus Enum ─────────────────────────────────────────
// Represents the current state of an authentication operation.
// Used in controllers to tell the UI what is happening.
//
// USE CASE: When a user presses Login, the status goes:
//   idle → loading → (success OR error)
// The UI watches this and shows a spinner during loading,
// an error message on error, or navigates on success.
enum AuthStatus {
  idle, // Nothing is happening yet
  loading, // Network/async call in progress → show spinner
  success, // Operation completed successfully
  error, // Something went wrong → show error message
}
