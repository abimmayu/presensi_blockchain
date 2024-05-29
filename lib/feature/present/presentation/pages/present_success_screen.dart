import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:svg_flutter/svg.dart';

class PresentSuccessScreen extends StatelessWidget {
  const PresentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Presensi Berhasil!",
              style: headingBold,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            SvgPicture.asset('assets/images/Present Success.svg'),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Text(
              "Data presensi anda berhasil dikirimkan",
              style: bigTextRegular,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            MainButton(
              onTap: () {
                context.goNamed(AppRoute.dashboardScreen.name);
              },
              text: "Kembali ke Beranda",
              width: ScreenUtil().setWidth(320),
            )
          ],
        ),
      ),
    );
  }
}
