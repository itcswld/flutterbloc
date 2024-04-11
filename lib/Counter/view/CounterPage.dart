import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/Counter/View/CounterView.dart';

import '../../Counter/Cubit/counter_cubit.dart';

class CounterPage extends StatelessWidget {
  static const id = 'CounterPage';
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}
