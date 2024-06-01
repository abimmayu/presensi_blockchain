import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:svg_flutter/svg.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({
    super.key,
  });

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        log(state.toString());
        if (state is AuthSuccess) {
          context.pushReplacementNamed(AppRoute.checkWalletScreen.name);
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
                      } else if (state is AuthLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: mainColor,
                          ),
                        );
                      } else if (state is AuthError) {
                        return Text(
                          state.message,
                        );
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
    );
  }
}
