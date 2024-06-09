import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:svg_flutter/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SecureStorage storage = SecureStorage();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    openSplashScreen();
    super.initState();
  }

  openSplashScreen() async {
    var duration = const Duration(
      seconds: 5,
    );

    return Timer(
      duration,
      () async {
        if (currentUser != null) {
          context.pushReplacementNamed(AppRoute.checkWalletScreen.name);
        } else {
          context.pushReplacementNamed(AppRoute.loginScreen.name);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: ScreenUtil().setHeight(844),
        width: ScreenUtil().setWidth(390),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: SvgPicture.asset(
                  'assets/images/Shape background.svg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: ScreenUtil().setHeight(350),
              left: ScreenUtil().setWidth(106),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/Logo e-presensi.svg',
                  height: ScreenUtil().setHeight(177),
                  width: ScreenUtil().setWidth(177),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
