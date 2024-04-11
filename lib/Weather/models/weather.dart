import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repo/weather_repo.dart' as weather_repo;
import 'package:weather_repo/weather_repo.dart' hide Weather;

part 'weather.g.dart';

enum TemperatureUnit { F, C }

extension isUnit on TemperatureUnit {
  bool get isF => this == TemperatureUnit.F;
  bool get isC => this == TemperatureUnit.C;
}

@JsonSerializable()
class Temperature extends Equatable {
  final double value;
  const Temperature({required this.value});

  factory Temperature.fromJson(Map<String, dynamic> json) =>
      _$TemperatureFromJson(json);
  Map<String, dynamic> toJson() => _$TemperatureToJson(this);
  @override
  List<Object?> get props => [value];
}

@JsonSerializable()
class Weather extends Equatable {
  final DateTime lastUpd;
  final Condition condition;
  final String loc;
  final Temperature temperature;

  const Weather(
      {required this.lastUpd,
      required this.condition,
      required this.loc,
      required this.temperature});

  static final empty = Weather(
      lastUpd: DateTime(0),
      condition: Condition.unknown,
      loc: '--',
      temperature: const Temperature(value: 0));

  Weather copyWith(
          {DateTime? upd,
          Condition? condition,
          String? loc,
          Temperature? temperature}) =>
      Weather(
          lastUpd: upd ?? this.lastUpd,
          condition: condition ?? this.condition,
          loc: loc ?? this.loc,
          temperature: temperature ?? this.temperature);

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
  factory Weather.fromRepo(weather_repo.Weather repoWeather) {
    return Weather(
        condition: repoWeather.condition,
        lastUpd: DateTime.now(),
        loc: repoWeather.location,
        temperature: Temperature(value: repoWeather.temperature));
  }

  @override
  List<Object?> get props => [lastUpd, condition, loc, temperature];
}
