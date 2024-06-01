part of 'present_bloc.dart';

abstract class PresentEvent extends Equatable {}

class PresentIn extends PresentEvent {
  final BigInt id;

  PresentIn(this.id);

  @override
  List<Object> get props => [id];
}

class PresentOut extends PresentEvent {
  final BigInt id;

  PresentOut(this.id);

  @override
  List<Object> get props => [];
}
