import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:presensi_blockchain/core/error/failure.dart';
import 'package:presensi_blockchain/feature/login/domain/repository/auth_repository.dart';

class GetDataUserUsecase {
  final AuthRepository authRepositoryl;

  GetDataUserUsecase(this.authRepositoryl);

  Future<Either<Failure, DocumentSnapshot>> execute(String id) async {
    return await authRepositoryl.getDataUser(id: id);
  }
}
