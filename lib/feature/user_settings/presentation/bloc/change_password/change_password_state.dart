part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordFailed extends ChangePasswordState {
  final String error;

  ChangePasswordFailed(this.error);

  @override
  List<Object> get props => [error];
}

class ChangePasswordSuccess extends ChangePasswordState {
  final String newPassword;

  ChangePasswordSuccess(this.newPassword);

  @override
  List<Object> get props => [newPassword];
}
