import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/feature/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:presensi_blockchain/feature/login/presentation/pages/check_user_wallet_screen.dart';
import 'package:presensi_blockchain/feature/login/presentation/pages/create_wallet_screen.dart';
import 'package:presensi_blockchain/feature/login/presentation/pages/import_wallet_screen.dart';
import 'package:presensi_blockchain/feature/login/presentation/pages/login_screen.dart';
import 'package:presensi_blockchain/feature/login/presentation/pages/reminder_recovery_phrase_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/pages/day_off_present_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/pages/home_present_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/pages/present_success_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/pages/presented_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/pages/present_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/pages/transaction_sepolia_screen.dart';
import 'package:presensi_blockchain/feature/splash/splash_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/admin_menu/account_setting/add_account_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/admin_menu/change_present_time_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/admin_menu/present_collected/present_collected_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/admin_menu/present_collected/present_detail_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/change_password_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/profile_settings/private_key/copy_private_key_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/profile_settings/recovery_phrase/copy_recovery_phrase_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/profile_settings/profile_settings_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/profile_settings/private_key/see_private_key_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/profile_settings/recovery_phrase/see_recovery_phrase_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/user_settings_screen.dart';

enum AppRoute {
  splashScreen,
  loginScreen,
  checkWalletScreen,
  createWalletScreen,
  doneCreateWallet,
  dashboardScreen,
  presentScreen,
  presentedScreen,
  homePresentScreen,
  dayOffScreen,
  presentSuccessScreen,
  presentTransactionScreen,
  presentFailedScreen,
  userSettingScreen,
  profileSettingScreen,
  seePrivateKeyScreen,
  copyPrivateKeyScreen,
  seeRecoveryPhraseScreen,
  copyRecoveryPhraseScreen,
  importWalletScreen,
  changePasswordScreen,
  accountSettingsScreen,
  adminScreen,
  addAccountScreen,
  editAccountScreen,
  presentCollectedScreen,
  presentDetailScreen,
  chagePresentTimeScreen,
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
      routes: [
        GoRoute(
          path: 'check-wallet',
          name: AppRoute.checkWalletScreen.name,
          builder: (context, state) {
            return const IntializeUser();
          },
          routes: [
            GoRoute(
              path: 'create-wallet-1',
              name: AppRoute.createWalletScreen.name,
              builder: (context, state) {
                return const CreateWalletScreen();
              },
            ),
            GoRoute(
              path: 'import-wallet',
              name: AppRoute.importWalletScreen.name,
              builder: (context, state) {
                return const ImportWalletScreen();
              },
              routes: [
                GoRoute(
                  path: 'done-create-wallet',
                  name: AppRoute.doneCreateWallet.name,
                  builder: (context, state) {
                    return const DoneCreateWalletScreen();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/dashboard',
      name: AppRoute.dashboardScreen.name,
      builder: (context, state) {
        final extra = state.extra as DashboardParam;
        return DashboardScreen(
          param: extra,
        );
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
          path: 'present-success/:hashTrx',
          name: AppRoute.presentSuccessScreen.name,
          builder: (context, state) {
            return PresentSuccessScreen(
              hashTrx: state.pathParameters['hashTrx']!,
            );
          },
        ),
        GoRoute(
          path: 'present-transaction/:hashTrx',
          name: AppRoute.presentTransactionScreen.name,
          builder: (context, state) {
            return HistoryTransaction(
              hashTrx: state.pathParameters['hashTrx']!,
            );
          },
        )
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
          routes: [
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
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/change-password',
      name: AppRoute.changePasswordScreen.name,
      builder: (context, state) {
        return const ChangePasswordScreen();
      },
    ),
    GoRoute(
      path: '/admin-dashboard',
      name: AppRoute.adminScreen.name,
      builder: (context, state) {
        return Container();
      },
      routes: [
        GoRoute(
          path: 'account-settings',
          name: AppRoute.accountSettingsScreen.name,
          builder: (context, state) {
            return Container();
          },
          routes: [
            GoRoute(
              path: 'add-account',
              name: AppRoute.addAccountScreen.name,
              builder: (context, state) {
                return const AddAccountScreen();
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
          path: 'present-collected',
          name: AppRoute.presentCollectedScreen.name,
          builder: (context, state) {
            return const PresentCollectedScreen();
          },
          routes: [
            GoRoute(
              path: 'present-detail',
              name: AppRoute.presentDetailScreen.name,
              builder: (context, state) {
                final param = state.extra as PresentDetailParam;
                return PresentDetailScreen(
                  param: param,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'change-present-time',
          name: AppRoute.chagePresentTimeScreen.name,
          builder: (context, state) {
            return const ChangePresentTimeScreen();
          },
        ),
      ],
    ),
  ],
);
