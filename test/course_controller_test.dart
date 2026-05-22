// ============================================================
// FILE: test/course_controller_test.dart
// ============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_auth_app/controllers/course_controller.dart';

void main() {
  group('CourseController API CRUD Integration Tests', () {
    late CourseController controller;

    setUp(() {
      controller = CourseController();
    });

    test('Fetch Courses - retrieves list and updates state', () async {
      expect(controller.courses, isEmpty);
      expect(controller.isLoading, isFalse);

      final fetchFuture = controller.fetchCourses();
      expect(controller.isLoading, isTrue);

      await fetchFuture;

      expect(controller.isLoading, isFalse);
      expect(controller.courses, isNotEmpty);
      expect(controller.hasError, isFalse);

      final firstCourse = controller.courses.first;
      expect(firstCourse.id, isNotNull);
      expect(firstCourse.title, isNotEmpty);
      expect(firstCourse.body, isNotEmpty);
    });

    test('Add Course - simulates creation and inserts at top', () async {
      // First fetch to populate list
      await controller.fetchCourses();
      final initialCount = controller.courses.length;

      final success = await controller.addCourse('New API Course', 'Description for the new course.');
      expect(success, isTrue);
      expect(controller.courses.length, initialCount + 1);
      
      final addedCourse = controller.courses.first;
      expect(addedCourse.title, equals('New API Course'));
      expect(addedCourse.body, equals('Description for the new course.'));
      expect(addedCourse.id, isNotNull);
    });

    test('Update Course - edits existing course title and body', () async {
      // First fetch to populate list
      await controller.fetchCourses();
      final originalCourse = controller.courses.first;
      final targetId = originalCourse.id;

      final success = await controller.updateCourse(targetId, 'Updated API Course Title', 'Updated body content.');
      expect(success, isTrue);

      // Verify it was updated in the list
      final updatedCourse = controller.courses.firstWhere((c) => c.id == targetId);
      expect(updatedCourse.title, equals('Updated API Course Title'));
      expect(updatedCourse.body, equals('Updated body content.'));
    });

    test('Delete Course - removes course from the list', () async {
      // First fetch to populate list
      await controller.fetchCourses();
      final originalCount = controller.courses.length;
      final courseToDelete = controller.courses.first;
      final targetId = courseToDelete.id;

      final success = await controller.deleteCourse(targetId);
      expect(success, isTrue);
      expect(controller.courses.length, originalCount - 1);
      expect(controller.courses.any((c) => c.id == targetId), isFalse);
    });
  });
}
