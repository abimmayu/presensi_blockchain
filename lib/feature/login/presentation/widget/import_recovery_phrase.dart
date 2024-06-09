import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/pin_modal.dart';
import 'package:presensi_blockchain/feature/login/presentation/bloc/auth_bloc.dart';

class ImportRecoveryPhraseWidget extends StatefulWidget {
  const ImportRecoveryPhraseWidget({super.key});

  @override
  State<ImportRecoveryPhraseWidget> createState() =>
      _ImportRecoveryPhraseWidgetState();
}

class _ImportRecoveryPhraseWidgetState
    extends State<ImportRecoveryPhraseWidget> {
  final int phraseLength = 12;

  late List<TextEditingController> controllers;
  late List<FocusNode> focusNode;

  @override
  void initState() {
    controllers = List.generate(
      phraseLength,
      (index) => TextEditingController(),
    );
    focusNode = List.generate(
      phraseLength,
      (index) => FocusNode(),
    );
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
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
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            Container(
              height: 250.h,
              padding: EdgeInsets.only(bottom: 10.h),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 20.h,
                  mainAxisExtent: 40.h,
                ),
                itemCount: phraseLength,
                itemBuilder: (context, index) {
                  return TextField(
                    focusNode: focusNode[index],
                    controller: controllers[index],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                      labelText: 'Word ${index + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (index < 11) {
                        FocusScope.of(context).requestFocus(
                          focusNode[index + 1],
                        );
                      }
                    },
                    onChanged: (value) {
                      Future.delayed(
                        const Duration(seconds: 1),
                        () {
                          if (value.length > 3) {
                            onPaste(value, index, controllers);
                          }
                          if (value.endsWith(" ")) {
                            // controllers[index].text = value;
                            if (index < 11) {
                              FocusScope.of(context).requestFocus(
                                focusNode[index + 1],
                              );
                            }
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
            MainButton(
              onTap: () {
                modalSeePrivateKey(context);
              },
              text: "Submit",
            ),
          ],
        ),
      ),
    );
  }

  onPaste(String string, int index, List<TextEditingController> controllers) {
    final List<String> value = string.split(' ');
    log(value.toString());
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].text = value[i];
    }
  }

  modalSeePrivateKey(BuildContext context) {
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
          function: () {
            context.pop();
            context.read<AuthBloc>().add(
                  AuthImportWallet(
                    controller.text,
                    null,
                    controllers,
                  ),
                );
          },
        );
      },
    );
  }
}
