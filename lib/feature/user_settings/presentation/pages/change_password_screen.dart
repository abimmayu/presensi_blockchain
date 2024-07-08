import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/change_password/change_password_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String? oldPassword;

  getPassword() async {
    var localOldPassword = await SecureStorage().readData(
      key: AppConstant.userPassword,
    );

    setState(() {
      oldPassword = localOldPassword;
      log("oldPassword: $localOldPassword");
    });
  }

  @override
  void initState() {
    getPassword();
    super.initState();
  }

  bool oldPasswordHide = true;
  bool newPasswordHide = true;

  bool validatorLengthNewPassword = true;
  bool validatorMatchNewPassword = true;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: "Change Password",
          elevation: 0,
          color: mainColor,
          textColor: whiteColor,
          leadingColor: whiteColor,
        ),
      ),
      backgroundColor: mainColor,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Old password:",
                    style: normalText.copyWith(
                      color: blackColor,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(30),
                      vertical: ScreenUtil().setHeight(10),
                    ),
                    child: TextField(
                      obscureText: oldPasswordHide,
                      controller: oldPasswordController,
                      decoration: const InputDecoration(
                        hintText: "Type your old password here!",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New password:",
                    style: normalText.copyWith(
                      color: blackColor,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(30),
                      vertical: ScreenUtil().setHeight(10),
                    ),
                    child: TextField(
                      obscureText: newPasswordHide,
                      controller: newPasswordController,
                      decoration: const InputDecoration(
                        hintText: "Type your new password here!",
                      ),
                      onChanged: (value) {
                        if (value.length < 8) {
                          setState(() {
                            validatorLengthNewPassword = false;
                          });
                        } else {
                          setState(() {
                            validatorLengthNewPassword = true;
                          });
                        }
                      },
                    ),
                  ),
                  validatorLengthNewPassword
                      ? const SizedBox.shrink()
                      : Text(
                          "The password must be 8-character or more!",
                          style: tinyText.copyWith(
                            color: Colors.red,
                          ),
                        ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Confirm the new password:",
                    style: normalText.copyWith(
                      color: blackColor,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(30),
                      vertical: ScreenUtil().setHeight(10),
                    ),
                    child: TextField(
                      obscureText: newPasswordHide,
                      controller: confirmController,
                      decoration: const InputDecoration(
                        hintText: "Re-type your new password here!",
                      ),
                      onChanged: (value) {
                        if (value != newPasswordController.text) {
                          setState(() {
                            validatorMatchNewPassword = false;
                          });
                        } else {
                          setState(() {
                            validatorMatchNewPassword = true;
                          });
                        }
                      },
                    ),
                  ),
                  validatorMatchNewPassword
                      ? const SizedBox.shrink()
                      : Text(
                          "It's not match with New Password!",
                          style: tinyText.copyWith(
                            color: Colors.red,
                          ),
                        )
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            BlocListener<ChangePasswordBloc, ChangePasswordState>(
              listener: (context, state) {
                if (state is ChangePasswordFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.error,
                      ),
                    ),
                  );
                } else if (state is ChangePasswordSuccess) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return dialog(
                        "Change Password is Success!",
                        "Your new password has been store to database!",
                        () {
                          context.pushReplacementNamed(
                            AppRoute.userSettingScreen.name,
                          );
                        },
                      );
                    },
                  );
                }
              },
              child: MainButton(
                onTap: () {
                  if (oldPasswordController.text == oldPassword) {
                    if (newPasswordController.text.isNotEmpty) {
                      if (newPasswordController.text ==
                          confirmController.text) {
                        context.read<ChangePasswordBloc>().add(
                              ChangePasswordStart(
                                newPasswordController.text,
                              ),
                            );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return dialog(
                              "Your confirm password did't match",
                              "Check your confirm password, it's different with your new password!",
                              () {
                                context.pop();
                              },
                            );
                          },
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return dialog(
                            "Fill your new password",
                            "Please fill your new password!",
                            () {
                              context.pop();
                            },
                          );
                        },
                      );
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return dialog(
                          "Old Password is False!",
                          "Check your Old Password!",
                          () {
                            context.pop();
                          },
                        );
                      },
                    );
                  }
                },
                text: "Submit",
                color: whiteColor,
                textColor: mainColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  AlertDialog dialog(
    String title,
    String content,
    Function() onOk,
  ) {
    return AlertDialog(
      title: Text(
        title,
        style: bigTextSemibold,
      ),
      content: Text(
        content,
        style: normalText,
      ),
      actions: [
        InkWell(
          onTap: onOk,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.2, vertical: 5.h),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(10.h),
            ),
            child: const Text("Ok"),
          ),
        )
      ],
    );
  }
}
