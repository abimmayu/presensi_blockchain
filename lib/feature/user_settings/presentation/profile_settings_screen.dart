import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/core/widget/custom_nav_bar.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavBar(
        currentIndex: 1,
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'Profile Settings',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MainButton(
              onTap: () {
                context.pushNamed(
                  AppRoute.seePrivateKeyScreen.name,
                );
              },
              text: "Private Key",
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            MainButton(
              onTap: () {
                context.pushNamed(
                  AppRoute.seeRecoveryPhraseScreen.name,
                );
              },
              text: "Frasa Pemulihan",
            ),
          ],
        ),
      ),
    );
  }
}
