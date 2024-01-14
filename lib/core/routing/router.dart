import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/feature/dashboard/presentation/dashboard_screen.dart';
import 'package:presensi_blockchain/feature/login/presentation/login_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/day_off_present_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/home_present_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/present_success_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/presented_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/present_screen.dart';
import 'package:presensi_blockchain/feature/splash/splash_screen.dart';

enum AppRoute {
  splashScreen,
  loginScreen,
  dashboardScreen,
  presentScreen,
  presentedScreen,
  homePresentScreen,
  dayOffScreen,
  presentSuccessScreen,
  presentFailedScreen,
  userSettingScreen,
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.splashScreen.name,
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/login',
      name: AppRoute.loginScreen.name,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/dashboard',
      name: AppRoute.dashboardScreen.name,
      builder: (context, state) {
        return const DashboardScreen();
      },
    ),
    GoRoute(
      path: '/present',
      name: AppRoute.presentScreen.name,
      builder: (context, state) {
        return const PresentScreen();
      },
      routes: [
        GoRoute(
          path: 'presented',
          name: AppRoute.presentedScreen.name,
          builder: (context, state) {
            return const PresentedScreen();
          },
        ),
        GoRoute(
          path: 'home-present',
          name: AppRoute.homePresentScreen.name,
          builder: (context, state) {
            return const HomePresentedScreen();
          },
        ),
        GoRoute(
          path: 'day-off',
          name: AppRoute.dayOffScreen.name,
          builder: (context, state) {
            return const DayOffScreen();
          },
        ),
        GoRoute(
          path: 'present-success',
          name: AppRoute.presentSuccessScreen.name,
          builder: (context, state) {
            return const PresentSuccessScreen();
          },
        ),
        GoRoute(
          path: 'present-failed',
          name: AppRoute.presentFailedScreen.name,
          builder: (context, state) {
            return const PresentSuccessScreen();
          },
        ),
      ],
    ),
  ],
);
