// ============================================================
// FILE: lib/widgets/custom_text_field.dart
// ============================================================
//
// WHAT IS A CUSTOM WIDGET?
// Instead of writing the same TextFormField styling 10 times
// across different screens, we create ONE widget with all our
// styling, and just pass in the parts that change (label,
// controller, validator, etc.)
//
// This is the DRY principle: Don't Repeat Yourself.
//
// WHY StatelessWidget?
// This widget has no internal state — it just displays what
// it's given. The state (what the user typed) is managed by
// the TextEditingController passed in from outside.
// ============================================================

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  // All the things a caller can customize
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool obscureText; // true = shows *** (password field)
  final Widget? suffixIcon; // optional icon on the right
  final TextInputType keyboardType; // number, email, text, etc.
  final TextInputAction textInputAction; // what the keyboard "done" button does

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.validator,
    this.obscureText = false, // default: show text
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label text above the field
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6), // small space between label and field
        // The actual input field
        TextFormField(
          controller: controller,
          validator: validator, // called when form.validate() runs
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: const TextStyle(fontSize: 15, color: Color(0xFF111827)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            suffixIcon: suffixIcon,

            // Border when field is NOT focused
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            // Border when field IS focused (user is typing)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            // Border when validation FAILS
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 1.5,
              ),
            ),
            // Border when focused AND has an error
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// CUSTOM PRIMARY BUTTON WIDGET
// Reusable button used across Login, Register screens.
// Shows a loading spinner when isLoading is true.
// ============================================================
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // VoidCallback = a function with no args
  final bool isLoading; // show spinner instead of text?
  final Color? color;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // stretch full width
      height: 50,
      child: ElevatedButton(
        // If loading, pass null to onPressed — this DISABLES the button
        // Disabled button cannot be tapped again while loading
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFF3B82F6),
          disabledBackgroundColor: const Color(0xFF93C5FD),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
        ),
        child: isLoading
            // Show spinner during loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            // Show button text normally
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
