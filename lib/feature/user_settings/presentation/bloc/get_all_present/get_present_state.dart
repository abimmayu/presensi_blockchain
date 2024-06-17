part of 'get_present_bloc.dart';

abstract class AllPresentState extends Equatable {
  @override
  List<Object> get props => [];
}

class AllPresentLoading extends AllPresentState {}

class AllPresentSuccess extends AllPresentState {
  final List<PresentResult> presents;

  AllPresentSuccess(this.presents);

  @override
  List<Object> get props => [presents];
}

class AllPresentError extends AllPresentState {
  final String error;

  AllPresentError(this.error);

  @override
  List<Object> get props => [error];
}
