import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/feature/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:presensi_blockchain/feature/login/presentation/pages/check_user_wallet_screen.dart';
import 'package:presensi_blockchain/feature/login/presentation/pages/create_wallet_screen.dart';
import 'package:presensi_blockchain/feature/login/presentation/pages/login_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/pages/day_off_present_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/pages/home_present_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/pages/present_success_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/pages/presented_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/pages/present_screen.dart';
import 'package:presensi_blockchain/feature/splash/splash_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/change_password_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/copy_private_key_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/copy_recovery_phrase_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/import_wallet_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/profile_settings_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/see_private_key_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/see_recovery_phrase_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/user_settings_screen.dart';

enum AppRoute {
  splashScreen,
  loginScreen,
  checkWalletScreen,
  createWalletScreen,
  dashboardScreen,
  presentScreen,
  presentedScreen,
  homePresentScreen,
  dayOffScreen,
  presentSuccessScreen,
  presentFailedScreen,
  userSettingScreen,
  profileSettingScreen,
  seePrivateKeyScreen,
  copyPrivateKeyScreen,
  seeRecoveryPhraseScreen,
  copyRecoveryPhraseScreen,
  importWalletScreen,
  changePasswordScreen,
  adminScreen,
  accountSettingsScreen,
  addAccountScreen,
  editAccountScreen,
  presentCollectedScreen,
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
        return LoginScreen();
      },
      routes: [
        GoRoute(
          path: 'check-wallet',
          name: AppRoute.checkWalletScreen.name,
          builder: (context, state) {
            return const IntializeUser();
          },
        ),
        GoRoute(
          path: 'create-wallet-1',
          name: AppRoute.createWalletScreen.name,
          builder: (context, state) {
            return CreateWalletScreen();
          },
        ),
      ],
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
            return PresentedScreen();
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
    GoRoute(
      path: '/user-settings',
      name: AppRoute.userSettingScreen.name,
      builder: (context, state) {
        return const UserSettingsScreen();
      },
      routes: [
        GoRoute(
          path: 'profile-setting',
          name: AppRoute.profileSettingScreen.name,
          builder: (context, state) {
            return const ProfileSettingsScreen();
          },
        ),
        GoRoute(
          path: 'see-private-key',
          name: AppRoute.seePrivateKeyScreen.name,
          builder: (context, state) {
            return const PrivateKeyScreen();
          },
          routes: [
            GoRoute(
              path: 'copy-private-key',
              name: AppRoute.copyPrivateKeyScreen.name,
              builder: (context, state) {
                return const CopyPrivateKeyScreen();
              },
            )
          ],
        ),
        GoRoute(
          path: 'see-recovery-phrase',
          name: AppRoute.seeRecoveryPhraseScreen.name,
          builder: (context, state) {
            return const RecoveryPhraseScreen();
          },
          routes: [
            GoRoute(
              path: 'copy-recovery-phrase',
              name: AppRoute.copyRecoveryPhraseScreen.name,
              builder: (context, state) {
                return const CopyRecoveryPhraseScreen();
              },
            ),
          ],
        ),
        GoRoute(
          path: 'import-wallet',
          name: AppRoute.importWalletScreen.name,
          builder: (context, state) {
            return const ImportWalletScreen();
          },
        ),
        GoRoute(
          path: 'change-password',
          name: AppRoute.changePasswordScreen.name,
          builder: (context, state) {
            return const ChangePasswordScreen();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/admin-dashboard',
      name: AppRoute.adminScreen.name,
      builder: (context, state) {
        return Container();
      },
    ),
    GoRoute(
      path: '/account-settings',
      name: AppRoute.accountSettingsScreen.name,
      builder: (context, state) {
        return Container();
      },
      routes: [
        GoRoute(
          path: 'add-account',
          name: AppRoute.addAccountScreen.name,
          builder: (context, state) {
            return Container();
          },
        ),
        GoRoute(
          path: 'edit-account',
          name: AppRoute.editAccountScreen.name,
          builder: (context, state) {
            return Container();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/present-collected',
      name: AppRoute.presentCollectedScreen.name,
      builder: (context, state) {
        return Container();
      },
    ),
  ],
);
