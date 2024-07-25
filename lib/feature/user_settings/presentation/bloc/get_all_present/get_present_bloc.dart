import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_result.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/usecase/all_present_usecase.dart';

part 'get_present_event.dart';
part 'get_present_state.dart';

class AllPresentBloc extends Bloc<AllPresentEvent, AllPresentState> {
  AllPresentUsecase allPresentUsecase;
  AllPresentBloc(
    this.allPresentUsecase,
  ) : super(
          AllPresentLoading(),
        ) {
    on<AllPresentGet>(
      (event, emit) async {
        return await getAllPresent(
          event.month,
          event.year,
          emit,
        );
      },
    );
  }

  Future<void> getAllPresent(
    int month,
    int year,
    Emitter<AllPresentState> emit,
  ) async {
    emit(
      AllPresentLoading(),
    );

    final result = await allPresentUsecase.execute();

    result.fold(
      (l) => emit(AllPresentError(l.message!)),
      (r) {
        final startTimeStamp = getStartOfMonthTimestamp(year, month);
        final lastTimeStamp = getEndOfMonthTimestamp(year, month);
        List<PresentResult> presentOnMonth = r.where(
          (element) {
            log("Sedang menyeleksi presensi...");
            final timeStamp = int.parse(element.timeStamp);
            return timeStamp >= startTimeStamp && timeStamp <= lastTimeStamp;
          },
        ).toList();
        emit(
          AllPresentSuccess(presentOnMonth),
        );
      },
    );
  }

  int getStartOfMonthTimestamp(int year, int month) {
    return DateTime(year, month, 1).millisecondsSinceEpoch ~/ 1000;
  }

  int getEndOfMonthTimestamp(int year, int month) {
    int lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, lastDay, 23, 59, 59).millisecondsSinceEpoch ~/
        1000;
  }
}
