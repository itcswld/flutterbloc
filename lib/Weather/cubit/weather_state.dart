part of 'weather_cubit.dart';

enum WeatherStatus {
  initial,
  //API call
  loading,
  success,
  Error,
}

extension IsWeatherStatus on WeatherStatus {
  bool get isInitial => this == WeatherStatus.initial;
  bool get isLoading => this == WeatherStatus.loading;
  bool get isSuccess => this == WeatherStatus.success;
  bool get isFailure => this == WeatherStatus.Error;
}

@JsonSerializable()
final class WeatherState extends Equatable {
  final WeatherStatus status;
  final Weather weather;
  final TemperatureUnit unit;

  WeatherState(
      {this.status = WeatherStatus.initial,
      Weather? weather,
      this.unit = TemperatureUnit.C})
      : weather = weather ?? Weather.empty;

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    TemperatureUnit? temperatureUnit,
  }) =>
      WeatherState(
          status: status ?? this.status,
          weather: weather ?? this.weather,
          unit: temperatureUnit ?? this.unit);

  factory WeatherState.fromJson(Map<String, dynamic> json) =>
      _$WeatherStateFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherStateToJson(this);

  @override
  List<Object?> get props => [status, weather, unit];
}
