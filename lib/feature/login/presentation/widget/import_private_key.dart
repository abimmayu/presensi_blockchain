import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/pin_modal.dart';
import 'package:presensi_blockchain/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:svg_flutter/svg.dart';

class ImportPrivateKeyWidget extends StatefulWidget {
  const ImportPrivateKeyWidget({super.key});

  @override
  State<ImportPrivateKeyWidget> createState() => _ImportPrivateKeyWidgetState();
}

class _ImportPrivateKeyWidgetState extends State<ImportPrivateKeyWidget> {
  String? password;

  TextEditingController privateKeyController = TextEditingController();

  @override
  void dispose() {
    privateKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30.h),
          height: 300.h,
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(20.w),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 30.w,
          ),
          child: Column(
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),
              SizedBox(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/Password logo.svg',
                          height: 30.h,
                          color: whiteColor,
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        SizedBox(
                          width: 250.w,
                          child: TextField(
                            style: normalText.copyWith(
                              color: whiteColor,
                            ),
                            controller: privateKeyController,
                            maxLines: 3,
                            maxLength: 128,
                            cursorColor: whiteColor,
                            obscureText: false,
                            decoration: InputDecoration.collapsed(
                              focusColor: whiteColor,
                              hintText: "Input Private Key",
                              hintStyle: normalText.copyWith(
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                      ),
                    );
                  } else if (state is AuthWalletSuccess) {
                    context.pushReplacementNamed(AppRoute.presentScreen.name);
                  }
                },
                child: MainButton(
                  text: "Submit",
                  color: whiteColor,
                  textColor: mainColor,
                  onTap: () {
                    modalInputPin(context);
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }

  modalInputPin(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return PinInputModal(
          controller: controller,
          onChanged: (value) {
            setState(() {
              controller.text = value;
            });
          },
          onSubmitted: (value) {
            context.pop();
            context.read<AuthBloc>().add(
                  AuthImportWallet(
                    value,
                    privateKeyController.text,
                    null,
                  ),
                );
          },
          function: () {
            context.pop();
            context.read<AuthBloc>().add(
                  AuthImportWallet(
                    controller.text,
                    privateKeyController.text,
                    null,
                  ),
                );
          },
        );
      },
    );
  }
}
