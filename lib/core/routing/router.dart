import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/feature/dashboard/presentation/dashboard_screen.dart';
import 'package:presensi_blockchain/feature/login/presentation/login_screen.dart';
import 'package:presensi_blockchain/feature/splash/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      name: 'splash-screen',
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/login',
      name: 'login-screen',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard-screen',
      builder: (context, state) {
        return DashboardScreen();
      },
    )
  ],
);
