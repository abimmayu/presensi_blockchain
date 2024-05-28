import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/log_out_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/login_usecases.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/sign_up_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecases loginUsecases;
  final LogoutUsecase logoutUsecase;
  final SignUpUsecase signUpUsecase;

  AuthBloc(this.loginUsecases, this.logoutUsecase, this.signUpUsecase)
      : super(
          AuthLoading(),
        ) {
    on<AuthLogin>(
      (event, emit) async {
        return await login(
          event.email,
          event.password,
          emit,
        );
      },
    );
    on<AuthLogout>(
      (event, emit) async {
        return await logout(
          emit,
        );
      },
    );
    on<AuthSignUp>(
      (event, emit) async {
        return await signUp(
          event.email,
          event.password,
          emit,
        );
      },
    );
  }

  Future<void> login(
    String email,
    String password,
    Emitter<AuthState> emit,
  ) async {
    emit(
      AuthLoading(),
    );

    final result = await loginUsecases.execute(email, password);

    result.fold(
      (l) => AuthError(l.message!),
      (r) {
        log(
          r.toString(),
        );
        emit(
          AuthSuccess(r!),
        );
      },
    );
  }

  Future<void> logout(
    Emitter<AuthState> emit,
  ) async {
    emit(
      AuthLoading(),
    );

    final result = await logoutUsecase.execute();

    result.fold(
      (l) => emit(
        AuthError(l.message!),
      ),
      (r) => emit(
        AuthSignout(),
      ),
    );
  }

  Future<void> signUp(
    String email,
    String password,
    Emitter<AuthState> emit,
  ) async {
    emit(
      AuthLoading(),
    );

    final result = await signUpUsecase.execute(email, password);

    result.fold(
      (l) => emit(AuthError(l.message!)),
      (r) => emit(
        AuthSuccess(r!),
      ),
    );
  }
}