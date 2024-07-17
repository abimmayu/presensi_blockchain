part of "home_bloc.dart";

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<PresentResult> presentInMonth;

  HomeLoaded(
    this.presentInMonth,
  );

  @override
  List<Object> get props => [
        presentInMonth,
      ];
}

class HomeError extends HomeState {
  final String error;

  HomeError(this.error);

  @override
  List<Object> get props => [error];
}
