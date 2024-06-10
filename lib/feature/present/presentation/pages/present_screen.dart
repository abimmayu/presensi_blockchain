import 'dart:async';
import 'dart:developer';

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
import 'package:presensi_blockchain/feature/present/presentation/pages/home_present_screen.dart';
import 'package:presensi_blockchain/feature/present/presentation/pages/presented_screen.dart';

class PresentScreen extends StatefulWidget {
  const PresentScreen({super.key});

  @override
  State<PresentScreen> createState() => _PresentScreenState();
}

class _PresentScreenState extends State<PresentScreen> {
  Position? position;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> getLocation() {
    return Future(
      () => context.read<PresentBloc>().add(
            GetCurrentLocation(),
          ),
    );
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomNavBar(
        currentIndex: 0,
      ),
      // appBar: const PreferredSize(
      //   preferredSize: Size.fromHeight(kToolbarHeight),
      //   child: CustomAppBar(
      //     title: 'Present',
      //   ),
      // ),
      body: RefreshIndicator(
        onRefresh: () => getLocation(),
        child: ListView(
          children: [
            BlocConsumer<PresentBloc, PresentState>(
              listener: (context, state) {
                if (state is PresentLocationGet) {
                  setState(
                    () {
                      position = state.position;
                    },
                  );
                }
              },
              builder: (context, state) {
                if (state is PresentLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  );
                } else if (state is PresentError) {
                  return Center(
                    child: Text(state.error),
                  );
                } else if (state is PresentLocationGet) {
                  return buildWidget();
                }
                return Column(
                  children: [
                    buildWidget(),
                    SizedBox(
                      height: 50.h,
                    ),
                    Text(
                      "Please refresh to get you location!",
                      style: normalText,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
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
                extra: HomePresentedParam(position!),
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
    );
  }
}
