import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/core/widget/dropdown_button_date.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/get_all_present/get_present_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/get_holiday/get_holiday_bloc.dart';

class PresentCollectedScreen extends StatefulWidget {
  const PresentCollectedScreen({super.key});

  @override
  State<PresentCollectedScreen> createState() => _PresentCollectedScreenState();
}

class _PresentCollectedScreenState extends State<PresentCollectedScreen> {
  int? selectedMonth;
  int? selectedYear;

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
  List indexMonth = List.generate(12, (index) => index);

  List year = List.generate(10, (index) => DateTime.now().year - index);
  List indexYear = List.generate(10, (index) => index);

  List<DateTime>? dates = [];

  @override
  void initState() {
    selectedMonth = DateTime.now().month - 1;
    selectedYear = indexYear.first;
    getDate(DateTime.now().year, DateTime.now().month);
    context.read<HolidayBloc>().add(
          GetHoliday(
            DateTime.now().year,
            DateTime.now().month,
          ),
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
          SizedBox(
            height: 25.h,
          ),
          BlocConsumer<HolidayBloc, HolidayState>(
            listener: (context, state) {
              if (state is HolidaySuccess) {
                List<DateTime>? holidays = [];
                for (var day in state.holidays) {
                  final newDate = DateTime(
                    year[selectedYear!],
                    selectedMonth! + 1,
                    day,
                    0,
                  );
                  holidays.add(newDate);
                }
                if (holidays.isNotEmpty) {
                  setState(
                    () {
                      dates = dates!
                          .where(
                            (element) => !holidays.contains(element),
                          )
                          .toList();
                    },
                  );
                }
              }
            },
            builder: (context, state) {
              if (state is HolidayLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                );
              } else if (state is HolidayError) {
                return Center(
                  child: Text(state.message),
                );
              } else if (state is HolidaySuccess) {
                return SingleChildScrollView(
                  child: dataTable(
                    dates!,
                  ),
                );
              }
              return const Center(
                child: Text('No data available'),
              );
            },
          ),
        ],
      ),
    );
  }

  DataTable dataTable(List<DateTime> dates) {
    return DataTable(
      columnSpacing: 10.w,
      columns: [
        DataColumn(
          label: Text(
            'No.',
            style: normalText,
          ),
        ),
        DataColumn(
          label: Text(
            'Tanggal',
            style: normalText,
          ),
        ),
        DataColumn(
          label: Text(
            'Aksi',
            style: normalText,
          ),
        ),
      ],
      rows: List.generate(
        dates.length,
        (index) {
          final data = dates[index];
          final format = DateFormat('EEEE, dd-MM-yyyy');
          final date = format.format(data);
          return DataRow(
            cells: [
              DataCell(
                Text(
                  '${index + 1}',
                  style: tinyText,
                ),
              ),
              DataCell(
                Text(
                  date,
                  style: tinyText,
                ),
              ),
              DataCell(
                Padding(
                  padding: EdgeInsets.all(10.w),
                  child: MainButton(
                    onTap: () {},
                    text: 'Detail',
                    width: 150.w,
                  ),
                ),
              ),
            ],
          );
        },
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
}
