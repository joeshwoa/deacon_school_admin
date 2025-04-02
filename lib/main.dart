import 'package:deacon_school_admin/Core/cubit/layout_cubit.dart';
import 'package:deacon_school_admin/Features/Auth/presentation/cubit/auth_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deacon_school_admin/Core/services/custom_bloc_observer.dart';
import 'package:deacon_school_admin/Core/services/shared_pref_services.dart';
import 'package:deacon_school_admin/Core/translations/codegen_loader.g.dart';
import 'package:deacon_school_admin/Core/unit/app_routes.dart';
import 'package:deacon_school_admin/Core/unit/border_data.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/constant_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //await dotenv.load(fileName: ".env");

  Bloc.observer = CustomBlocObserver();
  await SharedPreferencesServices.init();

  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    runApp(EasyLocalization(
        path: 'assets/translations',
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        fallbackLocale: Locale(ConstantData.kDefaultLung),
        startLocale: Locale(SharedPreferencesServices.getData(key: ConstantData.kLung)??ConstantData.kDefaultLung),
        assetLoader: const CodegenLoader(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider (create: (BuildContext context) => LayoutCubit(),),
            BlocProvider (create: (BuildContext context) => AuthCubit(),),
            /*BlocProvider (create: (BuildContext context) => MyBookingCubit(),),*/
          ],
          child: const MyApp(),)));
  });


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    StyleData.init(context);
    BorderData.init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: ColorData.primaryColor
    ));

    return MaterialApp.router(
      title: 'شماس مدرسة الِشمامسة',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: ColorData.primaryColor),
      ),
      routerConfig: AppRouter.router,
    );
  }
}

