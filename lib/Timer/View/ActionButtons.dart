import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/Timer/BLOC/timer_bloc.dart';

//uses a BlocBuilder to rebuild the UI every time we get a new TimerState
class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (prev, current) => prev.runtimeType != current.runtimeType,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...switch (state) {
                TimerInitial() => [
                    FloatingActionButton(
                        child: const Icon(Icons.play_arrow),
                        //Adding events with context.read.
                        onPressed: () => context
                            .read<TimerBloc>()
                            .add(TimerStarted(duration: state.duration)))
                  ],
                TimerInProcess() => [
                    FloatingActionButton(
                        heroTag: 'pause',
                        child: const Icon(Icons.pause),
                        onPressed: () =>
                            context.read<TimerBloc>().add(TimerPaused())),
                    FloatingActionButton(
                        heroTag: 'replay',
                        child: const Icon(Icons.replay),
                        onPressed: () =>
                            context.read<TimerBloc>().add(TimerReset()))
                  ],
                TimerPause() => [
                    FloatingActionButton(
                        heroTag: 'play',
                        child: const Icon(Icons.play_arrow),
                        onPressed: () =>
                            context.read<TimerBloc>().add(TimerResumed())),
                    FloatingActionButton(
                        heroTag: 'replay',
                        child: const Icon(Icons.replay),
                        onPressed: () =>
                            context.read<TimerBloc>().add(TimerReset()))
                  ],
                TimerComplete() => [
                    FloatingActionButton(
                        child: const Icon(Icons.replay),
                        onPressed: () =>
                            context.read<TimerBloc>().add(TimerReset())),
                  ],
              }
            ],
          );
        });
  }
}
