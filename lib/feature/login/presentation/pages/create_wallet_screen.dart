import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/user/user_bloc.dart';
import 'package:svg_flutter/svg_flutter.dart';

class CreateWalletScreen extends StatefulWidget {
  const CreateWalletScreen({
    super.key,
  });

  @override
  State<CreateWalletScreen> createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  TextEditingController controller = TextEditingController();
  String id = FirebaseAuth.instance.currentUser!.uid;
  SecureStorage storage = SecureStorage();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthWalletSuccess) {
            context.read<UserBloc>().add(
                  PostPublicKey(
                    id,
                    {
                      "address": state.wallet.privateKey.address.hex,
                      "public_key": true,
                    },
                    context.pushReplacementNamed(AppRoute.presentScreen.name),
                  ),
                );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You doesn't have a wallet!",
                style: bigTextSemibold,
              ),
              const Text(
                "Create your Own Wallet first! The wallet will use to input a present data.",
              ),
              SizedBox(
                height: 50.h,
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
                        SizedBox(
                          width: ScreenUtil().setWidth(250),
                          child: TextField(
                            obscureText: true,
                            controller: controller,
                            decoration: const InputDecoration.collapsed(
                              hintText: "Type your password",
                            ),
                            maxLength: 6,
                            keyboardType: TextInputType.phone,
                            autocorrect: false,
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
              MainButton(
                text: "Create Wallet",
                onTap: () {
                  context.read<AuthBloc>().add(
                        AuthCreateWallet(
                          pin: controller.text,
                        ),
                      );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
