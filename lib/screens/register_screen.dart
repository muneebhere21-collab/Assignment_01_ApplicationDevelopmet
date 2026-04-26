// ============================================================
// FILE: lib/screens/register_screen.dart
// ============================================================
//
// WHAT HAPPENS HERE?
// This is the Registration screen. It's a StatefulWidget because
// it needs to manage local state:
//   • Whether the password is visible or hidden
//   • The selected gender from the dropdown
//   • The form's validation state
//
// WHY StatefulWidget (not StatelessWidget)?
// StatelessWidget = no state, just displays data.
// StatefulWidget = has State object that can change over time.
// When state changes, Flutter redraws only the affected parts.
//
// KEY CONCEPTS USED:
//   • Form + GlobalKey<FormState> — to validate all fields at once
//   • TextEditingController — reads text from each field
//   • ListenableBuilder — listens to AuthController for status changes
//   • DropdownButtonFormField — gender dropdown
// ============================================================

import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../enums/app_enums.dart';
import '../validators/app_validator.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  // AuthController is passed in — the same controller is shared
  // across Login and Register screens so they share user data.
  final AuthController authController;

  const RegisterScreen({super.key, required this.authController});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ── Form Key ───────────────────────────────────────────────
  // GlobalKey<FormState> gives us access to the Form widget.
  // We call _formKey.currentState!.validate() to trigger ALL
  // validators at once. It returns true if all pass.
  final _formKey = GlobalKey<FormState>();

  // ── Text Controllers ───────────────────────────────────────
  // Each TextEditingController is linked to one TextFormField.
  // controller.text gives us what the user typed.
  // We MUST dispose() them when the screen is destroyed to
  // free up memory — see dispose() below.
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  // ── Local State ────────────────────────────────────────────
  bool _showPassword = false; // toggle password visibility
  bool _showConfirmPassword = false;
  Gender? _selectedGender; // null means not selected yet

  @override
  void dispose() {
    // IMPORTANT: Always dispose controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ── Submit Handler ─────────────────────────────────────────
  // Called when the Register button is tapped.
  void _handleRegister() async {
    // Step 1: Validate ALL form fields
    // _formKey.currentState!.validate() calls every validator function.
    // If any returns a non-null string, the field shows an error and
    // this method returns false.
    final isValid = _formKey.currentState!.validate();

    // Also check gender separately (dropdown)
    if (_selectedGender == null) {
      setState(() {}); // trigger rebuild to show gender error
    }

    if (!isValid || _selectedGender == null) return;

    // Step 2: Call the controller to register
    await widget.authController.register(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      gender: _selectedGender!,
    );

    // Step 3: If success, navigate to Login
    // mounted check: make sure this widget is still in the tree
    // (user might have navigated away during the async call)
    if (!mounted) return;

    if (widget.authController.status == AuthStatus.success) {
      // Show a brief success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please login.'),
          backgroundColor: Color(0xFF22C55E),
          duration: Duration(seconds: 2),
        ),
      );
      // Navigate BACK to Login screen
      // Navigator.pop() goes back one screen in the stack
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF374151)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // SingleChildScrollView allows the screen to scroll
          // when the keyboard appears or content is too long.
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            // Form wraps all fields — _formKey links to this Form
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ── Header ─────────────────────────────────
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fill in your details to get started',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 28),

                // ── Full Name Field ────────────────────────
                CustomTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  validator: AppValidator.validateFullName,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),

                // ── Email Field ────────────────────────────
                CustomTextField(
                  label: 'Email Address',
                  hint: 'Enter your email',
                  controller: _emailController,
                  validator: AppValidator.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // ── Gender Dropdown ────────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<Gender>(
                      value: _selectedGender,
                      // validator called when form.validate() runs
                      validator: AppValidator.validateDropdown<Gender>,
                      decoration: InputDecoration(
                        hintText: 'Select your gender',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF3B82F6),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFEF4444),
                            width: 1.5,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFEF4444),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      // Gender.values gives us all enum values as a list
                      // We map each to a DropdownMenuItem
                      items: Gender.values.map((gender) {
                        return DropdownMenuItem<Gender>(
                          value: gender,
                          child: Text(gender.label), // uses our extension
                        );
                      }).toList(),
                      onChanged: (value) {
                        // setState() triggers a rebuild with the new value
                        setState(() => _selectedGender = value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Password Field ─────────────────────────
                CustomTextField(
                  label: 'Password',
                  hint: 'Min 6 chars, 1 uppercase, 1 special',
                  controller: _passwordController,
                  validator: AppValidator.validatePassword,
                  obscureText: !_showPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey.shade500,
                    ),
                    onPressed: () {
                      setState(() => _showPassword = !_showPassword);
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // ── Confirm Password Field ─────────────────
                CustomTextField(
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  controller: _confirmController,
                  // Read the latest password value at validation time.
                  validator: (value) => AppValidator.validateConfirmPassword(
                    _passwordController.text,
                  )(value),
                  obscureText: !_showConfirmPassword,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey.shade500,
                    ),
                    onPressed: () {
                      setState(
                        () => _showConfirmPassword = !_showConfirmPassword,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // ── Register Button ────────────────────────
                // ListenableBuilder rebuilds ONLY this part of the tree
                // when authController.notifyListeners() is called.
                // More efficient than wrapping the whole screen.
                ListenableBuilder(
                  listenable: widget.authController,
                  builder: (context, _) {
                    final isLoading =
                        widget.authController.status == AuthStatus.loading;
                    final hasError =
                        widget.authController.status == AuthStatus.error;

                    return Column(
                      children: [
                        // Show error message if login failed
                        if (hasError) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFFCA5A5),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Color(0xFFEF4444),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    widget.authController.errorMessage,
                                    style: const TextStyle(
                                      color: Color(0xFFDC2626),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        CustomButton(
                          text: 'Create Account',
                          onPressed: _handleRegister,
                          isLoading: isLoading,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),

                // ── Already have account ───────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFF3B82F6),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
