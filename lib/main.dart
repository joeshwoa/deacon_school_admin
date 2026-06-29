import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'Core/cubit/layout_cubit.dart';
import 'Core/services/custom_bloc_observer.dart';
import 'Core/services/shared_pref_services.dart';
import 'Core/services/supabase_service.dart';
import 'Core/theme/app_theme.dart';
import 'Core/theme/theme_cubit.dart';
import 'Core/translations/codegen_loader.g.dart';
import 'Core/unit/app_routes.dart';
import 'Core/unit/constant_data.dart';
import 'Features/Auth/presentation/cubit/auth_cubit.dart';
import 'Features/Grades/presentation/cubit/grades_cubit.dart';
import 'Features/Lectures/presentation/cubit/lectures_cubit.dart';
import 'Features/Levels/presentation/cubit/levels_cubit.dart';
import 'Features/Notifications/presentation/cubit/notifications_cubit.dart';
import 'Features/Students/presentation/cubit/students_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // No .env bundled yet – the app still boots; backend stays disconnected.
  }

  Bloc.observer = CustomBlocObserver();
  await SharedPreferencesServices.init();
  await SupabaseService.init();

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [Locale('ar'), Locale('en')],
      fallbackLocale: const Locale('ar'),
      startLocale: Locale(
        SharedPreferencesServices.getData(key: ConstantData.kLung) ??
            ConstantData.kDefaultLung,
      ),
      assetLoader: const CodegenLoader(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => LayoutCubit()),
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (_) => LevelsCubit()),
          BlocProvider(create: (_) => LecturesCubit()),
          BlocProvider(create: (_) => NotificationsCubit()),
          BlocProvider(create: (_) => StudentsCubit()),
          BlocProvider(create: (_) => GradesCubit()),
        ],
        child: const DeaconSchoolAdminApp(),
      ),
    ),
  );
}

class DeaconSchoolAdminApp extends StatelessWidget {
  const DeaconSchoolAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          title: 'Deacon School Admin',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
