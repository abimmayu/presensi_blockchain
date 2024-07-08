part of 'present_time_bloc.dart';

abstract class PresentTimeEvent extends Equatable {}

class GetPresentTime extends PresentTimeEvent {
  @override
  List<Object> get props => [];
}

class UpdatePresentTime extends PresentTimeEvent {
  final PresentTime getIn;
  final PresentTime getOut;

  UpdatePresentTime(
    this.getIn,
    this.getOut,
  );

  @override
  List<Object> get props => [
        getIn,
        getOut,
      ];
}
