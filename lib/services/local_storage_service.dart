import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/course_model.dart';

class LocalStorageService {
  static const String _boxName = 'coursesBox';

  Future<void> saveCourses(List<CourseModel> courses) async {
    final box = await Hive.openBox(_boxName);
    final coursesJson = courses.map((c) => c.toJson()).toList();
    await box.put('coursesList', jsonEncode(coursesJson));
  }

  Future<List<CourseModel>?> getCachedCourses() async {
    final box = await Hive.openBox(_boxName);
    final coursesString = box.get('coursesList');
    if (coursesString != null) {
      final List<dynamic> decodedList = jsonDecode(coursesString);
      return decodedList.map((json) => CourseModel.fromJson(json)).toList();
    }
    return null;
  }

  Future<void> clearCache() async {
    final box = await Hive.openBox(_boxName);
    await box.clear();
  }
}
