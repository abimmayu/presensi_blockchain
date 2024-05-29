import 'package:get_it/get_it.dart';
import 'package:presensi_blockchain/feature/dashboard/presentation/bloc/home_bloc.dart';
import 'package:presensi_blockchain/feature/login/data/data_source/login_data_source.dart';
import 'package:presensi_blockchain/feature/login/data/repository/auth_repository_impl.dart';
import 'package:presensi_blockchain/feature/login/domain/repository/auth_repository.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/get_data_user_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/log_out_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/login_usecases.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/sign_up_usecase.dart';
import 'package:presensi_blockchain/feature/login/presentation/bloc/auth_bloc.dart';

GetIt locator = GetIt.instance;

init() {
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

  //Repository
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  //Data Source
  locator.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(),
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
    () => GetDataUserUsecase(
      locator(),
    ),
  );
}
