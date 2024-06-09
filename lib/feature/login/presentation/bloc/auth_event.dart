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
  final AuthState state;

  AuthLogout(this.state);
  @override
  List<Object> get props => [];
}

class AuthCreateWallet extends AuthEvent {
  final String pin;

  AuthCreateWallet({
    required this.pin,
  });

  @override
  List<Object> get props => [
        pin,
      ];
}

class AuthImportWallet extends AuthEvent {
  final String password;
  final String? privateKey;
  final List<TextEditingController>? mnemonicInput;

  AuthImportWallet(
    this.password,
    this.privateKey,
    this.mnemonicInput,
  );

  @override
  List<Object?> get props => [
        password,
        privateKey,
        mnemonicInput,
      ];
}

class AuthGetDataUser extends AuthEvent {
  final String id;

  AuthGetDataUser(this.id);

  @override
  List<Object> get props => [id];
}

class AuthRegisterUser extends AuthEvent {
  final String id;
  final Map<String, dynamic> data;

  AuthRegisterUser(this.id, this.data);

  @override
  List<Object> get props => [id, data];
}

class AuthUpdatePublicKey extends AuthEvent {
  final String id;
  final Map<String, dynamic> data;

  AuthUpdatePublicKey(this.id, this.data);

  @override
  List<Object> get props => [id, data];
}
