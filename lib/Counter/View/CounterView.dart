import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../View/MenuPage.dart';
import '../Cubit/counter_cubit.dart';

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, MenuPage.id),
              icon: const Icon(Icons.menu))
        ],
      ),
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, state) {
            return Text('$state', style: theme.displayMedium);
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
              heroTag: 'add',
              child: const Icon(Icons.add),
              onPressed: () => context.read<CounterCubit>().increment()),
          FloatingActionButton(
              heroTag: 'minus',
              child: const Icon(Icons.remove),
              onPressed: () => context.read<CounterCubit>().decrement()),
        ],
      ),
    );
  }
}
