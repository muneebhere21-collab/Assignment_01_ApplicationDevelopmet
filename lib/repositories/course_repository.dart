import '../models/course_model.dart';
import '../services/course_service.dart';
import '../services/local_storage_service.dart';

class CourseRepository {
  final CourseService _courseService;
  final LocalStorageService _localStorageService;

  CourseRepository(this._courseService, this._localStorageService);

  Future<List<CourseModel>> fetchCourses() async {
    try {
      // Try to fetch from API
      final courses = await _courseService.getCourses();
      // Save to local cache
      await _localStorageService.saveCourses(courses);
      return courses;
    } catch (e) {
      // If API fails, try to load from local cache
      final cachedCourses = await _localStorageService.getCachedCourses();
      if (cachedCourses != null && cachedCourses.isNotEmpty) {
        return cachedCourses;
      }
      // If no cache, rethrow the error
      rethrow;
    }
  }

  Future<CourseModel> createCourse(String title, String body) async {
    return await _courseService.createCourse(title, body);
  }

  Future<CourseModel> updateCourse(int id, String title, String body) async {
    return await _courseService.updateCourse(id, title, body);
  }

  Future<void> deleteCourse(int id) async {
    return await _courseService.deleteCourse(id);
  }
}
