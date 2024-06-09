import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/user_bloc.dart';
import 'package:svg_flutter/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  String? deviceId;
  String? userId;

  Future<void> initDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? id;

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        id = androidInfo.id; // Mengambil Android ID
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        id = iosInfo.identifierForVendor
            .toString(); // Mengambil ID Perangkat iOS
      } else {
        id = null;
      }
      log("$id");
    } catch (e) {
      id = null;
      throw Exception(e);
    }

    if (!mounted) return;

    setState(() {
      deviceId = id;
    });
  }

  @override
  void initState() {
    initDeviceId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          if (state.user['device_id'] == null ||
              state.user['device_id'] == '') {
            context.read<UserBloc>().add(
                  PostPublicKey(
                    userId.toString(),
                    {
                      "device_id": deviceId,
                    },
                    null,
                  ),
                );
          } else if (state.user['device_id'] == deviceId) {
            context.pushReplacementNamed(AppRoute.checkWalletScreen.name);
          } else if (state.user['device_id'] != deviceId) {
            context.read<AuthBloc>().add(
                  AuthLogout(
                    AuthSignout(),
                  ),
                );
            showDialog(
              context: context,
              builder: (context) {
                return deviceIdDialog();
              },
            );
          }
        }
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          log(state.toString());
          if (state is AuthSuccess) {
            setState(() {
              userId = state.user.uid;
            });
            context.read<UserBloc>().add(
                  GetUserData(state.user.uid),
                );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: mainColor,
          body: Center(
            child: Container(
              padding: const EdgeInsets.all(30),
              height: ScreenUtil().setHeight(456),
              width: ScreenUtil().setWidth(332),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 3,
                    offset: const Offset(0, 4),
                    color: blackColor.withOpacity(0.3),
                  )
                ],
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: headingBold,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(70),
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: ScreenUtil().setWidth(6),
                              ),
                              SvgPicture.asset(
                                'assets/images/ID Number logo.svg',
                                height: ScreenUtil().setHeight(20),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(15),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration.collapsed(
                                    hintText: 'Type your ID Number',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: blackColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(35),
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: ScreenUtil().setWidth(9),
                              ),
                              SvgPicture.asset(
                                'assets/images/Password logo.svg',
                                height: ScreenUtil().setHeight(30),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(12),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration.collapsed(
                                    hintText: 'Type your password',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: blackColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(50),
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthInitial) {
                          return loginButton();
                        } else if (state is AuthLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: mainColor,
                            ),
                          );
                        } else if (state is AuthError) {
                          return loginButton();
                        } else if (state is AuthSignout) {
                          return loginButton();
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return MainButton(
      onTap: () {
        log(emailController.text);
        log(passwordController.text);
        context.read<AuthBloc>().add(
              AuthLogin(
                emailController.text,
                passwordController.text.toString(),
              ),
            );
      },
      text: 'Login',
    );
  }

  AlertDialog deviceIdDialog() {
    return AlertDialog(
      title: Text(
        "It's not your device!",
        style: bigTextSemibold,
      ),
      content: Text(
        "Please log in with your own device. You can contact the admin if your device has lost!",
        style: tinyText,
      ),
      backgroundColor: whiteColor,
      shadowColor: greyColor,
      actions: [
        InkWell(
          onTap: () {
            context.pop();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 5.h,
            ),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(
                5.w,
              ),
            ),
            child: Text(
              "Ok",
              style: normalText,
            ),
          ),
        )
      ],
    );
  }
}
