part of "home_bloc.dart";

abstract class HomeEvent extends Equatable {}

class GetPresentInMonth extends HomeEvent {
  final int id;
  final int month;
  final int year;

  GetPresentInMonth(
    this.id,
    this.month,
    this.year,
  );

  @override
  List<Object> get props => [id, month, year];
}

class GetPresentOutMonth extends HomeEvent {
  final int id;
  final int month;
  final int year;

  GetPresentOutMonth(
    this.id,
    this.month,
    this.year,
  );

  @override
  List<Object> get props => [id, month, year];
}

class GetPresentInYear extends HomeEvent {
  final int id;
  final int year;

  GetPresentInYear(
    this.id,
    this.year,
  );

  @override
  List<Object> get props => [id, year];
}

class GetPresentOutYear extends HomeEvent {
  final int id;
  final int year;

  GetPresentOutYear(
    this.id,
    this.year,
  );

  @override
  List<Object> get props => [id, year];
}
