part of "home_bloc.dart";

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final int? presentInMonth;
  final int? presentOutMonth;
  final int? presentInYear;
  final int? presentOutYear;

  HomeLoaded({
    this.presentInMonth,
    this.presentOutMonth,
    this.presentInYear,
    this.presentOutYear,
  });

  @override
  List<Object> get props => [
        presentInMonth ?? 0,
        presentOutMonth ?? 0,
        presentInYear ?? 0,
        presentOutYear ?? 0,
      ];
}

class HomeError extends HomeState {
  final String error;

  HomeError(this.error);

  @override
  List<Object> get props => [error];
}
