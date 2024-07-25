import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/core/widget/dropdown_button_date.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_result.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/get_all_present/get_present_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/get_holiday/get_holiday_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/present_time/present_time_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/pages/admin_menu/present_collected/present_detail_screen.dart';

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

  List<Map<String, List<PresentResult>>> transactionInList = [];
  List<Map<String, List<PresentResult>>> transactionOutList = [];

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

  TimeOfDay? presentStart;
  TimeOfDay? presentEnd;

  TimeOfDay? homePresentStart;
  TimeOfDay? homePresentEnd;

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
      body: RefreshIndicator(
        onRefresh: () async {
          log("year: ${year[selectedYear!]}, month: ${selectedMonth! + 1}");
          return context.read<AllPresentBloc>().add(
                AllPresentGet(
                  selectedMonth! + 1,
                  year[selectedYear!],
                ),
              );
        },
        child: ListView(
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
                    // context.read<AllPresentBloc>().add(
                    //       AllPresentGet(
                    //         value + 1,
                    //         year[selectedYear!],
                    //       ),
                    //     );
                    context.read<HolidayBloc>().add(
                          GetHoliday(
                            year[selectedYear!],
                            value + 1,
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
                    // context.read<AllPresentBloc>().add(
                    //       AllPresentGet(
                    //         selectedMonth! + 1,
                    //         year[value],
                    //       ),
                    //     );
                    context.read<HolidayBloc>().add(
                          GetHoliday(
                            year[value],
                            selectedMonth! + 1,
                          ),
                        );
                    getDate(year[value], selectedMonth! + 1);
                  },
                ),
                BlocBuilder<AllPresentBloc, AllPresentState>(
                  builder: (context, state) {
                    if (state is AllPresentSuccess) {
                      if (transactionInList.isEmpty) {
                        return IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.sim_card_download,
                            color: greyColor,
                            size: 60.h,
                          ),
                        );
                      }
                      return IconButton(
                        onPressed: () async {
                          await requestStoragePermission();
                          try {
                            OpenResult result = await generateLargeTablesPdf(
                              year[selectedYear!],
                              selectedMonth! + 1,
                              month[selectedMonth!],
                              transactionInList,
                              transactionOutList,
                            );

                            if (result.type == ResultType.done) {
                              // File PDF telah dibuka
                              print('File PDF berhasil dibuka');
                            } else {
                              // Penanganan kasus lain jika diperlukan
                              print(result.type);
                              print('Gagal membuka file PDF');
                            }
                          } catch (e) {
                            // Penanganan exception jika terjadi kesalahan
                            print(
                                'Terjadi kesalahan saat membuka file PDF: $e');
                          }
                        },
                        icon: Icon(
                          Icons.sim_card_download,
                          color: mainColor,
                          size: 60.h,
                        ),
                      );
                    } else if (state is AllPresentLoading) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: greyColor,
                          ),
                        ),
                      );
                    }
                    return IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.sim_card_download,
                        color: greyColor,
                        size: 60.h,
                      ),
                    );
                  },
                )
              ],
            ),
            SizedBox(
              height: 25.h,
            ),
            BlocListener<PresentTimeBloc, PresentTimeState>(
              listener: (context, state) {
                if (state is PresentTimeSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (timeStamp) {
                      setState(
                        () {
                          presentStart = TimeOfDay(
                            hour: state.presentTime.getIn.start.hour,
                            minute: state.presentTime.getIn.start.minute,
                          );
                          presentEnd = TimeOfDay(
                            hour: state.presentTime.getIn.end.hour,
                            minute: state.presentTime.getIn.end.minute,
                          );
                          homePresentStart = TimeOfDay(
                            hour: state.presentTime.getOut.start.hour,
                            minute: state.presentTime.getOut.start.minute,
                          );
                          homePresentEnd = TimeOfDay(
                            hour: state.presentTime.getOut.end.hour,
                            minute: state.presentTime.getOut.end.minute,
                          );
                        },
                      );
                    },
                  );
                  context.read<AllPresentBloc>().add(
                        AllPresentGet(
                          selectedMonth! + 1,
                          year[selectedYear!],
                        ),
                      );
                }
              },
              child: BlocListener<AllPresentBloc, AllPresentState>(
                listener: (context, state) async {
                  log("State All present: $state");
                  if (state is AllPresentSuccess) {
                    log("State Present: ${state.presents[0]}");
                    if (state.presents.isNotEmpty) {
                      await _fetchData(state.presents);
                    }
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
            ),
          ],
        ),
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
                          getInStart: presentStart!,
                          getInEnd: presentEnd!,
                          getOutStart: homePresentStart!,
                          getOutEnd: homePresentEnd!,
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

  Future<void> _fetchData(List<PresentResult> transactions) async {
    final days = generateDatesInMonth(
      year[selectedYear!],
      selectedMonth! + 1,
    );

    List<PresentResult> presentTransactions = [];
    List<PresentResult> homePresentTransactions = [];

    log("Days in month: $days");

    for (var day in days) {
      final startPresent = DateTime(
        year[selectedYear!],
        selectedMonth! + 1,
        day.day,
        presentStart!.hour,
        presentStart!.minute,
      ).millisecondsSinceEpoch;
      final endPresent = DateTime(
        year[selectedYear!],
        selectedMonth! + 1,
        day.day,
        presentEnd!.hour,
        presentEnd!.minute,
      ).millisecondsSinceEpoch;

      final startHomePresent = DateTime(
        year[selectedYear!],
        selectedMonth! + 1,
        day.day,
        homePresentStart!.hour,
        homePresentStart!.minute,
      ).millisecondsSinceEpoch;
      final endHomePresent = DateTime(
        year[selectedYear!],
        selectedMonth! + 1,
        day.day,
        homePresentEnd!.hour,
        homePresentEnd!.minute,
      ).millisecondsSinceEpoch;

      log("Processing day: ${day.day}");
      log("Present start: $startPresent, Present end: $endPresent");
      log("Home present start: $startHomePresent, Home present end: $endHomePresent");

      List<PresentResult> tempPresentTransactions =
          transactions.where((element) {
        int timeStamp = int.parse(element.timeStamp) * 1000;
        log("Checking timestamp: $timeStamp");
        return timeStamp >= startPresent && timeStamp < endPresent;
      }).toList();

      List<PresentResult> tempHomePresentTransactions =
          transactions.where((element) {
        int timeStamp = int.parse(element.timeStamp) * 1000;
        return timeStamp >= startHomePresent && timeStamp < endHomePresent;
      }).toList();

      log("Found ${tempPresentTransactions.length} present transactions for day ${day.day}");
      log("Found ${tempHomePresentTransactions.length} home present transactions for day ${day.day}");

      presentTransactions.addAll(tempPresentTransactions);
      homePresentTransactions.addAll(tempHomePresentTransactions);
    }

    log("Total present transactions: ${presentTransactions.length}");
    log("Total home present transactions: ${homePresentTransactions.length}");

    await sortingTheTransaction(presentTransactions, homePresentTransactions);
  }

  Future<void> sortingTheTransaction(
    List<PresentResult> presentTransactions,
    List<PresentResult> homePresentTransactions,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, List<PresentResult>> transactionInMap = {};
    Map<String, List<PresentResult>> transactionOutMap = {};

    Map<String, List<PresentResult>> addressToPresentTransactions = {};
    Map<String, List<PresentResult>> addressToHomePresentTransactions = {};

    for (var transaction in presentTransactions) {
      addressToPresentTransactions
          .putIfAbsent(transaction.from, () => [])
          .add(transaction);
    }

    for (var transaction in homePresentTransactions) {
      addressToHomePresentTransactions
          .putIfAbsent(transaction.from, () => [])
          .add(transaction);
    }

    for (var address in addressToPresentTransactions.keys) {
      QuerySnapshot userDoc = await firestore
          .collection('User')
          .where('address', isEqualTo: address)
          .get();

      if (userDoc.docs.isNotEmpty) {
        String userName = userDoc.docs.first.get('name');
        if (transactionInMap.containsKey(userName)) {
          transactionInMap[userName]!
              .addAll(addressToPresentTransactions[address]!);
        } else {
          transactionInMap[userName] = addressToPresentTransactions[address]!;
        }
      }
    }

    for (var address in addressToHomePresentTransactions.keys) {
      QuerySnapshot userDoc = await firestore
          .collection('User')
          .where('address', isEqualTo: address)
          .get();

      if (userDoc.docs.isNotEmpty) {
        String userName = userDoc.docs.first.get('name');
        if (transactionOutMap.containsKey(userName)) {
          transactionOutMap[userName]!.addAll(
            addressToHomePresentTransactions[address]!,
          );
        } else {
          transactionOutMap[userName] =
              addressToHomePresentTransactions[address]!;
        }
      }
    }

    for (var userName in transactionInMap.keys) {
      transactionInMap[userName]!.sort(
        (a, b) => int.parse(
          a.timeStamp,
        ).compareTo(
          int.parse(
            b.timeStamp,
          ),
        ),
      );
    }

    for (var userName in transactionOutMap.keys) {
      transactionOutMap[userName]!.sort(
        (a, b) => int.parse(
          a.timeStamp,
        ).compareTo(
          int.parse(
            b.timeStamp,
          ),
        ),
      );
    }

    setState(() {
      transactionInList = transactionInMap.entries
          .map(
            (e) => {
              e.key: e.value,
            },
          )
          .toList();
      transactionOutList = transactionOutMap.entries
          .map(
            (e) => {
              e.key: e.value,
            },
          )
          .toList();
    });

    log("Transaction In List: $transactionInList");
    log("Transaction Out List: $transactionOutList");
  }

  Future<OpenResult> generateLargeTablesPdf(
    int year,
    int month,
    String monthTitle,
    List employeePresent,
    List employeePresentHome,
    // PdfPageFormat format,
  ) async {
    final pdf = pw.Document();

    final assetFont = await rootBundle.load('assets/DejaVuSans.ttf');

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
    final presentEmployee = transactionInList.asMap().entries.expand(
      (e) {
        final index = e.key;
        final dataTable = e.value.entries.map(
          (e) {
            final name = e.key;
            final List<PresentResult> presentDays = e.value;
            final List<int> timeStamp = List.generate(
              presentDays.length,
              (index) {
                final timeStamp =
                    int.parse(presentDays[index].timeStamp) * 1000;
                final DateTime time = DateTime.fromMillisecondsSinceEpoch(
                  timeStamp,
                );
                final day = time.day;

                return day;
              },
            );
            log("Time Stamp Presensi: $timeStamp");
            final List<dynamic> row = [index + 1, name];

            for (var day in days) {
              if (timeStamp.contains(day.day)) {
                row.add('✓');
              } else {
                row.add('');
              }
            }

            // for (var day = days.first.day; day <= days.last.day; day++) {
            //   if (presentDays.contains(day)) {
            //     row.add('✓');
            //   } else {
            //     row.add('');
            //   }
            // }

            row.add(presentDays.length);
            return row;
          },
        ).toList();
        return dataTable;
      },
    ).toList();

    final homePresentEmployee = transactionOutList.asMap().entries.expand(
      (e) {
        final index = e.key;
        final dataTable = e.value.entries.map(
          (e) {
            final name = e.key;
            final List presentDays = e.value;
            final List<dynamic> row = [index + 1, name];

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
    final output = await getApplicationSupportDirectory();
    final file = File('${output.path}/Rekapan Presensi $monthTitle $year.pdf');
    final byte = await pdf.save();
    await file.writeAsBytes(byte);

    log("Fungsi PDF Sudah sampai disini...");

    return OpenFile.open(file.path);
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

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // Meminta izin akses storage jika belum diberikan
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      // Izin diberikan, lanjutkan dengan operasi yang membutuhkan izin
      // Misalnya, menyimpan atau membuka file PDF
    } else {
      // Izin tidak diberikan, beritahu pengguna atau lakukan penanganan lainnya
      // Misalnya, menampilkan pesan bahwa izin diperlukan untuk operasi tertentu
    }
  }
}
