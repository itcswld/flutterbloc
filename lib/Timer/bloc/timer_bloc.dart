import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterbloc/Timer/ticker.dart';

part 'timer_event.dart'; //be processing
part 'timer_state.dart'; //be in

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const int _duration = 60;
  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;

  //define the initial state
  TimerBloc({required Ticker ticker})
      //define the dependency on Ticker
      : _ticker = ticker,
        super(const TimerInitial(_duration)) {
    on<TimerStarted>(_onStarted);
    on<_TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onRest);
  }

  @override
  Future<void> close() {
    //if there was already an open _tickerSubscription we need to cancel it to deallocate the memory.
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerInProcess(event.duration));
    _tickerSubscription?.cancel();
    //add a _TimerTicked event with the remaining duration.
    _tickerSubscription =
        _ticker.tick(ticks: event.duration).listen((duration) {
      add(_TimerTicked(duration: duration));
    });
  }

  void _onTicked(_TimerTicked event, Emitter<TimerState> emit) {
    emit(event.duration > 0
        ? TimerInProcess(event.duration)
        : const TimerComplete());
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerInProcess) {
      _tickerSubscription?.pause();
      emit(TimerPause(state.duration));
    }
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerPause) {
      _tickerSubscription?.resume();
      emit(TimerInProcess(state.duration));
    }
  }

  void _onRest(TimerReset event, Emitter<TimerState> emit) {
    //cancel the current _tickerSubscription
    _tickerSubscription?.cancel();
    emit(const TimerInitial(_duration));
  }
}
