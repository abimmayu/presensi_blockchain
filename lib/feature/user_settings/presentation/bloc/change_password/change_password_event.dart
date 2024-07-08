part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {}

class ChangePasswordStart extends ChangePasswordEvent {
  final String newPassword;

  ChangePasswordStart(this.newPassword);

  @override
  List<Object> get props => [newPassword];
}
