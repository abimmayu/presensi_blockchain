part of 'get_holiday_bloc.dart';

abstract class HolidayEvent extends Equatable {}

class GetHoliday extends HolidayEvent {
  final int year;
  final int month;

  GetHoliday(this.year, this.month);

  @override
  List<Object> get props => [
        year,
        month,
      ];
}
