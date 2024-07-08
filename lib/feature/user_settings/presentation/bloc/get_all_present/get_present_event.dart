part of 'get_present_bloc.dart';

abstract class AllPresentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AllPresentGet extends AllPresentEvent {
  final int month;
  final int year;

  AllPresentGet(this.month, this.year);

  @override
  List<Object> get props => [month, year];
}
