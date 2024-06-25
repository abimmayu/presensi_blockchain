import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

class PresentDetailParam {
  final DateTime dateTime;
  PresentDetailParam({required this.dateTime});
}

class PresentDetailScreen extends StatefulWidget {
  const PresentDetailScreen({super.key, required this.param});

  final PresentDetailParam param;

  @override
  State<PresentDetailScreen> createState() => _PresentDetailScreenState();
}

class _PresentDetailScreenState extends State<PresentDetailScreen> {
  int _currentIndex = 0;

  List employee = [];

  @override
  void initState() {
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
          title: 'Present Detail',
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
              MainButton(
                onTap: () {
                  changeIndex(0);
                  context.read<AllPresentBloc>().add(
                        AllPresentGet(),
                      );
                },
                text: 'Masuk',
                width: 150.w,
                color: _currentIndex == 1 ? greyColor : mainColor,
              ),
              SizedBox(
                width: 20.w,
              ),
              MainButton(
                onTap: () {
                  changeIndex(1);
                  context.read<AllPresentBloc>().add(
                        AllPresentGet(),
                      );
                },
                text: 'Pulang',
                width: 150.w,
                color: _currentIndex == 0 ? greyColor : mainColor,
              ),
            ],
          ),
          SizedBox(
            height: 25.h,
          ),
          Center(
            child: Text(
              DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(
                widget.param.dateTime,
              ),
              style: bigTextSemibold,
            ),
          ),
          SizedBox(
            height: 25.h,
          ),
          BlocConsumer<AllPresentBloc, AllPresentState>(
            listener: (context, state) async {
              if (state is AllPresentSuccess) {
                final date = widget.param.dateTime;
                final uniqueDatas = <String, PresentResult>{};
                state.presents.where(
                  (element) {
                    final timeStamp = int.parse(element.timeStamp);
                    final start = _currentIndex == 0
                        ? DateTime(date.year, date.month, date.day, 8, 0)
                                .millisecondsSinceEpoch /
                            1000
                        : DateTime(date.year, date.month, date.day, 15, 30)
                                .millisecondsSinceEpoch /
                            1000;
                    final end = _currentIndex == 0
                        ? DateTime(date.year, date.month, date.day, 8, 30)
                                .millisecondsSinceEpoch /
                            1000
                        : DateTime(date.year, date.month, date.day, 16, 0)
                                .millisecondsSinceEpoch /
                            1000;
                    if (timeStamp >= start && timeStamp < end) {
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
                  final finalData = await searchDataByField(
                    realDatas[i].from,
                  );
                  dataName.add(finalData);
                }
                setState(() {
                  employee = dataName;
                });
              }
            },
            builder: (context, state) {
              if (state is AllPresentError) {
                return Center(
                  child: Text(state.error),
                );
              } else if (state is AllPresentSuccess) {
                if (employee.isNotEmpty) {
                  return SingleChildScrollView(
                    child: DataTable(
                      columnSpacing: 10.w,
                      showBottomBorder: true,
                      columns: [
                        DataColumn(
                          label: Text(
                            'No.',
                            style: normalText.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Nama',
                            style: normalText.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Waktu',
                            style: normalText.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      rows: List.generate(
                        employee.length,
                        (index) {
                          final format = DateFormat('HH:mm');
                          final data = employee[index];
                          final timeStamp =
                              int.parse(state.presents[index].timeStamp);
                          final date = format.format(
                            DateTime.fromMillisecondsSinceEpoch(
                                timeStamp * 1000),
                          );
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
                                  data['name'],
                                  style: tinyText,
                                ),
                              ),
                              DataCell(
                                Text(
                                  '$date WIB',
                                  style: tinyText,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                }
                return Center(
                  child: Text(
                    'No Present Data',
                    style: bigTextRegular,
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

  changeIndex(value) {
    setState(() {
      _currentIndex = value;
    });
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
}
