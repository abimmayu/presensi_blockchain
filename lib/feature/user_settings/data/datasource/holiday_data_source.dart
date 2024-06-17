import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presensi_blockchain/core/service/firebase_firestore.dart';

abstract class HolidayDataSource {
  Future<DocumentSnapshot> getHoliday(int year, int month);
}

class HolidayDataSourceImpl implements HolidayDataSource {
  FireStore fireStore = FireStore();

  @override
  Future<DocumentSnapshot> getHoliday(int year, int month) async {
    final String yearInWord = '$year';
    final List<String> monthInWord = [
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
    final doc = '${monthInWord[month - 1]} $yearInWord';
    log(doc);
    final result = await fireStore.getData(
      doc: doc,
      collection: 'Hari Libur',
    );
    return result;
  }
}
