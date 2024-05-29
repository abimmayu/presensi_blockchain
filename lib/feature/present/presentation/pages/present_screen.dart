import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/core/widget/custom_nav_bar.dart';

class PresentScreen extends StatelessWidget {
  const PresentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomNavBar(
        currentIndex: 0,
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'Present',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Silahkan pilih menu presensi anda",
              style: normalText,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            MainButton(
              onTap: () {
                context.pushNamed(AppRoute.presentedScreen.name);
              },
              text: "Masuk",
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            MainButton(
              onTap: () {
                context.pushNamed(
                  AppRoute.homePresentScreen.name,
                );
              },
              text: "Pulang",
            ),
            // SizedBox(
            //   height: ScreenUtil().setHeight(30),
            // ),
            // MainButton(
            //   onTap: () {
            //     context.pushNamed(
            //       AppRoute.dayOffScreen.name,
            //     );
            //   },
            //   text: "Izin",
            // ),
          ],
        ),
      ),
    );
  }
}
