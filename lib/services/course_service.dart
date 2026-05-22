// ============================================================
// FILE: lib/services/course_service.dart
// ============================================================
//
// Service class containing standard API actions to retrieve, create,
// update, and delete courses from the JSONPlaceholder REST endpoint.
// ============================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_model.dart';

class CourseService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  // ── Fetch Courses (Read - GET) ─────────────────────────────
  Future<List<CourseModel>> getCourses() async {
    final url = Uri.parse('$_baseUrl/posts');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) {
        final course = CourseModel.fromJson(json);
        return course.copyWith(
          title: CourseModel.getRealisticTitle(course.id, course.title),
          body: CourseModel.getRealisticBody(course.id, course.body),
        );
      }).toList();
    } else {
      throw Exception('Failed to load courses. Server returned: ${response.statusCode}');
    }
  }

  // ── Create Course (Create - POST) ───────────────────────────
  Future<CourseModel> createCourse(String title, String body) async {
    final url = Uri.parse('$_baseUrl/posts');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'title': title,
        'body': body,
        'userId': 1, // Required by JSONPlaceholder
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return CourseModel.fromJson(jsonMap);
    } else {
      throw Exception('Failed to create course. Server returned: ${response.statusCode}');
    }
  }

  // ── Update Course (Update - PUT) ────────────────────────────
  Future<CourseModel> updateCourse(int id, String title, String body) async {
    // If the ID is simulated (JSONPlaceholder only has IDs 1-100),
    // we return a simulated success response instead of letting PUT return a 404.
    if (id > 100) {
      await Future.delayed(const Duration(milliseconds: 500)); // simulate delay
      return CourseModel(id: id, title: title, body: body);
    }

    final url = Uri.parse('$_baseUrl/posts/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'id': id,
        'title': title,
        'body': body,
        'userId': 1,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return CourseModel.fromJson(jsonMap);
    } else {
      throw Exception('Failed to update course. Server returned: ${response.statusCode}');
    }
  }

  // ── Delete Course (Delete - DELETE) ─────────────────────────
  Future<void> deleteCourse(int id) async {
    // If the ID is simulated, we simulate a success response.
    if (id > 100) {
      await Future.delayed(const Duration(milliseconds: 500)); // simulate delay
      return;
    }

    final url = Uri.parse('$_baseUrl/posts/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete course. Server returned: ${response.statusCode}');
    }
  }
}
