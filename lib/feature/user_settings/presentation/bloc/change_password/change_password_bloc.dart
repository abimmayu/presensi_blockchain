import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/usecase/change_password_usecase.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordUsecase changePasswordUsecase;

  ChangePasswordBloc(
    this.changePasswordUsecase,
  ) : super(
          ChangePasswordLoading(),
        ) {
    on<ChangePasswordStart>(
      (event, emit) async {
        return await changePassword(
          event.newPassword,
          emit,
        );
      },
    );
  }

  Future<void> changePassword(
    String newPassword,
    Emitter<ChangePasswordState> emit,
  ) async {
    final result = await changePasswordUsecase.execute(newPassword);
    result.fold(
      (l) => emit(
        ChangePasswordFailed(l.message!),
      ),
      (r) => emit(
        ChangePasswordSuccess(newPassword),
      ),
    );
  }
}
