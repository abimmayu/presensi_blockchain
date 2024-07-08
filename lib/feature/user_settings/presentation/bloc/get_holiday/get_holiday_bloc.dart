import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/usecase/get_holiday_usecase.dart';

part 'get_holiday_event.dart';
part 'get_holiday_state.dart';

class HolidayBloc extends Bloc<HolidayEvent, HolidayState> {
  final GetHolidayUsecase getHolidayUsecase;

  HolidayBloc(this.getHolidayUsecase)
      : super(
          HolidayInitial(),
        ) {
    on<GetHoliday>(
      (event, emit) async {
        return await getHoliday(
          event.year,
          event.month,
          emit,
        );
      },
    );
  }

  Future<void> getHoliday(
    int year,
    int month,
    Emitter<HolidayState> emit,
  ) async {
    emit(
      HolidayLoading(),
    );

    final result = await getHolidayUsecase.execute(year, month);

    result.fold(
      (l) => emit(HolidayError(l.message!)),
      (r) {
        if (r.exists) {
          emit(
            HolidaySuccess(r['days'] as List),
          );
        } else {
          emit(
            HolidaySuccess(
              const [],
            ),
          );
        }
      },
    );
  }
}
