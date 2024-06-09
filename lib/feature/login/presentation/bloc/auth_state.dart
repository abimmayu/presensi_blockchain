part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object> get props => [];
}

class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);

  @override
  List<Object> get props => [];
}

class AuthSignout extends AuthState {}

class AuthInitial extends AuthState {}

class AuthWalletSuccess extends AuthState {
  final Wallet wallet;

  AuthWalletSuccess(this.wallet);

  @override
  List<Object> get props => [wallet];
}

class AuthRegisterSuccess extends AuthState {
  final User user;

  AuthRegisterSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthAddUserSuccess extends AuthState {}
