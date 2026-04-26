// ============================================================
// FILE: lib/validators/app_validator.dart
// ============================================================
//
// WHAT IS A VALIDATOR CLASS?
// A validator is a class with static methods that each check
// one specific rule and return either null (valid) or a String
// error message (invalid).
//
// Flutter's TextFormField has a 'validator' property that
// accepts a function:  String? Function(String? value)
// If the function returns null → field is valid ✅
// If it returns a String  → that string is shown as error ❌
//
// WHY PUT ALL VALIDATORS HERE INSTEAD OF IN THE UI FILES?
// 1. Reusability: validateEmail() is called in BOTH the Login
//    screen and the Registration screen — no code duplication.
// 2. Separation of concerns: UI files only handle visuals.
//    Business rules (what counts as a valid password) live here.
// 3. Testability: You can test AppValidator.validateEmail('bad')
//    without ever building a widget.
// 4. Easy to change: if password rules change, update ONE file.
//
// USE CASE EXAMPLE:
//   TextFormField(
//     validator: AppValidator.validateEmail,  // passed by reference
//   )
// ============================================================

class AppValidator {
  // ── Validate Full Name ─────────────────────────────────────
  // Rules: not empty, minimum 2 characters
  static String? validateFullName(String? value) {
    // trim() removes leading/trailing whitespace so "  " is treated as empty
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null; // null = valid
  }

  // ── Validate Email ─────────────────────────────────────────
  // Uses a RegExp (regular expression) to check email format.
  // RegExp is a pattern-matching tool built into Dart.
  // The pattern below checks: something@something.something
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    // RegExp pattern explained:
    // ^         = start of string
    // [\w\.-]+  = one or more word chars, dots, or hyphens (username part)
    // @         = literal @
    // [\w\.-]+  = domain name
    // \.        = literal dot
    // \w{2,4}   = 2-4 char extension like .com .org .edu
    // $         = end of string
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // ── Validate Password ─────────────────────────────────────
  // Rules from the requirements:
  //   • Minimum 6 characters
  //   • At least 1 uppercase letter
  //   • At least 1 special character
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    // RegExp for at least one uppercase letter (A-Z)
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least 1 uppercase letter';
    }
    // RegExp for at least one special character
    // The \W matches any non-word character (! @ # $ % etc.)
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least 1 special character';
    }
    return null;
  }

  // ── Validate Confirm Password ─────────────────────────────
  // This one takes the original password as an extra parameter
  // so it can compare the two values.
  // We use a closure: a function that returns a function.
  // This lets us use it like: validator: AppValidator.validateConfirmPassword(passwordController.text)
  static String? Function(String?) validateConfirmPassword(
    String originalPassword,
  ) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }
      if (value != originalPassword) {
        return 'Passwords do not match';
      }
      return null;
    };
  }

  // ── Validate Gender ────────────────────────────────────────
  // For the dropdown — just ensures the user picked something.
  // The generic <T> means this works for any type of dropdown.
  static String? validateDropdown<T>(T? value) {
    if (value == null) {
      return 'Please select an option';
    }
    return null;
  }

  // ── Validate Login Password ───────────────────────────────
  // On LOGIN we only check that it's not empty (we don't enforce
  // the complexity rules because the user is logging in, not
  // creating a new password — wrong credentials = wrong email/pw).
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
}
