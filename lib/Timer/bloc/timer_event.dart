part of 'timer_bloc.dart';

//Events --which Bloc will be processing.
// @immutable
// abstract class TimerEvent {
sealed class TimerEvent {
  const TimerEvent();
}

final class TimerStarted extends TimerEvent {
  final int duration;
  TimerStarted({required this.duration});
}

final class TimerPaused extends TimerEvent {
  TimerPaused();
}

final class TimerResumed extends TimerEvent {
  TimerResumed();
}

final class TimerReset extends TimerEvent {
  TimerReset();
}

final class _TimerTicked extends TimerEvent {
  final int duration;
  _TimerTicked({required this.duration});
}
