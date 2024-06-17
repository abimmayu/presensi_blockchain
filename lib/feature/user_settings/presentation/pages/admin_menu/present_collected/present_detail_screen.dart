import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/core/widget/dropdown_button_date.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_result.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/get_all_present/get_present_bloc.dart';

class PresentDetailScreen extends StatefulWidget {
  const PresentDetailScreen({super.key});

  @override
  State<PresentDetailScreen> createState() => _PresentDetailScreenState();
}

class _PresentDetailScreenState extends State<PresentDetailScreen> {
  int? selectedMonth;
  int? selectedYear;
  int _currentIndex = 0;

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
  List indexYear = List.generate(10, (index) => index);

  List? nameOfEmployee = [];

  List<DateTime>? dates = [];

  @override
  void initState() {
    selectedMonth = DateTime.now().month - 1;
    selectedYear = indexYear.first;
    getDate(DateTime.now().year, DateTime.now().month);
    context.read<AllPresentBloc>().add(
          AllPresentGet(),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'Present Collected',
          leadingOnPressed: () {
            context.pop();
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 50.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownDateWidget(
                value: selectedMonth!,
                dateOption: indexMonth,
                dateTitle: month,
                onSelected: (value) {
                  onSelectedMonth(
                    value,
                  );
                  context.read<AllPresentBloc>().add(
                        AllPresentGet(),
                      );
                  getDate(year[selectedYear!], value + 1);
                },
              ),
              SizedBox(
                width: 20.w,
              ),
              DropdownDateWidget(
                value: selectedYear!,
                dateOption: indexYear,
                dateTitle: year,
                onSelected: (value) {
                  onSelectedYear(
                    value,
                  );
                  context.read<AllPresentBloc>().add(
                        AllPresentGet(),
                      );
                  getDate(year[value], selectedMonth! + 1);
                },
              ),
            ],
          ),
          // SizedBox(
          //   height: 50.h,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     MainButton(
          //       onTap: () {
          //         changeIndex(0);
          //         context.read<AllPresentBloc>().add(
          //               AllPresentGet(),
          //             );
          //       },
          //       text: 'Masuk',
          //       width: 150.w,
          //       color: _currentIndex == 1 ? greyColor : mainColor,
          //     ),
          //     SizedBox(
          //       width: 20.w,
          //     ),
          //     MainButton(
          //       onTap: () {
          //         changeIndex(1);
          //         context.read<AllPresentBloc>().add(
          //               AllPresentGet(),
          //             );
          //       },
          //       text: 'Pulang',
          //       width: 150.w,
          //       color: _currentIndex == 0 ? greyColor : mainColor,
          //     ),
          //   ],
          // ),
          SizedBox(
            height: 25.h,
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: 50.w,
          //   ),
          //   child: MainButton(
          //     onTap: () {
          //       getExcludeDate(
          //           context, year[selectedYear!], selectedMonth! + 1);
          //     },
          //     text: 'Get Exclude Date',
          //   ),
          // ),
          BlocConsumer<AllPresentBloc, AllPresentState>(
            listener: (context, state) async {
              if (state is AllPresentSuccess) {
                final uniqueDatas = <String, PresentResult>{};
                state.presents.where(
                  (element) {
                    final timeStamp = int.parse(element.timeStamp);
                    final startOfMonth =
                        DateTime(year[selectedYear!], selectedMonth! + 1, 1, 0)
                                .millisecondsSinceEpoch /
                            1000;
                    final startOfNextMonth =
                        DateTime(year[selectedYear!], selectedMonth! + 2, 1, 0)
                                .millisecondsSinceEpoch /
                            1000;
                    if (timeStamp >= startOfMonth &&
                        timeStamp < startOfNextMonth) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                ).forEach((element) {
                  uniqueDatas[element.from] = element;
                });
                final realDatas = uniqueDatas.values.toList();
                final List<Map<String, dynamic>> dataName = [];
                for (var i = 0; i < realDatas.length; i++) {
                  final finalData =
                      await searchDataByField('address', realDatas[i].from);
                  log('finalData: $finalData');
                  dataName.add(finalData);
                  log('$dataName');
                }
                setState(() {
                  nameOfEmployee = dataName;
                });
              }
            },
            builder: (context, state) {
              if (state is AllPresentError) {
                return Center(
                  child: Text(state.error),
                );
              } else if (state is AllPresentSuccess) {
                return SingleChildScrollView(
                  // padding: EdgeInsets.symmetric(horizontal: 20.w),
                  // scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 10.w,
                    showBottomBorder: true,
                    columns: const [
                      DataColumn(
                        label: Text('No.'),
                      ),
                      DataColumn(
                        label: Text('Tanggal'),
                      ),
                      DataColumn(
                        label: Text('Action'),
                      ),
                    ],
                    rows: List.generate(
                      dates!.length,
                      (index) {
                        final format = DateFormat('EEEE, dd-MM-yyyy');
                        final dateTime = dates?[index];
                        final date = format.format(dateTime!);
                        return DataRow(
                          cells: [
                            DataCell(
                              Text('${index + 1}'),
                            ),
                            DataCell(
                              Text(
                                date,
                              ),
                            ),
                            DataCell(
                              Padding(
                                padding: EdgeInsets.all(10.h),
                                child: MainButton(
                                  onTap: () {
                                    setState(() {
                                      dates?.removeAt(index);
                                    });
                                  },
                                  text: 'Hapus',
                                  color: Colors.red,
                                  width: 130.w,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: mainColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  onSelectedMonth(value) {
    setState(() {
      selectedMonth = value;
    });
  }

  onSelectedYear(value) {
    setState(() {
      selectedYear = value;
    });
  }

  getDate(int year, int month) {
    final startMonth = DateTime(year, month, 1, 0);
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

  Future<void> getExcludeDate(BuildContext context, int year, int month) async {
    final startDate = DateTime(year, month, 1, 0);
    final endDate = startDate.add(
      const Duration(days: 30),
    );
    final List<DateTime>? picked = await showDialog<List<DateTime>>(
      context: context,
      builder: (context) {
        List<DateTime> excludeDate = [];
        return AlertDialog(
          content: SizedBox(
            height: 400.h,
            child: DayPicker.multi(
              selectedDates: excludeDate,
              onChanged: (selectedDate) {
                excludeDate = selectedDate;
                log('excludeDate: $excludeDate');
              },
              firstDate: startDate,
              lastDate: endDate,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(excludeDate);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    ).then(
      (value) {
        log('picked: $value');
        if (value != null && value.isNotEmpty) {
          setState(
            () {
              dates = dates
                  ?.where(
                    (element) => !value.contains(element),
                  )
                  .toList();
            },
          );
          log('dates: $dates');
        }
        return null;
      },
    );
  }

  changeIndex(value) {
    setState(() {
      _currentIndex = value;
    });
  }

  Future<Map<String, dynamic>> searchDataByField(
      String fieldName, dynamic value) async {
    // Referensikan koleksi dan query berdasarkan field dan nilai
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('User') // Ganti dengan nama koleksi Anda
        .where('address', isEqualTo: value)
        .get();
    Map<String, dynamic> data =
        querySnapshot.docs[0].data() as Map<String, dynamic>;
    log('data: $data');
    return data;
  }
}
