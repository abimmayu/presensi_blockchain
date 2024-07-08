import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/core/widget/dropdown_button_date.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_result.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/get_all_present/get_present_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/get_holiday/get_holiday_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/admin_menu/present_collected/present_detail_screen.dart';
import 'package:printing/printing.dart';

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

  List employeePresent = [];
  List employeeHomePresent = [];

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
    context.read<AllPresentBloc>().add(
          AllPresentGet(
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
                  log("bulan nya: ${value + 1}, tahun nya: ${year[selectedYear!]}");
                  context.read<AllPresentBloc>().add(
                        AllPresentGet(
                          value + 1,
                          year[selectedYear!],
                        ),
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
                  log("bulan nya: ${selectedMonth! + 1}, tahun nya: ${year[value]}");
                  context.read<AllPresentBloc>().add(
                        AllPresentGet(
                          selectedMonth! + 1,
                          year[value],
                        ),
                      );
                  getDate(year[value], selectedMonth! + 1);
                },
              ),
              IconButton(
                onPressed: () async {
                  Printing.layoutPdf(
                    onLayout: (format) => generateLargeTablesPdf(
                      year[selectedYear!],
                      selectedMonth! + 1,
                      month[selectedMonth!],
                      employeePresent,
                      employeeHomePresent,
                      format,
                    ),
                  );
                },
                icon: Icon(
                  Icons.sim_card_download,
                  color: mainColor,
                  size: 60.h,
                ),
              )
            ],
          ),
          SizedBox(
            height: 25.h,
          ),
          BlocListener<AllPresentBloc, AllPresentState>(
            listener: (context, state) async {
              if (state is AllPresentSuccess) {
                final uniqueDatasPresent = <String, PresentResult>{};
                final uniqueDatasHomePresent = <String, PresentResult>{};
                final startPresent =
                    DateTime(year[selectedYear!], selectedMonth! + 1, 1, 8, 0)
                            .millisecondsSinceEpoch /
                        1000;
                final endPresent =
                    DateTime(year[selectedYear!], selectedMonth! + 2, 8, 30)
                            .millisecondsSinceEpoch /
                        1000;
                final startHomePresent =
                    DateTime(year[selectedYear!], selectedMonth! + 1, 1, 15, 30)
                            .millisecondsSinceEpoch /
                        1000;
                final endHomePresent =
                    DateTime(year[selectedYear!], selectedMonth! + 2, 0, 16, 0)
                            .millisecondsSinceEpoch /
                        1000;
                state.presents.where(
                  (element) {
                    final timeStamp = int.parse(element.timeStamp);

                    if (timeStamp >= startPresent && timeStamp < endPresent) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                ).forEach(
                  (element) {
                    uniqueDatasHomePresent[element.from] = element;
                  },
                );
                state.presents.where(
                  (element) {
                    final timeStamp = int.parse(element.timeStamp);
                    if (timeStamp >= startHomePresent &&
                        timeStamp < endHomePresent) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                ).forEach(
                  (element) {
                    uniqueDatasPresent[element.from] = element;
                  },
                );
                final realDatasPresent = uniqueDatasPresent.values.toList();
                final realDatasHomePresent =
                    uniqueDatasHomePresent.values.toList();
                final List<Map<String, dynamic>> dataNamePresent = [];
                final List<Map<String, dynamic>> dataNameHomePresent = [];
                for (var i = 0; i < realDatasPresent.length; i++) {
                  final finalData = await searchDataByField(
                    realDatasPresent[i].from,
                  );
                  dataNamePresent.add(finalData);
                }
                for (var i = 0; i < realDatasHomePresent.length; i++) {
                  final finalData = await searchDataByField(
                    realDatasHomePresent[i].from,
                  );
                  dataNameHomePresent.add(finalData);
                }
                setState(
                  () {
                    employeePresent = dataNamePresent;
                    employeeHomePresent = dataNameHomePresent;
                  },
                );
              }
            },
            child: BlocConsumer<HolidayBloc, HolidayState>(
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
          final format = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
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
                    onTap: () {
                      context.pushNamed(
                        AppRoute.presentDetailScreen.name,
                        extra: PresentDetailParam(
                          dateTime: data,
                        ),
                      );
                    },
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

  Future<Map<String, dynamic>> searchDataByField(
    dynamic value,
  ) async {
    log("value: $value");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('address', isEqualTo: value)
        .get();
    log("querySnapshot: ${querySnapshot.docs}");
    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          querySnapshot.docs[0].data() as Map<String, dynamic>;
      log('data: $data');
      return data;
    }
    return {
      "name": value,
    };
  }

  Future<Uint8List> generateLargeTablesPdf(
    int year,
    int month,
    String monthTitle,
    List employeePresent,
    List employeePresentHome,
    PdfPageFormat format,
  ) async {
    final pdf = pw.Document();

    final assetFont = await rootBundle.load('assets/times.ttf');

    final font = pw.Font.ttf(assetFont);

    final fontStyle = pw.TextStyle(
      font: font,
      fontSize: 10,
      color: PdfColors.black,
    );

    final header = [
      'No',
      'Nama',
    ];

    final days = generateDatesInMonth(year, month);

    for (var day in days) {
      header.add("${day.day}");
    }
    header.add("Total Kehadiran");
    final presentEmployee = employeePresent.map(
      (e) {
        final dataTable = (e as Map<String, dynamic>).entries.map(
          (e) {
            final name = e.key;
            final List presentDays = e.value;
            final List<dynamic> row = [name];

            for (var day = days.first.day; day <= days.last.day; day++) {
              if (presentDays.contains(day)) {
                row.add('✓');
              } else {
                row.add('');
              }
            }

            row.add(presentDays.length);
            return row;
          },
        ).toList();
        return dataTable;
      },
    ).toList();

    final homePresentEmployee = employeeHomePresent.map(
      (e) {
        final dataTable = (e as Map<String, dynamic>).entries.map(
          (e) {
            final name = e.key;
            final List presentDays = e.value;
            final List<dynamic> row = [name];

            for (var day = days.first.day; day <= days.last.day; day++) {
              if (presentDays.contains(day)) {
                row.add('✓');
              } else {
                row.add('');
              }
            }
            row.add(presentDays.length);
            return row;
          },
        ).toList();
        return dataTable;
      },
    ).toList();

    pdf.addPage(
      pw.MultiPage(
        orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                'Rekapan Presensi Masuk',
                style: pw.TextStyle(
                  font: font,
                ),
              ),
            ),
            pw.Center(
              child: pw.Text(
                '$monthTitle $year',
                style: pw.TextStyle(
                  font: font,
                ),
              ),
            ),
            pw.Center(
              child: pw.Text(
                'FMIPA Untan',
                style: pw.TextStyle(
                  font: font,
                ),
              ),
            ),
            pw.SizedBox(height: 20.h),
            pw.TableHelper.fromTextArray(
              headers: header,
              data: presentEmployee,
              headerStyle: fontStyle,
              cellStyle: fontStyle,
            ),
          ];
        },
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        orientation: pw.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                'Rekapan Presensi Masuk',
                style: pw.TextStyle(
                  font: font,
                ),
              ),
            ),
            pw.Center(
              child: pw.Text(
                '$monthTitle $year',
                style: pw.TextStyle(
                  font: font,
                ),
              ),
            ),
            pw.Center(
              child: pw.Text(
                'FMIPA Untan',
                style: pw.TextStyle(
                  font: font,
                ),
              ),
            ),
            pw.SizedBox(height: 20.h),
            pw.TableHelper.fromTextArray(
              headers: header,
              headerStyle: fontStyle,
              data: homePresentEmployee,
              cellStyle: fontStyle,
            ),
          ];
        },
      ),
    );
    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/Rekapan Presensi $monthTitle $year.pdf');
    final byte = await pdf.save();
    await file.writeAsBytes(byte);

    return pdf.save();
  }

  List<DateTime> generateDatesInMonth(int year, int month) {
    List<DateTime> dates = [];

    // Mendapatkan jumlah hari dalam bulan
    int daysInMonth = DateTime(year, month + 1, 0).day;

    // Menghasilkan daftar tanggal dari hari pertama hingga hari terakhir
    for (int day = 1; day <= daysInMonth; day++) {
      dates.add(DateTime(year, month, day));
    }

    return dates;
  }
}
