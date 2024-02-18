part of 'timer_bloc.dart';

//States -- which the Bloc can be in.

//Equatable -- do not trigger rebuilds if the same state occurs.
sealed class TimerState extends Equatable {
  final int duration;

  const TimerState(this.duration);

  @override
  List<Object> get props => [duration];
}

//State can be one of the following:
final class TimerInitial extends TimerState {
  const TimerInitial(super.duration);

  @override
  String toString() => 'TimerInitial { duration : $duration }';
}

final class TimerPause extends TimerState {
  const TimerPause(super.duration);

  @override
  String toString() => 'TimerPause { duration : $duration}';
}

final class TimerInProcess extends TimerState {
  const TimerInProcess(super.duration);

  @override
  String toString() => 'TimerRun {duration : $duration}';
}

final class TimerComplete extends TimerState {
  const TimerComplete() : super(0);
}
