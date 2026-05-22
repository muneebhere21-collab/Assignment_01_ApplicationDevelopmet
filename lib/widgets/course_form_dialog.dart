// ============================================================
// FILE: lib/widgets/course_form_dialog.dart
// ============================================================
//
// Form dialog used to Add a new Course or Edit an existing Course.
// It handles input validation and displays loading states.
// ============================================================

import 'package:flutter/material.dart';
import '../controllers/course_controller.dart';
import '../models/course_model.dart';
import '../validators/app_validator.dart';
import 'custom_text_field.dart';

class CourseFormDialog extends StatefulWidget {
  final CourseModel? course; // null = Add Course, non-null = Edit Course
  final CourseController controller;

  const CourseFormDialog({
    super.key,
    this.course,
    required this.controller,
  });

  @override
  State<CourseFormDialog> createState() => _CourseFormDialogState();
}

class _CourseFormDialogState extends State<CourseFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  bool _isSubmitting = false;
  String? _errorMessage;

  bool get _isEditing => widget.course != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.course?.title ?? '');
    _bodyController = TextEditingController(text: widget.course?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final success = _isEditing
        ? await widget.controller.updateCourse(
            widget.course!.id,
            _titleController.text.trim(),
            _bodyController.text.trim(),
          )
        : await widget.controller.addCourse(
            _titleController.text.trim(),
            _bodyController.text.trim(),
          );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true); // Return true to indicate success
    } else {
      setState(() {
        _isSubmitting = false;
        _errorMessage = widget.controller.errorMessage ?? 'Something went wrong';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ─────────────────────────────────
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _isEditing ? const Color(0xFF10B981).withOpacity(0.1) : const Color(0xFF3B82F6).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isEditing ? Icons.edit_rounded : Icons.add_rounded,
                        color: _isEditing ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isEditing ? 'Edit Course' : 'Add New Course',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Error Message Banner ──────────────────
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFCA5A5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Title Input ───────────────────────────
                CustomTextField(
                  label: 'Course Title',
                  hint: 'Enter course name (e.g., Software Architecture)',
                  controller: _titleController,
                  validator: (val) => AppValidator.validateRequired(val, 'Title'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // ── Description Input ─────────────────────
                CustomTextField(
                  label: 'Course Description',
                  hint: 'Enter course description and objectives...',
                  controller: _bodyController,
                  validator: (val) => AppValidator.validateRequired(val, 'Description'),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: 4,
                ),
                const SizedBox(height: 24),

                // ── Action Buttons ────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey.shade600,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isEditing ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _isEditing ? 'Save Changes' : 'Create Course',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
