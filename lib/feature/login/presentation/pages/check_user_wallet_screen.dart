import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/user_bloc.dart';

class IntializeUser extends StatefulWidget {
  const IntializeUser({super.key});

  @override
  State<IntializeUser> createState() => _IntializeUserState();
}

class _IntializeUserState extends State<IntializeUser> {
  final id = FirebaseAuth.instance.currentUser!.uid;
  String? privateKey;

  @override
  void initState() {
    context.read<UserBloc>().add(
          GetUserData(id),
        );
    log(id);
    getPrivateKey();
    super.initState();
  }

  getPrivateKey() async {
    privateKey = await SecureStorage().readData(key: AppConstant.privateKey);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          if (state.user["public_key"] as bool) {
            if (privateKey == null) {
              context.pushReplacementNamed(AppRoute.importWalletScreen.name);
            } else {
              context.pushReplacementNamed(AppRoute.presentScreen.name);
            }
          } else {
            context.pushReplacementNamed(AppRoute.createWalletScreen.name);
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: mainColor,
              ),
              SizedBox(
                height: 50.h,
              ),
              Text(
                "Your account is initializing",
                style: normalText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
