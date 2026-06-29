import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/auth_repository.dart';
import '../models/lecture.dart';
import '../models/level.dart';
import '../models/student.dart';
import '../../Features/Auth/presentation/view/screen/login_screen.dart';
import '../../Features/Grades/presentation/view/screen/student_grades_screen.dart';
import '../../Features/Home/presentation/view/screen/home_screen.dart';
import '../../Features/Lectures/presentation/view/screen/audio_player_screen.dart';
import '../../Features/Lectures/presentation/view/screen/lecture_content_screen.dart';
import '../../Features/Lectures/presentation/view/screen/lecture_pdf_screen.dart';
import '../../Features/Students/presentation/view/screen/level_students_screen.dart';

abstract class AppRouter {
  static const kLogin = '/';
  static const kHome = '/home';
  static const kLevelStudents = '/level-students';
  static const kStudentGrades = '/student-grades';
  static const kLectureContent = '/lecture-content';
  static const kLecturePdf = '/lecture-pdf';
  static const kAudio = '/audio';

  static final AuthRepository _auth = AuthRepository();

  static final GoRouter router = GoRouter(
    initialLocation: kLogin,
    refreshListenable: _AuthRefresh(),
    redirect: (context, state) {
      final loggedIn = _auth.isLoggedIn;
      final onLogin = state.matchedLocation == kLogin;
      if (!loggedIn && !onLogin) return kLogin;
      if (loggedIn && onLogin) return kHome;
      return null;
    },
    routes: [
      GoRoute(path: kLogin, builder: (_, __) => const LoginScreen()),
      GoRoute(path: kHome, builder: (_, __) => const HomeScreen()),
      GoRoute(
        path: kLevelStudents,
        builder: (_, state) =>
            LevelStudentsScreen(level: state.extra as Level),
      ),
      GoRoute(
        path: kStudentGrades,
        builder: (_, state) =>
            StudentGradesScreen(student: state.extra as Student),
      ),
      GoRoute(
        path: kLectureContent,
        builder: (_, state) =>
            LectureContentScreen(lecture: state.extra as Lecture),
      ),
      GoRoute(
        path: kLecturePdf,
        builder: (_, state) => LecturePdfScreen(lecture: state.extra as Lecture),
      ),
      GoRoute(
        path: kAudio,
        builder: (_, state) =>
            AudioPlayerScreen(lecture: state.extra as Lecture),
      ),
    ],
  );
}

/// Bridges Supabase auth changes to GoRouter's refresh mechanism.
class _AuthRefresh extends ChangeNotifier {
  StreamSubscription? _sub;
  _AuthRefresh() {
    _sub = AuthRepository().authChanges?.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
