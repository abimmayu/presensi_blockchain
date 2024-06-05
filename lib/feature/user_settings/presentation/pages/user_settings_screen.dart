import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/widget/custom_nav_bar.dart';
import 'package:presensi_blockchain/core/widget/list_user_settings.dart';
import 'package:presensi_blockchain/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presensi_blockchain/feature/present/presentation/bloc/present_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/user_bloc.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  dynamic data;

  @override
  void initState() {
    context.read<UserBloc>().add(
          GetUserData(user!.uid),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomNavBar(
        currentIndex: 1,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(150),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: greyColor,
                        offset: Offset(0, 4),
                        spreadRadius: 4,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  width: MediaQuery.sizeOf(context).width,
                  height: ScreenUtil().setHeight(100),
                  child: const Center(
                    child: Stack(
                      children: [
                        // Container(
                        //   decoration: BoxDecoration(
                        //     image: const DecorationImage(
                        //       image: NetworkImage(
                        //         'https://d1bpj0tv6vfxyp.cloudfront.net/alasan-orang-yang-sibuk-kerja-harus-olahraga-ringan-teratur-halodoc.png',
                        //       ),
                        //       fit: BoxFit.cover,
                        //       scale: 1,
                        //     ),
                        //     borderRadius: BorderRadius.circular(150),
                        //     border: Border.all(
                        //       color: whiteColor,
                        //       width: ScreenUtil().setWidth(5),
                        //     ),
                        //   ),
                        //   height: ScreenUtil().setHeight(150),
                        //   width: ScreenUtil().setHeight(150),
                        // ),

                        // Positioned(
                        //   right: ScreenUtil().setWidth(10),
                        //   bottom: 0,
                        //   child: Container(
                        //     width: ScreenUtil().setHeight(35),
                        //     height: ScreenUtil().setHeight(35),
                        //     decoration: BoxDecoration(
                        //       color: whiteColor,
                        //       borderRadius: BorderRadius.circular(30),
                        //     ),
                        //     child: const Icon(
                        //       Icons.photo_camera,
                        //       color: blackColor,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: ScreenUtil().setWidth(45),
                  child: Container(
                    padding: EdgeInsets.all(
                      ScreenUtil().setHeight(10),
                    ),
                    height: 125.h,
                    width: 300.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: mainColor,
                      boxShadow: const [
                        BoxShadow(
                          color: greyColor,
                          spreadRadius: 4,
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                      border: Border.all(
                        color: whiteColor,
                        width: ScreenUtil().setWidth(2),
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    child: BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is UserLoaded) {
                          data = state.user;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: ScreenUtil().setHeight(40),
                                child: Text(
                                  data["name"],
                                  style: normalText.copyWith(color: whiteColor),
                                ),
                              ),
                              Text(
                                "${(data["nip"] as double).toInt()}",
                                style: tinyText.copyWith(
                                  color: whiteColor,
                                ),
                              ),
                              Text(
                                data["occupation"],
                                style: tinyText.copyWith(
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: whiteColor,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Row(
            children: [
              SizedBox(
                width: ScreenUtil().setWidth(50),
              ),
              Text(
                "App Settings",
                style: normalText.copyWith(
                  color: greyColor,
                ),
              ),
            ],
          ),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is UserLoaded) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    ListUserSettingsWidget(
                      icon: Icons.person,
                      title: "Profile Settings",
                      action: () {
                        context.pushNamed(AppRoute.profileSettingScreen.name);
                      },
                    ),
                    state.user["role"] == "admin"
                        ? ListUserSettingsWidget(
                            icon: Icons.person_add,
                            title: "Add an Account",
                            action: () {
                              context.pushNamed(
                                  AppRoute.profileSettingScreen.name);
                            },
                          )
                        : const SizedBox.shrink(),
                    state.user["role"] == "admin"
                        ? ListUserSettingsWidget(
                            icon: Icons.person_add,
                            title: "Generate today's present",
                            action: () {
                              context.read<PresentBloc>().add(
                                    PresentIn(
                                      BigInt.from(DateTime.now()
                                          .millisecondsSinceEpoch),
                                      BigInt.from(DateTime.now().day),
                                      BigInt.from(DateTime.now().month),
                                      BigInt.from(DateTime.now().year),
                                      "Masuk",
                                    ),
                                  );
                              context.read<PresentBloc>().add(
                                    PresentOut(
                                      BigInt.from(DateTime.now()
                                          .millisecondsSinceEpoch),
                                      BigInt.from(DateTime.now().day),
                                      BigInt.from(DateTime.now().month),
                                      BigInt.from(DateTime.now().year),
                                      "Pulang",
                                    ),
                                  );
                            },
                          )
                        : const SizedBox.shrink(),
                    ListUserSettingsWidget(
                      icon: Icons.key,
                      title: "Change Password",
                      action: () {
                        context.pushNamed(AppRoute.changePasswordScreen.name);
                      },
                    ),
                    ListUserSettingsWidget(
                      icon: Icons.logout,
                      title: "Logout",
                      action: () {},
                    ),
                    // ListUserSettingsWidget(
                    //   icon: Icons.account_balance_wallet,
                    //   title: "Import Wallet",
                    //   action: () {
                    //     context.pushNamed(AppRoute.importWalletScreen.name);
                    //   },
                    // ),
                  ],
                );
              } else if (state is UserError) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
