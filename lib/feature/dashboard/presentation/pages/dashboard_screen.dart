import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/feature/dashboard/presentation/bloc/home_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_result.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/get_holiday/get_holiday_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/present_time/present_time_bloc.dart';

class DashboardParam {
  final String name;
  final int nip;
  final String occupation;
  final String address;

  DashboardParam({
    required this.name,
    required this.nip,
    required this.occupation,
    required this.address,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.param,
  });
  final DashboardParam param;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int? selectedMonth;
  int? selectedYear;
  int? selectedYear2;
  // final int _currentIndex = 0;

  TimeOfDay? startPresentTime;
  TimeOfDay? endPresentTime;
  TimeOfDay? startHomePresent;
  TimeOfDay? endHomePresent;

  List<Map<int, PresentResult>> presentInMap = [];
  List<Map<int, PresentResult>> presentOutMap = [];

  List month = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];

  List year = List.generate(10, (index) => DateTime.now().year - index);

  List indexMonth = List.generate(12, (index) => index);

  void selectMonth(int value) {
    setState(
      () {
        selectedMonth = value;
      },
    );
  }

  void selectYear(int value) {
    setState(
      () {
        selectedYear = value;
      },
    );
  }

  List<DateTime> dates = [];

  @override
  void initState() {
    selectMonth(
      DateTime.now().month,
    );
    selectYear(
      DateTime.now().year,
    );
    getDate(DateTime.now().year, DateTime.now().month);
    context.read<HolidayBloc>().add(
          GetHoliday(
            DateTime.now().year,
            DateTime.now().month,
          ),
        );
    context.read<HomeBloc>().add(
          GetPresentInMonth(
            DateTime.now().month,
            DateTime.now().year,
            widget.param.address,
          ),
        );
    super.initState();
  }

  getDate(int year, int month) {
    final startNextMonth = DateTime(year, month + 1, 0);
    setState(
      () {
        dates = List.generate(
          startNextMonth.day,
          (index) => DateTime(year, month, index + 1),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<PresentTimeBloc, PresentTimeState>(
          listener: (context, state) {
            if (state is PresentTimeSuccess) {
              WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) {
                  setState(
                    () {
                      startPresentTime = TimeOfDay(
                        hour: state.presentTime.getIn.start.hour,
                        minute: state.presentTime.getIn.start.minute,
                      );
                      endPresentTime = TimeOfDay(
                        hour: state.presentTime.getIn.end.hour,
                        minute: state.presentTime.getIn.end.minute,
                      );
                      startHomePresent = TimeOfDay(
                        hour: state.presentTime.getOut.start.hour,
                        minute: state.presentTime.getOut.start.minute,
                      );
                      endHomePresent = TimeOfDay(
                        hour: state.presentTime.getOut.end.hour,
                        minute: state.presentTime.getOut.end.minute,
                      );
                    },
                  );
                },
              );
            }
          },
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  headerWidget(
                    widget.param.name,
                    widget.param.nip,
                    widget.param.occupation,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: blackColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<int>(
                          value: selectedMonth! - 1,
                          items: indexMonth.map(
                            (e) {
                              return DropdownMenuItem<int>(
                                value: e,
                                child: Text(
                                  month[e],
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            selectMonth(
                              value! + 1,
                            );
                            context.read<HolidayBloc>().add(
                                  GetHoliday(
                                    selectedYear!,
                                    value + 1,
                                  ),
                                );
                            getDate(selectedYear!, value + 1);
                          },
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(50),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: blackColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<int>(
                          value: selectedYear,
                          items: year.map(
                            (e) {
                              return DropdownMenuItem<int>(
                                value: e,
                                child: Text(
                                  "$e",
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            selectYear(
                              value!,
                            );
                            getDate(value, selectedMonth!);
                            context.read<HolidayBloc>().add(
                                  GetHoliday(
                                    value,
                                    selectedMonth!,
                                  ),
                                );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  BlocListener<HomeBloc, HomeState>(
                    listener: (context, state) {
                      if (state is HomeLoaded) {
                        convertPresentDataToMap(
                          state.presentInMonth,
                        );
                      }
                    },
                    child: BlocConsumer<HolidayBloc, HolidayState>(
                      listener: (context, state) {
                        if (state is HolidaySuccess) {
                          context.read<PresentTimeBloc>().add(
                                GetPresentTime(),
                              );
                          List<DateTime>? holidays = [];
                          for (var day in state.holidays) {
                            final newDate = DateTime(
                              selectedYear!,
                              selectedMonth! + 1,
                              day,
                              0,
                            );
                            holidays.add(newDate);
                          }
                          if (holidays.isNotEmpty) {
                            setState(
                              () {
                                dates = dates
                                    .where(
                                      (element) => !holidays.contains(element),
                                    )
                                    .toList();
                                log("Dates: $dates");
                              },
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        if (state is HolidaySuccess) {
                          // log("Dates Pada Builder: $dates");
                          return SingleChildScrollView(
                            child: dataTable(
                              dates,
                              presentInMap,
                              presentOutMap,
                            ),
                          );
                        } else if (state is HolidayError) {
                          return Center(
                            child: Text(state.message),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataTable dataTable(
    List<DateTime> dates,
    List<Map<int, PresentResult>> presentInMap,
    List<Map<int, PresentResult>> presentOutMap,
  ) {
    return DataTable(
      columnSpacing: 10.w,
      columns: [
        DataColumn(
          label: Text(
            'Tanggal',
            style: normalText,
          ),
        ),
        DataColumn(
          label: Text(
            'Masuk',
            style: normalText,
          ),
        ),
        DataColumn(
          label: Text(
            'Pulang',
            style: normalText,
          ),
        ),
      ],
      rows: List.generate(
        dates.length,
        (index) {
          final data = dates[index];
          final tanggal = data.day;
          final nowPresentIn = presentInMap
              .where((element) => element.containsKey(tanggal))
              .toList();
          final nowPresentOut = presentOutMap
              .where((element) => element.containsKey(tanggal))
              .toList();
          // log("Present In: $presentInMap, Present Out: $presentOutMap");
          final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
          final timeFormat = DateFormat('HH:mm', 'id_ID');
          final date = dateFormat.format(data);
          return DataRow(
            cells: [
              DataCell(
                Text(
                  date,
                  style: tinyText,
                ),
              ),
              DataCell(
                Text(
                  nowPresentIn.isEmpty
                      ? '-'
                      : "${nowPresentIn.map(
                          (e) {
                            final int timeStamp =
                                int.parse(e.values.first.timeStamp) * 1000;
                            final DateTime time =
                                DateTime.fromMillisecondsSinceEpoch(
                              timeStamp,
                            );
                            final String date = timeFormat.format(time);
                            return date;
                          },
                        ).join(', ')} WIB",
                  style: tinyText,
                ),
              ),
              DataCell(
                Text(
                  nowPresentOut.isEmpty
                      ? '-'
                      : "${nowPresentOut.map((e) {
                          final int timeStamp =
                              int.parse(e.values.first.timeStamp) * 1000;
                          final DateTime time =
                              DateTime.fromMillisecondsSinceEpoch(
                            timeStamp,
                          );
                          final String date = timeFormat.format(time);
                          return date;
                        }).join(', ')} WIB",
                  style: tinyText,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  convertPresentDataToMap(List<PresentResult> inputData) {
    List<Map<int, PresentResult>> presentInData = [];
    List<Map<int, PresentResult>> presentOutData = [];

    for (var item in inputData) {
      // log("Input Data: ${item.timeStamp}");
      int timeStamp = int.parse(item.timeStamp) * 1000;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
      int tanggal = dateTime.day;

      int presentTimeStart = DateTime(
        selectedYear!,
        selectedMonth!,
        tanggal,
        startPresentTime!.hour,
        startPresentTime!.minute,
      ).millisecondsSinceEpoch;
      int presentTimeEnd = DateTime(
        selectedYear!,
        selectedMonth!,
        tanggal,
        endPresentTime!.hour,
        endPresentTime!.minute,
      ).millisecondsSinceEpoch;

      int homePresentStart = DateTime(
        selectedYear!,
        selectedMonth!,
        tanggal,
        startHomePresent!.hour,
        startHomePresent!.minute,
      ).millisecondsSinceEpoch;
      int homePresentEnd = DateTime(
        selectedYear!,
        selectedMonth!,
        tanggal,
        endHomePresent!.hour,
        endHomePresent!.minute,
      ).millisecondsSinceEpoch;
      // log("Present Time Start: $presentTimeStart, Present Time End: $presentTimeEnd");

      if (timeStamp > presentTimeStart && timeStamp < presentTimeEnd) {
        presentInData.add(
          {
            tanggal: item,
          },
        );
      } else if (timeStamp > homePresentStart && timeStamp < homePresentEnd) {
        presentOutData.add(
          {
            tanggal: item,
          },
        );
      }
    }
    // log("Present In Data: $presentInData, Present Out Data: $presentOutData");

    setState(() {
      presentInMap = presentInData;
      presentOutMap = presentOutData;
    });
  }
}

Widget headerWidget(String name, int nip, String occupation) {
  return Container(
    decoration: BoxDecoration(
      color: mainColor,
      border: Border.all(
        color: whiteColor,
        width: 6,
        strokeAlign: BorderSide.strokeAlignInside,
      ),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 4),
          blurRadius: 0.4,
          color: blackColor.withOpacity(0.25),
        ),
      ],
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(0),
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: ScreenUtil().setWidth(10),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Text(
                            name,
                            style: bigTextSemibold.copyWith(
                              color: whiteColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            "$nip",
                            style: normalText.copyWith(
                              color: whiteColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            occupation,
                            style: normalText.copyWith(
                              color: whiteColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
