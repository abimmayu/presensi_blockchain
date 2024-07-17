import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_time.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_time_detail.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/present_time/present_time_bloc.dart';

class ChangePresentTimeScreen extends StatefulWidget {
  const ChangePresentTimeScreen({super.key});

  @override
  State<ChangePresentTimeScreen> createState() =>
      _ChangePresentTimeScreenState();
}

class _ChangePresentTimeScreenState extends State<ChangePresentTimeScreen> {
  @override
  void initState() {
    context.read<PresentTimeBloc>().add(
          GetPresentTime(),
        );
    super.initState();
  }

  TimeOfDay? presentTimeStart;
  TimeOfDay? presentTimeEnd;

  TimeOfDay? presentTimeHomeStart;
  TimeOfDay? presentTimeHomeEnd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: "Present Time"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: BlocConsumer<PresentTimeBloc, PresentTimeState>(
          listener: (context, state) {
            if (state is PresentTimeSuccess) {
              WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) {
                  setState(
                    () {
                      presentTimeStart = TimeOfDay(
                        hour: state.presentTime.getIn.start.hour,
                        minute: state.presentTime.getIn.start.minute,
                      );
                      presentTimeEnd = TimeOfDay(
                        hour: state.presentTime.getIn.end.hour,
                        minute: state.presentTime.getIn.end.minute,
                      );
                      presentTimeHomeStart = TimeOfDay(
                        hour: state.presentTime.getOut.start.hour,
                        minute: state.presentTime.getOut.start.minute,
                      );
                      presentTimeHomeEnd = TimeOfDay(
                        hour: state.presentTime.getOut.end.hour,
                        minute: state.presentTime.getOut.end.minute,
                      );
                    },
                  );
                },
              );
            }
            if (state is PresentTimeEditSuccess) {
              context.read<PresentTimeBloc>().add(
                    GetPresentTime(),
                  );
            }
          },
          builder: (context, state) {
            log("Present Time State saat ini: $state");
            if (state is PresentTimeSuccess) {
              if (presentTimeStart == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  presentWidget(
                    TimeOfDay(
                      hour: presentTimeStart!.hour,
                      minute: presentTimeStart!.minute,
                    ),
                    TimeOfDay(
                      hour: presentTimeEnd!.hour,
                      minute: presentTimeEnd!.minute,
                    ),
                    'Presensi Masuk',
                    (value) => setState(
                      () {
                        presentTimeStart = value;
                      },
                    ),
                    (value) => setState(
                      () {
                        presentTimeEnd = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  presentWidget(
                    TimeOfDay(
                      hour: presentTimeHomeStart!.hour,
                      minute: presentTimeHomeStart!.minute,
                    ),
                    TimeOfDay(
                      hour: presentTimeHomeEnd!.hour,
                      minute: presentTimeHomeEnd!.minute,
                    ),
                    'Pulang',
                    (value) => setState(
                      () {
                        presentTimeHomeStart = value;
                      },
                    ),
                    (value) => setState(
                      () {
                        presentTimeHomeEnd = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                  MainButton(
                    onTap: () => context.read<PresentTimeBloc>().add(
                          UpdatePresentTime(
                            PresentTime(
                              start: PresentTimeDetail(
                                hour: presentTimeStart!.hour,
                                minute: presentTimeStart!.minute,
                              ),
                              end: PresentTimeDetail(
                                hour: presentTimeEnd!.hour,
                                minute: presentTimeEnd!.minute,
                              ),
                            ),
                            PresentTime(
                              start: PresentTimeDetail(
                                hour: presentTimeHomeStart!.hour,
                                minute: presentTimeHomeStart!.minute,
                              ),
                              end: PresentTimeDetail(
                                hour: presentTimeHomeEnd!.hour,
                                minute: presentTimeHomeEnd!.minute,
                              ),
                            ),
                          ),
                        ),
                    text: "Submit",
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: mainColor,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget presentWidget(
    TimeOfDay start,
    TimeOfDay end,
    String title,
    ValueSetter<TimeOfDay> onTapStart,
    ValueSetter<TimeOfDay> onTapEnd,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 150.w,
          child: Text(
            title,
            style: normalText,
          ),
        ),
        Text(
          "=",
          style: normalText,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
          ),
          child: Row(
            children: [
              TextButton(
                onPressed: () => selectTime(
                  context,
                  start,
                  onTapStart,
                ),
                child: Text(
                  start.format(context),
                  style: normalText.copyWith(
                    color: mainColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Text(
                  "-",
                  style: normalText,
                ),
              ),
              TextButton(
                onPressed: () => selectTime(
                  context,
                  end,
                  onTapEnd,
                ),
                child: Text(
                  end.format(context),
                  style: normalText.copyWith(
                    color: mainColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> selectTime(
    BuildContext context,
    TimeOfDay? initialTime,
    ValueSetter<TimeOfDay> onTimeSelected,
  ) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime!,
    );

    if (picked != null) {
      onTimeSelected(picked);
    }
  }
}
