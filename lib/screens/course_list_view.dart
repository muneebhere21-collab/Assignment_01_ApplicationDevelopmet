// ============================================================
// FILE: lib/screens/course_list_view.dart
// ============================================================
//
// The visual CRUD interface for Course Management. It is embedded
// as a tab in the Dashboard.
// ============================================================

import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/course_controller.dart';
import '../models/course_model.dart';
import '../widgets/course_form_dialog.dart';
import 'course_detail_screen.dart';
import 'login_screen.dart';

class CourseListView extends StatefulWidget {
  final CourseController controller;
  final AuthController authController;

  const CourseListView({
    super.key,
    required this.controller,
    required this.authController,
  });

  @override
  State<CourseListView> createState() => _CourseListViewState();
}

class _CourseListViewState extends State<CourseListView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch courses on load if the list is empty
    if (widget.controller.courses.isEmpty && !widget.controller.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.controller.fetchCourses();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showFormDialog([CourseModel? course]) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CourseFormDialog(
        course: course,
        controller: widget.controller,
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(course == null
                  ? 'Course created successfully!'
                  : 'Course updated successfully!'),
            ],
          ),
          backgroundColor: const Color(0xFF10B981), // Green
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _confirmDelete(CourseModel course) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
            SizedBox(width: 8),
            Text('Delete Course'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${course.title}"? This action cannot be undone.',
          style: const TextStyle(color: Color(0xFF374151)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final success = await widget.controller.deleteCourse(course.id);
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.delete_outline_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text('Course deleted successfully.'),
              ],
            ),
            backgroundColor: const Color(0xFF374151), // Dark grey
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.controller.errorMessage ?? 'Failed to delete course.'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  void _handleLogout(BuildContext context) {
    widget.authController.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(authController: widget.authController),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      // ── Floating Action Button ──────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFormDialog(),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Course', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF3B82F6), // Accent Blue
        elevation: 4,
      ),
      body: RefreshIndicator(
        onRefresh: () => widget.controller.fetchCourses(),
        color: const Color(0xFF3B82F6),
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            final isLoading = widget.controller.isLoading;
            final courses = widget.controller.courses;
            final hasError = widget.controller.hasError;
            final filteredCourses = courses
                .where((course) =>
                    course.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                .toList();

            return CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // ── Collapsing App Bar ─────────────────────────
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color(0xFF1D4ED8),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 16, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Course Manager 🎓',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Manage academic course directory via REST API',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      tooltip: 'Logout',
                      onPressed: () => _handleLogout(context),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),

                // ── Body Content (Loading / Error / Empty / List) ──
                if (isLoading && courses.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildSkeletonLoader(),
                  )
                else if (hasError && courses.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildErrorState(),
                  )
                else if (courses.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(),
                  )
                else ...[
                  // Title section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _searchQuery.isEmpty
                                ? 'API Course Directory (${courses.length})'
                                : 'Search Results (${filteredCourses.length})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          if (isLoading)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF3B82F6)),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Search Field
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.trim();
                          });
                        },
                        style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
                        decoration: InputDecoration(
                          hintText: 'Search course by name...',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, color: Colors.grey, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Course List or Empty Search Results State
                  if (filteredCourses.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded, size: 56, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            const Text(
                              'No courses match your search',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try checking for typos or searching another term.',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF3B82F6),
                                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              child: const Text('Clear Search'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final course = filteredCourses[index];
                            return _CourseCard(
                              course: course,
                              onEdit: () => _showFormDialog(course),
                              onDelete: () => _confirmDelete(course),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseDetailScreen(course: course),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: filteredCourses.length,
                        ),
                      ),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Skeleton Loader (Loading State) ────────────────────────
  Widget _buildSkeletonLoader() {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 16,
                    color: Colors.grey.shade100,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.grey.shade100,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 200,
                    height: 12,
                    color: Colors.grey.shade100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error State UI ─────────────────────────────────────────
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFEF4444),
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Failed to load courses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
            ),
            const SizedBox(height: 8),
            Text(
              widget.controller.errorMessage ?? 'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => widget.controller.fetchCourses(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry Fetching'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty State UI ─────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.library_books_outlined,
                color: Color(0xFF3B82F6),
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No courses found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
            ),
            const SizedBox(height: 8),
            Text(
              'No courses are currently available in the directory. Tap below to create your first course!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showFormDialog(),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add First Course'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Course Card Component ─────────────────────────────────────
class _CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _CourseCard({
    required this.course,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a consistent aesthetic color based on the Course ID
    final colors = [
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF10B981), // Green
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEC4899), // Pink
      const Color(0xFF06B6D4), // Cyan
    ];
    final color = colors[course.id % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Left Accent Visual ──────────────────────────
                Container(
                  width: 60,
                  height: 96,
                  color: color.withOpacity(0.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book_rounded, color: color, size: 22),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '#${course.id}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Middle Details ──────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          course.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Right Action Buttons ────────────────────────
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        color: const Color(0xFF10B981), // Emerald green
                        onPressed: onEdit,
                        tooltip: 'Edit Course',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 20),
                        color: const Color(0xFFEF4444), // Crimson red
                        onPressed: onDelete,
                        tooltip: 'Delete Course',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
