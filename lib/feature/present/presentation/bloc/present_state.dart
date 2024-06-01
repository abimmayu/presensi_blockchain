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

class PresentSuccess extends PresentState {}
