import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/generate_wallet_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/log_out_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/login_usecases.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/sign_up_usecase.dart';
import 'package:web3dart/credentials.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecases loginUsecases;
  final LogoutUsecase logoutUsecase;
  final SignUpUsecase signUpUsecase;
  final GenerateWalletUsecase generateWalletUsecase;

  final SecureStorage storage = SecureStorage();

  AuthBloc(
    this.loginUsecases,
    this.logoutUsecase,
    this.signUpUsecase,
    this.generateWalletUsecase,
  ) : super(
          AuthInitial(),
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
    on<AuthCreateWallet>(
      (event, emit) async {
        return await createWallet(
          password: event.pin,
          emit: emit,
          address: event.address,
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
      (r) {
        emit(
          AuthSignout(),
        );
      },
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

  Future<void> createWallet(
      {required String password,
      required Emitter<AuthState> emit,
      String? address}) async {
    emit(
      AuthLoading(),
    );

    final result = await generateWalletUsecase.execute(
      password: password,
      address: address,
    );

    result.fold(
      (l) => emit(AuthError(l.message!)),
      (r) {
        emit(
          AuthWalletSuccess(r),
        );
      },
    );
  }

  Future<void> importWallet(
    String password,
    String address,
    Emitter<AuthState> emit,
  ) async {}
}
