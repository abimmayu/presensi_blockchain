part of 'present_bloc.dart';

abstract class PresentEvent extends Equatable {}

class PresentIn extends PresentEvent {
  final BigInt id;
  final BigInt day;
  final BigInt month;
  final BigInt year;
  final String variety;

  PresentIn(
    this.id,
    this.day,
    this.month,
    this.year,
    this.variety,
  );

  @override
  List<Object> get props => [
        id,
        day,
        month,
        year,
        variety,
      ];
}

class PresentOut extends PresentEvent {
  final BigInt id;
  final BigInt day;
  final BigInt month;
  final BigInt year;
  final String variety;

  PresentOut(
    this.id,
    this.day,
    this.month,
    this.year,
    this.variety,
  );

  @override
  List<Object> get props => [
        id,
        day,
        month,
        year,
        variety,
      ];
}

class InputPresent extends PresentEvent {
  final BigInt idPresent;
  final BigInt idEmployees;

  InputPresent(
    this.idPresent,
    this.idEmployees,
  );

  @override
  List<Object> get props => [
        idPresent,
        idEmployees,
      ];
}

class CheckLocation extends PresentEvent {
  final LatLng latLng;

  CheckLocation(this.latLng);

  @override
  List<Object> get props => [latLng];
}
