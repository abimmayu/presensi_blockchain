import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/widget/text_field_widget.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nipController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  String? selectedItem;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  late String userEmail;
  late String userPassword;

  @override
  void initState() {
    getUserCredential();
    super.initState();
  }

  getUserCredential() async {
    final storage = SecureStorage();
    final email = await storage.readData(key: AppConstant.userEmail);
    final password = await storage.readData(key: AppConstant.userPassword);
    setState(() {
      userEmail = email.toString();
      userPassword = password.toString();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: "Add Account",
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
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),
              body(),
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                      ),
                    );
                  } else if (state is AuthRegisterSuccess) {
                    final id = FirebaseAuth.instance.currentUser!.uid;
                    context.read<AuthBloc>().add(
                          AuthRegisterUser(
                            state.user.uid,
                            {
                              "device_id": null,
                              "id": id,
                              "name": nameController.text,
                              "nip": int.parse(nipController.text),
                              "occupation": occupationController.text,
                              "public_key": false,
                              "role": selectedItem,
                            },
                          ),
                        );
                  } else if (state is AuthAddUserSuccess) {
                    log("Menjalankan logout...");
                    context.read<AuthBloc>().add(
                          AuthLogout(
                            AuthSignout(),
                          ),
                        );
                  } else if (state is AuthSignout) {
                    log("login kembali...");
                    context.read<AuthBloc>().add(
                          AuthLogin(userEmail, userPassword),
                        );
                  } else if (state is AuthSuccess) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "You're Data has been saved!",
                            style: bigTextSemibold,
                          ),
                          content: Text(
                            "The Employee's data success to be save!.",
                            style: tinyText,
                          ),
                          actions: [
                            InkWell(
                              onTap: () {
                                context.pop();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.h, horizontal: 20.h),
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(10.h),
                                ),
                                child: const Text("Ok"),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                builder: (context, state) {
                  return MainButton(
                    onTap: () {
                      context.read<AuthBloc>().add(
                            AuthSignUp(
                              emailController.text,
                              passwordController.text,
                            ),
                          );
                    },
                    text: "Submit",
                    color: whiteColor,
                    textColor: mainColor,
                  );
                },
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldWidget(
          title: "Full Name:",
          hintText: "Enter employee's full name",
          controller: nameController,
        ),
        TextFieldWidget(
          title: "NIP",
          hintText: "Enter employee's NIP",
          controller: nipController,
        ),
        TextFieldWidget(
          title: "Occupation:",
          hintText: "Enter employee's occupation",
          controller: occupationController,
        ),
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Role:",
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
                child: DropdownButton(
                  hint: const Text("Choose the role"),
                  items: const [
                    DropdownMenuItem(
                      value: "admin",
                      child: Text("Admin"),
                    ),
                    DropdownMenuItem(
                      value: "employee",
                      child: Text("Employee"),
                    ),
                  ],
                  value: selectedItem,
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        TextFieldWidget(
          title: "E-mail:",
          hintText: "Enter employee's full name",
          controller: emailController,
        ),
        TextFieldWidget(
          title: "Password",
          hintText: "Enter employee's NIP",
          obsecure: true,
          controller: passwordController,
        ),
        TextFieldWidget(
          title: "Confirm Password:",
          hintText: "Enter employee's occupation",
          obsecure: true,
          controller: confirmPasswordController,
        ),
      ],
    );
  }
}
