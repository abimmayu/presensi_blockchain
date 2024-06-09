import 'dart:developer';

import 'package:bip39/bip39.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/add_data_user_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/generate_wallet_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/import_wallet_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/log_out_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/login_usecases.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/sign_up_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/update_data_user_usecase.dart';

import 'package:web3dart/credentials.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecases loginUsecases;
  final LogoutUsecase logoutUsecase;
  final SignUpUsecase signUpUsecase;
  final GenerateWalletUsecase generateWalletUsecase;
  final ImportWalletUsecase importWalletUsecase;
  final UpdateDataUserUsecase updateDataUserUsecase;
  final AddDataUserUsecase addDataUserUsecase;

  final SecureStorage storage = SecureStorage();

  AuthBloc(
    this.loginUsecases,
    this.logoutUsecase,
    this.signUpUsecase,
    this.generateWalletUsecase,
    this.importWalletUsecase,
    this.updateDataUserUsecase,
    this.addDataUserUsecase,
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
          event.state,
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
    on<AuthUpdatePublicKey>(
      (event, emit) async {},
    );
    on<AuthRegisterUser>(
      (event, emit) async {
        return await addDataUser(
          event.id,
          event.data,
          emit,
        );
      },
    );
    on<AuthCreateWallet>(
      (event, emit) async {
        return await createWallet(
          password: event.pin,
          emit: emit,
        );
      },
    );
    on<AuthImportWallet>(
      (event, emit) async {
        return await importWallet(
          event.password,
          event.privateKey,
          event.mnemonicInput,
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
      (l) => emit(
        AuthError(
          l.message!,
        ),
      ),
      (r) {
        emit(
          AuthSuccess(r!),
        );
      },
    );
  }

  Future<void> logout(
    Emitter<AuthState> emit,
    AuthState state,
  ) async {
    emit(
      AuthLoading(),
    );
    log("Sedang logout...");

    final result = await logoutUsecase.execute();

    result.fold(
      (l) => emit(
        AuthError(l.message!),
      ),
      (r) {
        emit(
          state,
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
        AuthRegisterSuccess(r!),
      ),
    );
  }

  Future<void> addDataUser(
    String id,
    Map<String, dynamic> data,
    Emitter<AuthState> emit,
  ) async {
    emit(
      AuthLoading(),
    );

    final result = await addDataUserUsecase.execute(
      id,
      data,
    );

    result.fold(
      (l) => emit(
        AuthError(
          l.message!,
        ),
      ),
      (r) => emit(
        AuthAddUserSuccess(),
      ),
    );
  }

  Future<void> createWallet({
    required String password,
    required Emitter<AuthState> emit,
  }) async {
    emit(
      AuthLoading(),
    );

    final result = await generateWalletUsecase.execute(
      password: password,
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
    String? privateKey,
    List<TextEditingController>? mnemonicInput,
    Emitter<AuthState> emit,
  ) async {
    log("Import Wallet...");
    final result = await importWalletUsecase.execute(
      password: password,
      privateKey: privateKey,
      mnemonicWords: mnemonicInput,
    );

    result.fold(
      (l) => emit(
        AuthError(l.message!),
      ),
      (r) => emit(
        AuthWalletSuccess(r),
      ),
    );
  }
}
