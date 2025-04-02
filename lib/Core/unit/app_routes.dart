import 'package:deacon_school_admin/Core/widget/app_layout_custom.dart';
import 'package:deacon_school_admin/Features/Auth/presentation/view/screen/login_screen.dart';
import 'package:deacon_school_admin/Features/Lectures/presentation/view/screen/audio_player_screen.dart';
import 'package:deacon_school_admin/Features/Lectures/presentation/view/screen/lecture_content_screen.dart';
import 'package:deacon_school_admin/Features/Lectures/presentation/view/screen/lecture_pdf_screen.dart';
import 'package:deacon_school_admin/Features/Levels/presentation/view/screen/level_screen.dart';
import 'package:deacon_school_admin/Features/Levels/presentation/view/screen/person_details_screen.dart';
import 'package:go_router/go_router.dart';


abstract class AppRouter {

  static const kLoginView='/';
  static const kAppLayoutView='/AppLayoutView';
  static const kAudioPlayerScreenView='/AudioPlayerScreen';
  static const kLectureContentScreenView='/LectureContentScreen';
  static const kLecturePDFScreenView='/LecturePDFScreen';
  static const kLevelScreenView='/LevelScreen';
  static const kPersonDetailsScreenView='/PersonDetailsScreen';

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
          path: kLoginView,
          builder: (context, state){
            return LoginScreen();
          }),
      GoRoute(
          path: kAppLayoutView,
          builder: (context, state){
            return AppLayoutCustom();
          }),
      GoRoute(
          path: kAudioPlayerScreenView,
          builder: (context, state){
            return AudioPlayerScreen();
          }),
      GoRoute(
          path: kLectureContentScreenView,
          builder: (context, state){
            return LectureContentScreen();
          }),
      GoRoute(
          path: kLecturePDFScreenView,
          builder: (context, state){
            return LecturePDFScreen();
          }),
      GoRoute(
          path: kLevelScreenView,
          builder: (context, state){
            return LevelScreen();
          }),
      GoRoute(
          path: kPersonDetailsScreenView,
          builder: (context, state){
            return PersonDetailsScreen();
          }),
    ],
  );
}
