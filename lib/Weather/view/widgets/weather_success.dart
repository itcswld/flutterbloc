import 'package:flutter/material.dart';
import 'package:flutterbloc/Weather/weather.dart';

class WeatherSuccess extends StatelessWidget {
  const WeatherSuccess(
      {required this.weather,
      required this.unit,
      required this.onRefresh,
      super.key});

  final Weather weather;
  final TemperatureUnit unit;
  final ValueGetter<Future<void>> onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        _Background(),
        RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  _WeatherIcon(condition: weather.condition),
                  Text(
                    weather.loc,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(
                    weather.formattedTemperature(unit),
                    style: theme.textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      '''Last Upd at ${TimeOfDay.fromDateTime(weather.lastUpd).format(context)}''')
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

///Widget
class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primaryContainer;
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [
              0.25,
              0.75,
              0.90,
              1.0
            ],
                colors: [
              color,
              color.brighten(),
              color.brighten(33),
              color.brighten(50),
            ])),
      ),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({required this.condition});

  final Condition condition;

  @override
  Widget build(BuildContext context) {
    return Text(
      condition.toEmoji,
      style: const TextStyle(fontSize: 75.0),
    );
  }
}

///extension
extension on Color {
  Color brighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100, 'must be between 1 to 100');
    final p = percent / 100;
    return Color.fromARGB(
      alpha,
      red + ((255 - red) * p).round(),
      green + ((255 - green) * p).round(),
      blue + ((255 - blue) * p).round(),
    );
  }
}

extension on Weather {
  String formattedTemperature(TemperatureUnit units) {
    return "${temperature.value.toStringAsPrecision(2)}° ${units.isC ? 'C' : 'F'}";
  }
}

extension on Condition {
  String get toEmoji {
    switch (this) {
      case Condition.clear:
        return '☀️';
      case Condition.rainy:
        return '🌧️';
      case Condition.cloudy:
        return '☁️';
      case Condition.snowy:
        return '❄️️';
      default:
        return '❓';
    }
  }
}
