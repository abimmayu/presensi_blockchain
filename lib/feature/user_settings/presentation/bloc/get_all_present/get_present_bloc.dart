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
        return await getAllPresent(emit);
      },
    );
  }

  Future<void> getAllPresent(
    Emitter<AllPresentState> emit,
  ) async {
    emit(
      AllPresentLoading(),
    );

    final result = await allPresentUsecase.execute();

    result.fold(
      (l) => emit(AllPresentError(l.message!)),
      (r) => emit(
        AllPresentSuccess(r),
      ),
    );
  }
}
