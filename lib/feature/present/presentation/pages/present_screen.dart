import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_nav_bar.dart';

class PresentScreen extends StatefulWidget {
  const PresentScreen({super.key});

  @override
  State<PresentScreen> createState() => _PresentScreenState();
}

class _PresentScreenState extends State<PresentScreen> {
  Position? position;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomNavBar(
        currentIndex: 0,
      ),
      body: ListView(
        children: [
          buildWidget(),
        ],
      ),
    );
  }

  Widget buildWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150.h,
          ),
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
              context.pushNamed(
                AppRoute.presentedScreen.name,
              );
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
        ],
      ),
    );
  }
}
