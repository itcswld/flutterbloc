import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/Timer/BLOC/timer_bloc.dart';
import 'package:flutterbloc/Timer/View/action_buttons.dart';
import 'package:flutterbloc/Timer/View/background.dart';
import 'package:flutterbloc/View/MenuPage.dart';

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, MenuPage.id),
              icon: const Icon(Icons.menu))
        ],
      ),
      body: const Stack(
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(
                  child: TimerText(),
                ),
              ),
              ActionButtons(),
            ],
          )
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minStr:$secStr',
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}
