// ============================================================
// FILE: lib/screens/detail_screen.dart
// ============================================================
//
// Detail screen shows full information for one subject.
// It receives a SubjectModel from the Dashboard and displays:
//   1. Subject name header (in AppBar)
//   2. Banner image (color gradient placeholder)
//   3. Course description
//   4. Schedule details
//
// WHY pass the subject via constructor instead of fetching it?
// • The data is already in memory (no extra loading needed)
// • It keeps this screen decoupled — it doesn't need to know
//   about SubjectData or any controller. It just displays what
//   it receives. This makes it reusable and easy to test.
// ============================================================

import 'package:flutter/material.dart';
import '../models/user_model.dart';

class DetailScreen extends StatelessWidget {
  final SubjectModel subject; // passed from DashboardScreen

  const DetailScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final subjectColor = Color(subject.colorValue);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: CustomScrollView(
        slivers: [
          // ── 01: Subject Header ─────────────────────────
          // A SliverAppBar with the subject name and back button
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: subjectColor,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              // ── 02: Banner Image ──────────────────────
              // Using a gradient as the banner (no external image needed)
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      subjectColor,
                      subjectColor.withOpacity(0.7),
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Large background emoji for visual interest
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Text(
                        subject.iconEmoji,
                        style: TextStyle(
                          fontSize: 130,
                          // withOpacity on text via shadow trick
                        ),
                      ),
                    ),
                    // Subject info overlay
                    Positioned(
                      left: 20,
                      bottom: 24,
                      right: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              subject.code,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subject.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Content Section ────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instructor chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: subjectColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: subjectColor.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_rounded,
                          color: subjectColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          subject.instructor,
                          style: TextStyle(
                            color: subjectColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── 03: Description ─────────────────────
                  _SectionCard(
                    icon: Icons.info_outline_rounded,
                    title: 'About This Course',
                    color: subjectColor,
                    child: Text(
                      subject.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                        height: 1.7, // line spacing
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── 04: Schedule Details ────────────────
                  _SectionCard(
                    icon: Icons.schedule_rounded,
                    title: 'Schedule',
                    color: subjectColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: subject.schedule.split('\n').map((line) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(
                                  right: 10,
                                  top: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: subjectColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                line,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF374151),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Back Button ─────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Back to Dashboard'),
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: subjectColor,
                        side: BorderSide(color: subjectColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private Section Card Widget ────────────────────────────
// Reusable card used for Description and Schedule sections.
// Private (underscore prefix) because it's only used in this file.
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Divider line
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 14),
          // The actual content
          child,
        ],
      ),
    );
  }
}
