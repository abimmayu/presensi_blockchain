import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:presensi_blockchain/core/utils/preferences.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:presensi_blockchain/feature/dashboard/presentation/bloc/home_bloc.dart';
import 'package:presensi_blockchain/feature/login/data/data_source/login_data_source.dart';
import 'package:presensi_blockchain/feature/login/data/repository/auth_repository_impl.dart';
import 'package:presensi_blockchain/feature/login/domain/repository/auth_repository.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/generate_wallet_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/get_data_user_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/log_out_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/login_usecases.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/sign_up_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/update_data_user_usecase.dart';
import 'package:presensi_blockchain/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/user_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

init() async {
  //Bloc locator
  locator.registerFactory(
    () => AuthBloc(
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => HomeBloc(),
  );
  locator.registerFactory(
    () => UserBloc(
      locator(),
      locator(),
    ),
  );

  //Repository
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      locator(),
    ),
  );

  //Data Source
  locator.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      preferences: locator(),
      storage: locator(),
    ),
  );

  //Usecase locator
  //1. Auth Usercase
  locator.registerLazySingleton(
    () => LoginUsecases(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => LogoutUsecase(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SignUpUsecase(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GenerateWalletUsecase(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetDataUserUsecase(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => UpdateDataUserUsecase(
      locator(),
    ),
  );

  //Local Source
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  locator.registerLazySingleton<LocalPreferences>(
    () => LocalPrefrencesImpl(
      shared: locator(),
    ),
  );
  locator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  locator.registerLazySingleton<SecureStorage>(
    () => SecureStorage(),
  );
}
