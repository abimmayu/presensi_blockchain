import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/core/widget/custom_nav_bar.dart';
import 'package:presensi_blockchain/feature/present/presentation/bloc/present_bloc.dart';
import 'package:presensi_blockchain/feature/present/presentation/pages/presented_screen.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/user_bloc.dart';

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
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildWidget();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services'),
        ),
      );
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permissions are denied',
            ),
          ),
        );
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then(
      (value) => setState(
        () {
          position = value;
        },
      ),
    );
  }

  Widget buildWidget() {
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
                context.pushNamed(
                  AppRoute.presentedScreen.name,
                  extra: PresentedScreenParam(position!),
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

  Future<void> addPresence(BuildContext context) async {
    dynamic data;
    context.read<UserBloc>().add(
          GetUserData(user!.uid),
        );

    final completer = Completer();
    final listener = BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          data = state.user;
          completer.complete();
        }
      },
    );

    await completer.future;

    var now = DateTime.now();

    if (data["role"] == "admin") {
      context.read<PresentBloc>().add(
            PresentIn(
              BigInt.from(now.millisecondsSinceEpoch),
              BigInt.from(now.day),
              BigInt.from(now.month),
              BigInt.from(now.year),
              "Masuk",
            ),
          );
      context.read<PresentBloc>().add(
            PresentOut(
              BigInt.from(now.millisecondsSinceEpoch),
              BigInt.from(now.day),
              BigInt.from(now.month),
              BigInt.from(now.year),
              "Pulang",
            ),
          );
    }
  }
}
