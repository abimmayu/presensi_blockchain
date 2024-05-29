part of "user_bloc.dart";

abstract class UserEvent extends Equatable {}

class GetUserData extends UserEvent {
  final String id;

  GetUserData(this.id);

  @override
  List<Object> get props => [id];
}

class ChangeUserData extends UserEvent {
  final String id;
  final String name;
  final int nip;
  final String occupation;

  ChangeUserData(
    this.id,
    this.name,
    this.nip,
    this.occupation,
  );

  @override
  List<Object> get props => [
        id,
        name,
        nip,
        occupation,
      ];
}

class AddUserData extends UserEvent {
  final String email;
  final String password;
  final String id;
  final String name;
  final int nip;
  final String occupation;

  AddUserData(
    this.email,
    this.password,
    this.id,
    this.name,
    this.nip,
    this.occupation,
  );

  @override
  List<Object> get props => [
        email,
        password,
        id,
        name,
        nip,
        occupation,
      ];
}
