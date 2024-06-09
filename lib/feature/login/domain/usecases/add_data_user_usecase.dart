import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/login/domain/repository/auth_repository.dart';

class AddDataUserUsecase {
  final AuthRepository authRepository;

  AddDataUserUsecase(this.authRepository);

  Future<Either<Failure, void>> execute(
      String id, Map<String, dynamic> data) async {
    return await authRepository.addDataUser(id: id, data: data);
  }
}
