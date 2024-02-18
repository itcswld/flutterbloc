import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/Timer/BLOC/timer_bloc.dart';
import 'package:flutterbloc/Timer/ticker.dart';

import 'TimerView.dart';

class TimerPage extends StatelessWidget {
  static String id = 'TimerPage';
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //using BlocProvider to access the instance of TimerBloc
      body: BlocProvider(
        create: (_) => TimerBloc(ticker: Ticker()),
        child: const TimerView(),
      ),
    );
  }
}
