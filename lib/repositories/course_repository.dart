import '../models/course_model.dart';
import '../services/course_service.dart';
import '../services/local_storage_service.dart';

class CourseRepository {
  final CourseService _courseService;
  final LocalStorageService _localStorageService;
  final void Function(bool) _onOfflineStateChanged;

  CourseRepository(this._courseService, this._localStorageService, this._onOfflineStateChanged);

  Future<List<CourseModel>> fetchCourses() async {
    try {
      // Try to fetch from API
      final courses = await _courseService.getCourses();
      _onOfflineStateChanged(false);
      // Save to local cache
      await _localStorageService.saveCourses(courses);
      return courses;
    } catch (e) {
      _onOfflineStateChanged(true);
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
