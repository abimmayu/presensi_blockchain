part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin(
    this.email,
    this.password,
  );

  @override
  List<Object> get props => [email, password];
}

class AuthSignUp extends AuthEvent {
  final String email;
  final String password;

  AuthSignUp(
    this.email,
    this.password,
  );

  @override
  List<Object> get props => [email, password];
}

class AuthLogout extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthCreateWallet extends AuthEvent {
  final String pin;
  String? address;

  AuthCreateWallet({
    required this.pin,
    this.address,
  });

  @override
  List<Object> get props => [
        pin,
        address.toString(),
      ];
}

class AuthGetDataUser extends AuthEvent {
  final String id;

  AuthGetDataUser(this.id);

  @override
  List<Object> get props => [id];
}
