// ============================================================
// FILE: lib/controllers/course_controller.dart
// ============================================================
//
// Controller class extending ChangeNotifier. Tracks states (courses,
// loading indicators, errors) and provides methods to trigger CRUD API operations.
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';

class CourseController extends ChangeNotifier {
  final CourseService _courseService = CourseService();

  // ── State Variables ────────────────────────────────────────
  List<CourseModel> _courses = [];
  bool _isLoading = false;
  String? _errorMessage;

  // ── Getters ────────────────────────────────────────────────
  List<CourseModel> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  // ── Read - Get Courses ─────────────────────────────────────
  Future<void> fetchCourses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await _courseService.getCourses();
      _courses = fetched;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Create - Add Course ────────────────────────────────────
  Future<bool> addCourse(String title, String body) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newCourse = await _courseService.createCourse(title, body);
      
      // JSONPlaceholder always returns id: 101 for created items.
      // If we already have a course with id: 101, we want to give it a unique simulated ID
      // to avoid duplicates and key collisions in list views.
      int finalId = newCourse.id;
      if (_courses.any((c) => c.id == finalId)) {
        // Find max ID currently in list and add 1
        final maxId = _courses.map((c) => c.id).fold(100, (prev, id) => id > prev ? id : prev);
        finalId = maxId + 1;
      }
      
      final adjustedCourse = newCourse.copyWith(id: finalId);
      
      // Insert at the top of our local list for immediate visual update
      _courses.insert(0, adjustedCourse);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Update - Edit Course ───────────────────────────────────
  Future<bool> updateCourse(int id, String title, String body) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _courseService.updateCourse(id, title, body);
      
      // Find and update item locally in the list
      final index = _courses.indexWhere((c) => c.id == id);
      if (index != -1) {
        _courses[index] = updated;
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Delete - Remove Course ─────────────────────────────────
  Future<bool> deleteCourse(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _courseService.deleteCourse(id);
      
      // Remove from the local list
      _courses.removeWhere((c) => c.id == id);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Clear Error ───────────────────────────────────────────
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
