// ============================================================
// FILE: lib/controllers/subject_data.dart
// ============================================================
//
// WHY A SEPARATE FILE FOR SUBJECT DATA?
// This is our "data source" for subjects. In a real app this
// would come from an API. For now it's static (hardcoded) data.
// Keeping it separate from UI means changing the subjects later
// (e.g. fetching from a server) only changes this file.
// ============================================================

import '../models/user_model.dart';

class SubjectData {
  // A static list means it belongs to the CLASS, not an instance.
  // You access it as SubjectData.subjects — no need to create
  // a SubjectData() object first.
  static final List<SubjectModel> subjects = [
    SubjectModel(
      name: 'Mobile App Development',
      code: 'MAD-401',
      description:
          'This course covers the fundamentals of modern mobile application '
          'development using Flutter and Dart. Students will learn to build '
          'cross-platform apps for iOS and Android from a single codebase. '
          'Topics include widgets, state management, navigation, API integration, '
          'and publishing apps to the App Store and Google Play.',
      schedule: 'Monday & Wednesday\n10:00 AM – 11:30 AM\nRoom: CS-204',
      instructor: 'Dr. Sana Mirza',
      iconEmoji: '📱',
      colorValue: 0xFF1565C0, // Deep Blue
    ),
    SubjectModel(
      name: 'Software Re-engineering',
      code: 'SRE-301',
      description:
          'Software Re-engineering focuses on understanding, restructuring, '
          'and improving existing software systems. Students will study legacy '
          'systems, reverse engineering techniques, code refactoring, and '
          'migration strategies. Practical sessions involve analyzing real '
          'codebases and applying modern software patterns.',
      schedule: 'Tuesday & Thursday\n2:00 PM – 3:30 PM\nRoom: CS-102',
      instructor: 'Prof. Ahmed Khan',
      iconEmoji: '🔧',
      colorValue: 0xFF2E7D32, // Deep Green
    ),
    SubjectModel(
      name: 'Management Information Systems',
      code: 'MIS-201',
      description:
          'Management Information Systems explores how organizations use '
          'technology to collect, process, store, and communicate information '
          'for decision-making. Topics include database management, ERP systems, '
          'business intelligence, cybersecurity, and the impact of digital '
          'transformation on modern enterprises.',
      schedule: 'Friday\n9:00 AM – 12:00 PM\nRoom: BBA-301',
      instructor: 'Ms. Rabia Noor',
      iconEmoji: '📊',
      colorValue: 0xFF6A1B9A, // Deep Purple
    ),
  ];
}
