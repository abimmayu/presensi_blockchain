import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/utils/injection.dart' as di;
import 'package:presensi_blockchain/feature/dashboard/presentation/bloc/home_bloc.dart';
import 'package:presensi_blockchain/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:presensi_blockchain/feature/present/presentation/bloc/present_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/change_password/change_password_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/get_all_present/get_present_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/get_holiday/get_holiday_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/present_time/present_time_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/user/user_bloc.dart';
import 'package:presensi_blockchain/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  await initializeDateFormatting('id_ID', null).then(
    (value) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    di.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.locator<AuthBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => di.locator<HomeBloc>(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => di.locator<UserBloc>(),
        ),
        BlocProvider<PresentBloc>(
          create: (context) => di.locator<PresentBloc>(),
        ),
        BlocProvider<AllPresentBloc>(
          create: (context) => di.locator<AllPresentBloc>(),
        ),
        BlocProvider<HolidayBloc>(
          create: (context) => di.locator<HolidayBloc>(),
        ),
        BlocProvider<ChangePasswordBloc>(
          create: (context) => di.locator<ChangePasswordBloc>(),
        ),
        BlocProvider<PresentTimeBloc>(
          create: (context) => di.locator<PresentTimeBloc>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp.router(
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
