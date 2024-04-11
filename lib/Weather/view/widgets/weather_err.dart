import 'package:flutter/material.dart';

class WeatherErr extends StatelessWidget {
  const WeatherErr({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🙈', style: TextStyle(fontSize: 64)),
        Text('Error!', style: theme.textTheme.headlineSmall),
      ],
    );
  }
}
