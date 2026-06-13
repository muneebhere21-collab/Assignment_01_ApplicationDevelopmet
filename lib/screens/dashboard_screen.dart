// ============================================================
// FILE: lib/screens/dashboard_screen.dart
// ============================================================
//
// The Dashboard shows:
//   • Logged-in user's name and avatar
//   • A list of subjects (from SubjectData)
//   • Each subject is tappable → navigates to DetailScreen
//   • Logout button → returns to Login
//   • BottomNavigationBar to toggle between static subjects and API Courses CRUD.
// ============================================================

import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/subject_data.dart';
import '../models/user_model.dart';
import 'course_list_view.dart';
import 'detail_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  final AuthController authController;

  const DashboardScreen({super.key, required this.authController});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _handleLogout(BuildContext context) {
    widget.authController.logout();
    // pushAndRemoveUntil navigates to Login and REMOVES all previous
    // screens from the navigation stack. So pressing Back won't work.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(authController: widget.authController),
      ),
      (route) => false, // remove ALL routes
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.authController.currentUser!; // safe because we only get here after login

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      // ── Main Page Content Switcher ──────────────────────────
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeDashboard(context, user),
          CourseListView(
            authController: widget.authController,
          ),
        ],
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1D4ED8), // Primary Blue
        unselectedItemColor: Colors.grey.shade400,
        backgroundColor: Colors.white,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            activeIcon: Icon(Icons.dashboard_rounded, color: Color(0xFF1D4ED8)),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_rounded),
            activeIcon: Icon(Icons.school_rounded, color: Color(0xFF1D4ED8)),
            label: 'Courses',
          ),
        ],
      ),
    );
  }

  // ── Existing Dashboard Content (Tab 0) ───────────────────
  Widget _buildHomeDashboard(BuildContext context, UserModel user) {
    return CustomScrollView(
      // CustomScrollView lets us mix different scrollable widgets
      // (like a SliverAppBar that collapses on scroll + a list)
      slivers: [
        // ── Collapsing App Bar ─────────────────────────
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true, // stays visible when collapsed
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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          // Avatar circle with first letter of name
                          _buildAvatar(user),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, ${user.fullName.split(' ').first}! 👋',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  user.gender.name,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // The AppBar actions (top-right) — Logout button
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

        // ── Section Title ──────────────────────────────
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Text(
              'My Subjects',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ),

        // ── Subjects List ──────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final subject = SubjectData.subjects[index];
              return _SubjectCard(
                subject: subject,
                onTap: () {
                  // Navigate to Detail screen, passing the subject
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(subject: subject),
                    ),
                  );
                },
              );
            }, childCount: SubjectData.subjects.length),
          ),
        ),
      ],
    );
  }

  // ── Helper: Build Avatar ─────────────────────────────────
  Widget _buildAvatar(UserModel user) {
    // Gets the first character of the user's name as initials
    final initials =
        user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?';

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SUBJECT CARD WIDGET (private to this file)
// ============================================================
class _SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback onTap;

  const _SubjectCard({required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      // InkWell provides the tap ripple effect
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left color accent bar + icon
              Container(
                width: 80,
                height: 90,
                decoration: BoxDecoration(
                  color: Color(subject.colorValue).withOpacity(0.1),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      subject.iconEmoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 32,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Color(subject.colorValue),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),

              // Subject info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.code,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(subject.colorValue),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subject.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subject.instructor,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Arrow icon
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
