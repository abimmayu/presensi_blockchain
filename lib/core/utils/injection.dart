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
import 'package:presensi_blockchain/feature/login/domain/usecases/import_wallet_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/log_out_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/login_usecases.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/sign_up_usecase.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/update_data_user_usecase.dart';
import 'package:presensi_blockchain/feature/login/presentation/bloc/auth_bloc.dart';
import 'package:presensi_blockchain/feature/present/domain/usecase/check_location_usecase.dart';
import 'package:presensi_blockchain/feature/present/domain/usecase/input_present_usecase.dart';
import 'package:presensi_blockchain/feature/present/domain/usecase/present_in_usecase.dart';
import 'package:presensi_blockchain/feature/present/domain/usecase/present_out_usecase.dart';
import 'package:presensi_blockchain/feature/present/presentation/bloc/present_bloc.dart';
import 'package:presensi_blockchain/feature/login/domain/usecases/add_data_user_usecase.dart';
import 'package:presensi_blockchain/feature/user_settings/data/datapost/user_settings_datapost.dart';
import 'package:presensi_blockchain/feature/user_settings/data/datasource/all_present_data_source.dart';
import 'package:presensi_blockchain/feature/user_settings/data/repository/all_present_repository_impl.dart';
import 'package:presensi_blockchain/feature/user_settings/data/repository/change_password_repository_impl.dart';
import 'package:presensi_blockchain/feature/user_settings/data/repository/present_time_repository_impl.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/repository/all_present_repository.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/repository/change_password_repository.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/repository/present_time_repository.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/usecase/all_present_usecase.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/usecase/change_password_usecase.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/usecase/get_holiday_usecase.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/usecase/get_present_time_usecase.dart';
import 'package:presensi_blockchain/feature/user_settings/domain/usecase/update_present_time_usecase.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/change_password/change_password_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/get_all_present/get_present_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/get_holiday/get_holiday_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/present_time/present_time_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/user/user_bloc.dart';
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
  locator.registerFactory(
    () => PresentBloc(
      locator(),
      locator(),
      // locator(),
      // locator(),
    ),
  );
  locator.registerFactory(
    () => AllPresentBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => HolidayBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => ChangePasswordBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => PresentTimeBloc(
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
  locator.registerLazySingleton<AllPresentRepository>(
    () => AllPresentRepositoryImpl(),
  );
  locator.registerLazySingleton<ChangePasswordRepository>(
    () => ChangePasswordRepositoryImpl(),
  );
  locator.registerLazySingleton<PresentTimeRepository>(
    () => PresentTimeRepositoryImpl(),
  );

  //Data Source
  locator.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      preferences: locator(),
      storage: locator(),
    ),
  );
  locator.registerLazySingleton<AllPresentDataSource>(
    () => AllPresentDataSourceImpl(),
  );

  //Data Post
  locator.registerLazySingleton<UserSettingsDataPost>(
    () => UserSettingsDataPostImpl(),
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
  locator.registerLazySingleton(
    () => ImportWalletUsecase(
      locator(),
    ),
  );

  //2. Present Usecase
  locator.registerLazySingleton(
    () => CheckCorrectLocationUsecase(),
  );
  locator.registerLazySingleton(
    () => InputPresentUsecase(),
  );

  //3. User Usecase
  locator.registerLazySingleton(
    () => AddDataUserUsecase(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => AllPresentUsecase(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetHolidayUsecase(
      locator(),
    ),
  );

  //4. Change Password Usecase
  locator.registerLazySingleton(
    () => ChangePasswordUsecase(
      locator(),
    ),
  );

  //5. Present Time Usecase
  locator.registerLazySingleton(
    () => GetPresentTimeUsecase(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => UpdatePresentTimeUsecase(
      locator(),
    ),
  );

  //Local Source
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );
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
