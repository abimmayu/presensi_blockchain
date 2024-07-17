import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_result.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/repository/all_present_repository.dart';

part "home_event.dart";
part "home_state.dart";

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AllPresentRepository allPresentRepository;

  HomeBloc(
    this.allPresentRepository,
  ) : super(
          HomeLoading(),
        ) {
    on<GetPresentInMonth>(
      (event, emit) async {
        await getPresentInMonth(
          event.month,
          event.year,
          event.address,
          emit,
        );
      },
    );
  }

  Future<void> getPresentInMonth(
    int month,
    int year,
    String address,
    Emitter<HomeState> emit,
  ) async {
    emit(
      HomeLoading(),
    );
    final result = await allPresentRepository.getAllPresent();
    result.fold(
      (l) => emit(
        HomeError(l.message!),
      ),
      (r) {
        final startTimeStamp = getStartOfMonthTimestamp(year, month);
        final lastTimeStamp = getEndOfMonthTimestamp(year, month);
        List<PresentResult> presentUser = r.where(
          (element) {
            final timeStamp = int.parse(element.timeStamp);
            return timeStamp >= startTimeStamp &&
                timeStamp <= lastTimeStamp &&
                element.from == address;
          },
        ).toList();
        emit(
          HomeLoaded(
            presentUser,
          ),
        );
      },
    );
  }

  double getStartOfMonthTimestamp(int year, int month) {
    return DateTime(year, month, 1).millisecondsSinceEpoch / 1000;
  }

  double getEndOfMonthTimestamp(int year, int month) {
    int lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, lastDay, 23, 59, 59).millisecondsSinceEpoch /
        1000;
  }
}
