import 'package:equatable/equatable.dart';
import 'package:flutterbloc/Weather/weather.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repo/weather_repo.dart' show WeatherRepo;

part 'weather_cubit.g.dart';
part 'weather_state.dart';

class WeatherCubit extends HydratedCubit<WeatherState> {
  WeatherCubit(this._weatherRepo) : super(WeatherState());
  final WeatherRepo _weatherRepo;

  Future<void> fetchWeather(String? city) async {
    if (city == null || city.isEmpty) return;
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final weather = Weather.fromRepo(await _weatherRepo.getWeather(city));
      final units = state.unit;
      final value = units.isF
          ? weather.temperature.value.toF()
          : weather.temperature.value;

      emit(state.copyWith(
          status: WeatherStatus.success,
          temperatureUnit: units,
          weather: weather.copyWith(temperature: Temperature(value: value))));
    } on Exception {
      emit(state.copyWith(status: WeatherStatus.Error));
    }
  }

  Future<void> refreshWeather() async {
    if (!state.status.isSuccess || state.weather == Weather.empty) return;
    try {
      final weather =
          Weather.fromRepo(await _weatherRepo.getWeather(state.weather.loc));
      final units = state.unit;
      final value = units.isF
          ? weather.temperature.value.toF()
          : weather.temperature.value;

      emit(state.copyWith(
          status: WeatherStatus.success,
          temperatureUnit: units,
          weather: weather.copyWith(temperature: Temperature(value: value))));
    } on Exception {
      emit(state.copyWith(status: WeatherStatus.Error));
    }
  }

  void toggleUnits() {
    final units = state.unit.isF ? TemperatureUnit.C : TemperatureUnit.F;
    if (!state.status.isSuccess) {
      emit(state.copyWith(temperatureUnit: units));
      return;
    }

    final weather = state.weather;
    if (weather != Weather.empty) {
      final temperature = weather.temperature;
      final value =
          units.isC ? temperature.value.toC() : temperature.value.toF();
      emit(state.copyWith(
          temperatureUnit: units,
          weather: weather.copyWith(temperature: Temperature(value: value))));
    }
  }

  @override
  WeatherState fromJson(Map<String, dynamic> json) =>
      WeatherState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WeatherState state) => state.toJson();
}

extension on double {
  double toF() => (this * 9 / 5) + 32;
  double toC() => (this - 32) * 5 / 9;
}
