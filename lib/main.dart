import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/utils/injection.dart' as di;
import 'package:presensi_blockchain/feature/dashboard/presentation/bloc/home_bloc.dart';
import 'package:presensi_blockchain/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:presensi_blockchain/feature/present/data/data_post/present_data_post.dart';
import 'package:presensi_blockchain/feature/present/presentation/bloc/present_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/user_bloc.dart';
import 'package:presensi_blockchain/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AndroidAlarmManager.initialize();
  await AndroidAlarmManager.periodic(
    const Duration(hours: 24),
    0,
    () => addPresent(),
    startAt: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      7,
      0,
    ),
    exact: true,
    wakeup: true,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  runApp(
    const MyApp(),
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

void addPresent() async {
  PresentDataPost presentDataPost = PresentDataPostImpl();
  final now = DateTime.now();
  final today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    7,
    0,
  ).millisecondsSinceEpoch;

  Future.wait({
    presentDataPost.addPresentIn(
      id: BigInt.from(today),
      day: BigInt.from(now.day),
      month: BigInt.from(now.month),
      year: BigInt.from(now.year),
    ),
    presentDataPost.addPresentOut(
      id: BigInt.from(now.millisecondsSinceEpoch),
      day: BigInt.from(now.day),
      month: BigInt.from(now.month),
      year: BigInt.from(now.year),
    ),
  });
}
