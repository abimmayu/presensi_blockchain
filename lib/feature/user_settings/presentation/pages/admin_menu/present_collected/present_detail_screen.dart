import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_result.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/get_all_present/get_present_bloc.dart';

class PresentDetailParam {
  final DateTime dateTime;
  final TimeOfDay getInStart;
  final TimeOfDay getInEnd;
  final TimeOfDay getOutStart;
  final TimeOfDay getOutEnd;
  PresentDetailParam({
    required this.dateTime,
    required this.getInStart,
    required this.getInEnd,
    required this.getOutStart,
    required this.getOutEnd,
  });
}

class PresentDetailScreen extends StatefulWidget {
  const PresentDetailScreen({super.key, required this.param});

  final PresentDetailParam param;

  @override
  State<PresentDetailScreen> createState() => _PresentDetailScreenState();
}

class _PresentDetailScreenState extends State<PresentDetailScreen> {
  int _currentIndex = 0;

  List<Map<String, List<PresentResult>>> transactionList = [];

  @override
  void initState() {
    context.read<AllPresentBloc>().add(
          AllPresentGet(
            widget.param.dateTime.month,
            widget.param.dateTime.year,
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("DateTime: ${widget.param.dateTime}");
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
                        AllPresentGet(
                          widget.param.dateTime.month,
                          widget.param.dateTime.year,
                        ),
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
                        AllPresentGet(
                          widget.param.dateTime.month,
                          widget.param.dateTime.year,
                        ),
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
                _fetchData(
                  state.presents,
                  _currentIndex,
                );
              }
            },
            builder: (context, state) {
              if (state is AllPresentError) {
                return Center(
                  child: Text(state.error),
                );
              } else if (state is AllPresentSuccess) {
                if (transactionList.isNotEmpty) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
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
                          transactionList.length,
                          (index) {
                            final format = DateFormat('HH:mm');
                            final data = transactionList[index];
                            final key = data.keys.first;
                            List<PresentResult> presentResult = data[key]!;
                            final timeStamp = int.parse(
                              presentResult.first.timeStamp,
                            );
                            log("All Data: ${state.presents}");
                            final date = format.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                timeStamp * 1000,
                              ),
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
                                  SizedBox(
                                    width: 200.w,
                                    child: Text(
                                      transactionList[index].keys.first,
                                      style: tinyText,
                                    ),
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

  Future<void> _fetchData(
    List<PresentResult> transactions,
    int index,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DateTime date = widget.param.dateTime;
    Map<String, List<PresentResult>> transactionMap = {};
    int presentStart = DateTime(
      date.year,
      date.month,
      date.day,
      widget.param.getInStart.hour,
      widget.param.getInStart.minute,
    ).millisecondsSinceEpoch;
    int presentEnd = DateTime(
      date.year,
      date.month,
      date.day,
      widget.param.getInEnd.hour,
      widget.param.getInEnd.minute,
    ).millisecondsSinceEpoch;
    int homePresentStart = DateTime(
      date.year,
      date.month,
      date.day,
      widget.param.getOutStart.hour,
      widget.param.getOutStart.minute,
    ).millisecondsSinceEpoch;
    int homePresentEnd = DateTime(
      date.year,
      date.month,
      date.day,
      widget.param.getOutEnd.hour,
      widget.param.getOutEnd.minute,
    ).millisecondsSinceEpoch;

    List<PresentResult> presentTransactions = [];
    if (index == 0) {
      presentTransactions = transactions.where(
        (element) {
          int timeStamp = int.parse(element.timeStamp) * 1000;
          if (timeStamp >= presentStart && timeStamp < presentEnd) {
            return true;
          }
          return false;
        },
      ).toList();
    } else {
      presentTransactions = transactions.where(
        (element) {
          int timeStamp = int.parse(element.timeStamp) * 1000;
          if (timeStamp >= homePresentStart && timeStamp < homePresentEnd) {
            return true;
          }
          return false;
        },
      ).toList();
    }
    for (var transaction in presentTransactions) {
      String fromAddress = transaction.from;

      QuerySnapshot userDoc = await firestore
          .collection('User')
          .where(
            'address',
            isEqualTo: fromAddress,
          )
          .get();

      String userName = fromAddress; // Default to address if user not found
      if (userDoc.docs.isNotEmpty) {
        userName = userDoc.docs.first.get('name');
      }

      if (transactionMap.containsKey(userName)) {
        if (int.parse(transaction.timeStamp) <
            int.parse(transactionMap[userName]!.first.timeStamp)) {
          transactionMap[userName] = [transaction];
        }
      } else {
        transactionMap[userName] = [transaction];
      }
    }
    setState(() {
      transactionList =
          transactionMap.entries.map((e) => {e.key: e.value}).toList();
      log("transaction List: $transactionList");
    });
  }
}
