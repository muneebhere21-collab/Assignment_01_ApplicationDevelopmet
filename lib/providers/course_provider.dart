import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';
import '../services/local_storage_service.dart';
import '../repositories/course_repository.dart';

final courseServiceProvider = Provider<CourseService>((ref) {
  return CourseService();
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository(
    ref.read(courseServiceProvider),
    ref.read(localStorageServiceProvider),
  );
});

// Provider for Search Query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider for filtered courses
final filteredCourseListProvider = Provider<AsyncValue<List<CourseModel>>>((ref) {
  final coursesState = ref.watch(courseListProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  return coursesState.when(
    data: (courses) {
      if (searchQuery.isEmpty) return AsyncData(courses);
      final filtered = courses.where((c) {
        return c.title.toLowerCase().contains(searchQuery) || 
               c.body.toLowerCase().contains(searchQuery);
      }).toList();
      return AsyncData(filtered);
    },
    loading: () => const AsyncLoading(),
    error: (err, stack) => AsyncError(err, stack),
  );
});

class CourseListNotifier extends AsyncNotifier<List<CourseModel>> {
  @override
  Future<List<CourseModel>> build() async {
    return ref.read(courseRepositoryProvider).fetchCourses();
  }

  Future<void> fetchCourses() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(courseRepositoryProvider).fetchCourses());
  }

  Future<void> addCourse(String title, String body) async {
    final previousState = state;
    try {
      final newCourse = await ref.read(courseRepositoryProvider).createCourse(title, body);
      int finalId = newCourse.id;
      final currentList = previousState.value ?? [];
      
      // JSONPlaceholder simulated ID collision logic
      if (currentList.any((c) => c.id == finalId)) {
        final maxId = currentList.map((c) => c.id).fold(100, (prev, id) => id > prev ? id : prev);
        finalId = maxId + 1;
      }
      final adjustedCourse = newCourse.copyWith(id: finalId);
      
      state = AsyncData([adjustedCourse, ...currentList]);
    } catch (e, st) {
      // Keep previous data but show error state momentarily, then revert to previous data
      state = AsyncError(e, st);
      Future.delayed(const Duration(seconds: 1), () {
        if (state.hasError) state = previousState;
      });
      rethrow;
    }
  }

  Future<void> updateCourse(int id, String title, String body) async {
    final previousState = state;
    final currentList = state.value ?? [];
    
    // 1. Optimistic Update: Update state immediately
    final index = currentList.indexWhere((c) => c.id == id);
    if (index != -1) {
      final optimisticList = List<CourseModel>.from(currentList);
      optimisticList[index] = optimisticList[index].copyWith(title: title, body: body);
      state = AsyncData(optimisticList);
    }

    try {
      // 2. Perform API call
      await ref.read(courseRepositoryProvider).updateCourse(id, title, body);
    } catch (e) {
      // 3. Rollback on failure
      state = previousState;
      rethrow; 
    }
  }

  Future<void> deleteCourse(int id) async {
    final previousState = state;
    final currentList = state.value ?? [];

    // 1. Optimistic Delete: Remove from state immediately
    final optimisticList = currentList.where((c) => c.id != id).toList();
    state = AsyncData(optimisticList);

    try {
      // 2. Perform API call
      await ref.read(courseRepositoryProvider).deleteCourse(id);
    } catch (e) {
      // 3. Rollback on failure
      state = previousState;
      rethrow;
    }
  }
}

final courseListProvider = AsyncNotifierProvider<CourseListNotifier, List<CourseModel>>(() {
  return CourseListNotifier();
});
