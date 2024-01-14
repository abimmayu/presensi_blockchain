import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/constant.dart';
import 'package:presensi_blockchain/core/widget/custom_nav_bar.dart';
import 'package:presensi_blockchain/feature/dashboard/domain/present_in_year.dart';
import 'package:presensi_blockchain/feature/dashboard/presentation/present_charts.dart';
import 'package:svg_flutter/svg.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int? selectedMonth;
  int? selectedYear;
  int? selectedYear2;
  final int _currentIndex = 0;

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

  List<PresentinYear> data = [
    PresentinYear(
      month: 2017,
      present: 40000,
      barColor: charts.ColorUtil.fromDartColor(mainColor),
    ),
    PresentinYear(
      month: 2018,
      present: 5000,
      barColor: charts.ColorUtil.fromDartColor(mainColor),
    ),
    PresentinYear(
      month: 2019,
      present: 40000,
      barColor: charts.ColorUtil.fromDartColor(mainColor),
    ),
    PresentinYear(
      month: 2020,
      present: 35000,
      barColor: charts.ColorUtil.fromDartColor(mainColor),
    ),
    PresentinYear(
      month: 2021,
      present: 45000,
      barColor: charts.ColorUtil.fromDartColor(mainColor),
    ),
    PresentinYear(
      month: 2020,
      present: 35000,
      barColor: charts.ColorUtil.fromDartColor(mainColor),
    ),
    PresentinYear(
      month: 2016,
      present: 40000,
      barColor: charts.ColorUtil.fromDartColor(mainColor),
    ),
    PresentinYear(
      month: 2015,
      present: 5000,
      barColor: charts.ColorUtil.fromDartColor(mainColor),
    ),
    PresentinYear(
      month: 2014,
      present: 40000,
      barColor: charts.ColorUtil.fromDartColor(mainColor),
    ),
    PresentinYear(
      month: 2013,
      present: 35000,
      barColor: charts.ColorUtil.fromDartColor(mainColor),
    ),
    PresentinYear(
      month: 2012,
      present: 45000,
      barColor: charts.ColorUtil.fromDartColor(mainColor),
    ),
    PresentinYear(
      month: 2011,
      present: 35000,
      barColor: charts.ColorUtil.fromDartColor(mainColor),
    ),
  ];

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

  void selectYear2(int value) {
    setState(
      () {
        selectedYear2 = value;
      },
    );
  }

  @override
  void initState() {
    selectMonth(
      DateTime.now().month - 1,
    );
    selectYear(
      DateTime.now().year,
    );
    selectYear2(
      DateTime.now().year,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavBar(
        currentIndex: 0,
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: [
                Container(
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
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: whiteColor,
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                        'https://d1bpj0tv6vfxyp.cloudfront.net/alasan-orang-yang-sibuk-kerja-harus-olahraga-ringan-teratur-halodoc.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: ScreenUtil().setHeight(80),
                                  width: ScreenUtil().setHeight(80),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(10),
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          'Abim Mayu Indra Ardiansyah',
                                          style: bigTextSemibold.copyWith(
                                            color: whiteColor,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          '198503302003121002',
                                          style: tinyText,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/Location.svg',
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(7),
                                ),
                                Text(
                                  'Fakultas MIPA, Universitas Tanjungpura',
                                  style: tinyText,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/Group.svg',
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(7),
                                ),
                                Text(
                                  'Staff ahli TIK MIPA Untan',
                                  style: tinyText,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                        value: selectedMonth,
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
                            value!,
                          );
                          print(
                            value.toString(),
                          );
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
                          print(
                            value.toString(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hadir",
                          style: bigTextSemibold,
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: mainColor,
                          ),
                          child: Text(
                            "24",
                            style: headingBold.copyWith(
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(30),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Absen",
                          style: bigTextSemibold,
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: mainColor,
                          ),
                          child: Text(
                            "24",
                            style: headingBold.copyWith(
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                Text(
                  "Izin/Cuti perbulan",
                  style: bigTextRegular,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
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
                    value: selectedYear2,
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
                      selectYear2(
                        value!,
                      );
                      print(
                        value.toString(),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                PresentChart(
                  data: data,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
