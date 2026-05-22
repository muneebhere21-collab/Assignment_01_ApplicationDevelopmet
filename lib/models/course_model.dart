// ============================================================
// FILE: lib/models/course_model.dart
// ============================================================
//
// Represents a Course entity mapped from the JSONPlaceholder REST API.
// Includes JSON serialization and deserialization support.
// ============================================================

class CourseModel {
  final int id;
  final String title;
  final String body;

  const CourseModel({
    required this.id,
    required this.title,
    required this.body,
  });

  static final List<String> _courseNames = [
    "Introduction to Computer Science",
    "Data Structures & Algorithms",
    "Object-Oriented Programming",
    "Database Management Systems",
    "Software Engineering Principles",
    "Operating Systems & Architecture",
    "Computer Networks & Protocols",
    "Artificial Intelligence Concepts",
    "Web Application Development",
    "Mobile Application Design (Flutter)",
    "Human-Computer Interaction",
    "Computer Architecture & Assembly",
    "Cyber Security & Cryptography",
    "Cloud Computing Technologies",
    "Data Science & Big Data Systems",
    "Discrete Mathematical Structures",
    "Compiler Design & Translation",
    "Distributed Systems & Consensus",
    "Machine Learning Foundations",
    "Software Quality Assurance",
    "Digital Logic Design & Systems",
    "System Analysis and Design",
    "UI/UX Design Fundamentals",
    "Project Management & Agile Methodologies",
    "Network Security & Defense",
    "Neural Networks & Deep Learning",
    "Introduction to Blockchain & Web3",
    "Game Engine Development",
    "Parallel & Concurrent Programming",
    "Natural Language Processing",
  ];

  static final List<String> _courseDescriptions = [
    "An introduction to the concepts and techniques of computer programming using modern high-level languages.",
    "Fundamental concepts of data structures including arrays, linked lists, stacks, queues, trees, and sorting algorithms.",
    "Concepts of OOP including classes, objects, inheritance, polymorphism, encapsulation, and software design patterns.",
    "Design and implementation of relational database systems, SQL query optimization, normalization, and ACID properties.",
    "Engineering methodologies for planning, designing, implementing, testing, and maintaining large-scale software systems.",
    "Concepts of operating system design, process synchronization, CPU scheduling, virtual memory, and file structures.",
    "Network topologies, OSI model protocols, TCP/IP socket programming, packet routing, and network diagnostics.",
    "Fundamental search algorithms, knowledge representation systems, logical agents, and introduction to modern AI.",
    "Building responsive full-stack web applications using contemporary web technologies, APIs, and frameworks.",
    "Design and implementation of cross-platform mobile apps for iOS and Android using Flutter and Dart.",
    "Principles of user-centered design, usability testing, prototyping, cognitive load optimization, and wireframing.",
    "Instruction set architecture, assembly language programming, CPU pipelines, memory cache, and control units.",
    "Basic threats, system vulnerabilities, hashing algorithms, symmetric and asymmetric cryptography, and access control.",
    "Virtualization, cloud architectures (IaaS/PaaS/SaaS), serverless development, and hands-on container orchestration.",
    "Statistical modeling, data pre-processing, exploratory analysis, visualization, and big data framework workflows.",
    "Mathematical logic, set theory, graph theory, combinatorics, and algebraic structures applied to algorithms.",
    "Lexical parsing, syntax tree generation, semantic analysis, intermediate representation, and machine code optimization.",
    "Designing resilient distributed architectures, consensus protocols, data replication, and distributed ledgers.",
    "Mathematical foundations of supervised/unsupervised learning, gradient descent, regressions, and classifications.",
    "Verification and validation methodologies, automated unit/integration testing, CI/CD pipelines, and quality metrics.",
  ];

  static String getRealisticTitle(int id, String originalTitle) {
    if (id <= 0 || id > 100) return originalTitle;
    final index = (id - 1) % _courseNames.length;
    return _courseNames[index];
  }

  static String getRealisticBody(int id, String originalBody) {
    if (id <= 0 || id > 100) return originalBody;
    final index = (id - 1) % _courseDescriptions.length;
    return _courseDescriptions[index];
  }

  // Factory constructor to parse Course from JSON response
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  // Method to serialize Course to JSON for network payload
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }

  // Helper method to create a modified clone of a course
  CourseModel copyWith({
    int? id,
    String? title,
    String? body,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}
