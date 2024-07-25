part of 'present_bloc.dart';

abstract class PresentState extends Equatable {
  @override
  List<Object> get props => [];
}

class PresentLoading extends PresentState {}

class PresentError extends PresentState {
  final String error;

  PresentError(this.error);

  @override
  List<Object> get props => [error];
}

class PresentSuccess extends PresentState {
  final String hashTrx;

  PresentSuccess(this.hashTrx);

  @override
  List<Object> get props => [hashTrx];
}

class LocationMatch extends PresentState {}

class LocationNotMatch extends PresentState {}

class LocationGot extends PresentState {}

class PresentLocationGet extends PresentState {
  final Position position;

  PresentLocationGet(this.position);

  @override
  List<Object> get props => [position];
}

class StartPresent extends PresentState {}

class PresentFailed extends PresentState {
  final String error;

  PresentFailed(this.error);

  @override
  List<Object> get props => [error];
}
