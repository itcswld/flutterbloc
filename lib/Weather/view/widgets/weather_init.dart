import 'package:flutter/material.dart';

class WeatherInit extends StatelessWidget {
  const WeatherInit({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🏙️', style: TextStyle(fontSize: 64)),
        Text(
          'Please Search a City',
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }
}
