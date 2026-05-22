import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_auth_app/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  Future<void> takeScreenshot(String name) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final bytes = await binding.takeScreenshot(name);
    final file = File('screenshots/$name.png');
    file.writeAsBytesSync(bytes);
    print('Saved $name.png');
  }

  testWidgets('Capture all required screenshots', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // 1. Login Screen
    await takeScreenshot('1_login_screen');

    // Register User first
    final createAccountButton = find.text('Create Account');
    await tester.ensureVisible(createAccountButton);
    await tester.tap(createAccountButton);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'John');
    await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
    await tester.enterText(find.byType(TextFormField).at(2), 'test@test.com');
    await tester.enterText(find.byType(TextFormField).at(3), 'Password123!');
    await tester.enterText(find.byType(TextFormField).at(4), 'Password123!');
    
    final registerButton = find.text('Register');
    await tester.ensureVisible(registerButton);
    await tester.tap(registerButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Login
    await tester.enterText(find.byType(TextFormField).at(0), 'test@test.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'Password123!');
    
    final loginButton = find.text('Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 2. Dashboard Screen
    await takeScreenshot('2_dashboard_screen');

    // Switch to Courses Tab
    final coursesTab = find.byIcon(Icons.school_rounded).last;
    await tester.tap(coursesTab);
    await tester.pump(); // trigger rebuild to show loading state

    // 3. Loading State
    await takeScreenshot('3_loading_state');
    
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 4. Courses Fetched
    await takeScreenshot('4_courses_loaded');

    // Tap Add Course FAB
    final fab = find.byType(FloatingActionButton);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // 5. Add Course Screen
    await takeScreenshot('5_add_course');

    // Fill Course Form
    await tester.enterText(find.byType(TextFormField).at(0), 'Advanced Flutter');
    await tester.enterText(find.byType(TextFormField).at(1), 'Learn how to automatically capture screenshots using integration tests.');
    
    final createButton = find.text('Create');
    await tester.tap(createButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 6. Successful Course Added
    await takeScreenshot('6_successful_course_added');

    // Edit the first course (which is the one we just added)
    final editButton = find.byIcon(Icons.edit_rounded).first;
    await tester.tap(editButton);
    await tester.pumpAndSettle();

    // 7. Edit Course Screen
    await takeScreenshot('7_edit_course');

    await tester.enterText(find.byType(TextFormField).at(0), 'Advanced Flutter (Updated)');
    final updateButton = find.text('Update');
    await tester.tap(updateButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 8. Updated Course Result
    await takeScreenshot('8_updated_course_result');

    // Delete the course
    final deleteButton = find.byIcon(Icons.delete_outline_rounded).first;
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // 9. Delete Confirmation Dialog
    await takeScreenshot('9_delete_confirmation');

    final confirmDeleteButton = find.widgetWithText(TextButton, 'Delete');
    await tester.tap(confirmDeleteButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 10. Course Deleted Successfully
    await takeScreenshot('10_course_deleted_successfully');

    print('SUCCESS: All 10 screenshots generated!');
  });
}
