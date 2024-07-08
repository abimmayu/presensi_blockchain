import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/data/models/present_time_model.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_time.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/usecase/get_present_time_usecase.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/usecase/update_present_time_usecase.dart';

part 'present_time_event.dart';
part 'present_time_state.dart';

class PresentTimeBloc extends Bloc<PresentTimeEvent, PresentTimeState> {
  final GetPresentTimeUsecase getPresentTimeUsecase;
  final UpdatePresentTimeUsecase updatePresentTimeUsecase;

  PresentTimeBloc(this.getPresentTimeUsecase, this.updatePresentTimeUsecase)
      : super(
          PresentTimeLoading(),
        ) {
    on<GetPresentTime>(
      (event, emit) async {
        return await getPresentTime(emit);
      },
    );
    on<UpdatePresentTime>(
      (event, emit) async {
        return await updatePresentTime(
          event.getIn,
          event.getOut,
          emit,
        );
      },
    );
  }

  Future<void> getPresentTime(
    Emitter<PresentTimeState> emit,
  ) async {
    emit(
      PresentTimeLoading(),
    );
    final result = await getPresentTimeUsecase.execute();

    result.fold(
      (l) => emit(
        PresentTimeError(
          l.message!,
        ),
      ),
      (r) {
        emit(
          PresentTimeSuccess(r),
        );
      },
    );
  }

  Future<void> updatePresentTime(
    PresentTime getIn,
    PresentTime getOut,
    Emitter<PresentTimeState> emit,
  ) async {
    emit(
      PresentTimeLoading(),
    );
    final result = await updatePresentTimeUsecase.execute(getIn, getOut);

    result.fold(
      (l) => emit(
        PresentTimeError(l.message!),
      ),
      (r) {
        emit(
          PresentTimeEditSuccess(),
        );
      },
    );
  }
}
