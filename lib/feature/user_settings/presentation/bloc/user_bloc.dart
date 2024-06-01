import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/get_data_user_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/update_data_user_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetDataUserUsecase getDataUserUsecase;
  final UpdateDataUserUsecase updateDataUserUsecase;

  UserBloc(
    this.getDataUserUsecase,
    this.updateDataUserUsecase,
  ) : super(
          UserLoading(),
        ) {
    on<GetUserData>(
      (event, emit) async {
        await getData(
          event.id,
          emit,
        );
      },
    );
    on<PostPublicKey>(
      (event, emit) async {
        await postPublicKey(
          event.id,
          event.data,
          event.function,
          emit,
        );
      },
    );
  }

  Future<void> getData(
    String id,
    Emitter<UserState> emit,
  ) async {
    emit(
      UserLoading(),
    );
    final result = await getDataUserUsecase.execute(id);

    result.fold(
      (l) => emit(UserError(l.message!)),
      (r) {
        emit(
          UserLoaded(r),
        );
      },
    );
  }

  Future<void> postPublicKey(
    String id,
    Map<String, dynamic> data,
    void function,
    Emitter<UserState> emit,
  ) async {
    emit(
      UserLoading(),
    );

    final result = await updateDataUserUsecase.execute(
      id,
      data,
    );

    result.fold(
      (l) => emit(
        UserError(
          l.message!,
        ),
      ),
      (r) {
        add(
          GetUserData(id),
        );
        function;
      },
    );
  }
}
