part of 'present_time_bloc.dart';

abstract class PresentTimeState extends Equatable {
  @override
  List<Object> get props => [];
}

class PresentTimeLoading extends PresentTimeState {}

class PresentTimeError extends PresentTimeState {
  final String error;
  PresentTimeError(this.error);

  @override
  List<Object> get props => [error];
}

class PresentTimeSuccess extends PresentTimeState {
  final PresentTimeModel presentTime;

  PresentTimeSuccess(this.presentTime);

  @override
  List<Object> get props => [presentTime];
}

class PresentTimeEditSuccess extends PresentTimeState {}
