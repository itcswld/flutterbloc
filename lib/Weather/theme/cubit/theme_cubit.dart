import 'package:flutter/material.dart';
import 'package:flutterbloc/Weather/weather.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather_repo/weather_repo.dart' show Condition;

class ThemeCubit extends HydratedCubit<Color> {
  ThemeCubit() : super(defaultColor);
  static const defaultColor = Color(0xFF2196F3);

  void updateTheme(Weather? weather) {
    if (weather != null) emit(weather.toColor);
  }

  @override
  Color? fromJson(Map<String, dynamic> json) =>
      Color(int.parse(json['color'] as String));

  @override
  Map<String, dynamic> toJson(Color state) =>
      <String, String>{'color': '${state.value}'};
}

extension on Weather {
  Color get toColor {
    switch (condition) {
      case Condition.clear:
        return Colors.yellow;
      case Condition.snowy:
        return Colors.lightBlueAccent;
      case Condition.rainy:
        return Colors.indigoAccent;
      default:
        return ThemeCubit.defaultColor;
    }
  }
}
