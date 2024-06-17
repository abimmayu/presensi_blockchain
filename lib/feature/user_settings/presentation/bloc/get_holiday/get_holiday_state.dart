part of 'get_holiday_bloc.dart';

abstract class HolidayState extends Equatable {
  @override
  List<Object> get props => [];
}

class HolidayInitial extends HolidayState {}

class HolidayLoading extends HolidayState {}

class HolidayError extends HolidayState {
  final String message;
  HolidayError(this.message);

  @override
  List<Object> get props => [message];
}

class HolidaySuccess extends HolidayState {
  final List holidays;
  HolidaySuccess(this.holidays);

  @override
  List<Object> get props => [holidays];
}
