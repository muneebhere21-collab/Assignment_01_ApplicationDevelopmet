// ============================================================
// FILE: lib/screens/login_screen.dart
// ============================================================
//
// Login screen with:
//   • Email field with validation
//   • Password field with show/hide toggle
//   • Remember Me checkbox
//   • Error message display
//   • Navigation to Register and Dashboard
// ============================================================

import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../enums/app_enums.dart';
import '../validators/app_validator.dart';
import '../widgets/custom_text_field.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthController authController;

  const LoginScreen({super.key, required this.authController});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false; // controls password visibility

  @override
  void initState() {
    super.initState();
    // Reset any leftover auth status from a previous screen
    // initState runs ONCE when the screen first loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.authController.resetStatus();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    // Validate all form fields first
    if (!_formKey.currentState!.validate()) return;

    await widget.authController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      rememberMe: widget.authController.rememberMe,
    );

    if (!mounted) return;

    if (widget.authController.status == AuthStatus.success) {
      // Navigate to Dashboard — pushReplacement replaces the current screen
      // so the user can't press Back to return to Login while logged in.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              DashboardScreen(authController: widget.authController),
        ),
      );
    }
  }

  void _goToRegister() {
    // Reset error state before leaving this screen
    widget.authController.resetStatus();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterScreen(authController: widget.authController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // ── App Logo / Icon ────────────────────────
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Header ─────────────────────────────────
                const Center(
                  child: Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    'Sign in to continue to your dashboard',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ),
                const SizedBox(height: 36),

                // ── Email Field ────────────────────────────
                CustomTextField(
                  label: 'Email Address',
                  hint: 'Enter your email',
                  controller: _emailController,
                  validator: AppValidator.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // ── Password Field with Show/Hide ──────────
                CustomTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passwordController,
                  validator: AppValidator.validateLoginPassword,
                  obscureText: !_showPassword,
                  textInputAction: TextInputAction.done,
                  // suffixIcon is the eye icon to toggle visibility
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey.shade500,
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() => _showPassword = !_showPassword);
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // ── Remember Me Checkbox ───────────────────
                // ListenableBuilder updates just this row when
                // rememberMe toggles in the controller
                ListenableBuilder(
                  listenable: widget.authController,
                  builder: (context, _) {
                    return Row(
                      children: [
                        // Checkbox widget
                        Checkbox(
                          value: widget.authController.rememberMe,
                          onChanged: widget.authController.toggleRememberMe,
                          activeColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        GestureDetector(
                          // Tapping the label also toggles the checkbox
                          onTap: () => widget.authController.toggleRememberMe(
                            !widget.authController.rememberMe,
                          ),
                          child: const Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // ── Login Button + Error Message ───────────
                ListenableBuilder(
                  listenable: widget.authController,
                  builder: (context, _) {
                    final isLoading =
                        widget.authController.status == AuthStatus.loading;
                    final hasError =
                        widget.authController.status == AuthStatus.error;

                    return Column(
                      children: [
                        // Error message box
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
                          text: 'Sign In',
                          onPressed: _handleLogin,
                          isLoading: isLoading,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // ── Divider with "or" ─────────────────────
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Go to Register ─────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: _goToRegister,
                    child: RichText(
                      // RichText lets us mix styles in one line
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Create one',
                            style: TextStyle(
                              color: Color(0xFF3B82F6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
