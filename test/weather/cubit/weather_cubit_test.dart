import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbloc/Weather/weather.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repo/weather_repo.dart' as weather_repo;

import '../../helpers/hydrated_bloc.dart';

const String loc = 'London';
const Condition condition = weather_repo.Condition.rainy;
const double temperature = 9.8;

extension on double {
  double toF() => (this * 9 / 5) + 32;
  double toC() => (this - 32) * 5 / 9;
}

class MockWeatherRepo extends Mock implements weather_repo.WeatherRepo {}

class MockWeatherRepoWeather extends Mock implements weather_repo.Weather {}

void main() {
  initHydratedStorage();

  group('WeatherCubit', () {
    late weather_repo.WeatherRepo weatherRepo;
    late weather_repo.Weather weather;
    late WeatherCubit weatherCubit;

    setUp(() async {
      weatherRepo = MockWeatherRepo();
      weather = MockWeatherRepoWeather();
      when(() => weather.location).thenReturn(loc);
      when(() => weather.condition).thenReturn(condition);
      when(() => weather.temperature).thenReturn(temperature);
      when(() => weatherRepo.getWeather(any()))
          .thenAnswer((_) async => weather);
      weatherCubit = WeatherCubit(weatherRepo);
    });

    test('initial state', () {
      final weatherCubit = WeatherCubit(weatherRepo);
      expect(weatherCubit.state, WeatherState());
    });

    group('Json state', () {
      test('fromJson/toJson()', () {
        final weatherCubit = WeatherCubit(weatherRepo);
        expect(weatherCubit.fromJson(weatherCubit.toJson(weatherCubit.state)),
            weatherCubit.state);
      });
    });

    group('fetchWeather', () {
      blocTest<WeatherCubit, WeatherState>(
        'city = null',
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(null),
        expect: () => <WeatherState>[],
      );
      blocTest<WeatherCubit, WeatherState>(
        'city is empty',
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(''),
        expect: () => <WeatherState>[],
      );
      blocTest<WeatherCubit, WeatherState>('city is correct',
          build: () => weatherCubit,
          act: (cubit) => cubit.fetchWeather(loc),
          verify: (_) {
            verify(() => weatherRepo.getWeather(loc)).called(1);
          });
      blocTest<WeatherCubit, WeatherState>(
        'throws [loading, failure] state exception',
        setUp: () {
          when(() => weatherRepo.getWeather(any()))
              .thenThrow(Exception('oops'));
        },
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(loc),
        expect: () => <WeatherState>[
          WeatherState(status: WeatherStatus.loading),
          WeatherState(status: WeatherStatus.Error),
        ],
      );
      blocTest('returns Celsius',
          build: () => weatherCubit,
          act: (cubit) => cubit.fetchWeather(loc),
          expect: () => <dynamic>[
                WeatherState(status: WeatherStatus.loading),
                isA<WeatherState>()
                    .having((ws) => ws.status, 'status', WeatherStatus.success)
                    .having(
                        (ws) => ws.weather,
                        'weather',
                        isA<Weather>()
                            .having((w) => w.lastUpd, 'lastUpd', isNotNull)
                            .having((w) => w.condition, 'condition', condition)
                            .having((w) => w.temperature, 'temperature',
                                Temperature(value: temperature))
                            .having((w) => w.loc, 'loc', loc))
              ]);
      blocTest('returns Fahrenheit',
          build: () => weatherCubit,
          seed: () => WeatherState(unit: TemperatureUnit.F),
          act: (cubit) => cubit.fetchWeather(loc),
          expect: () => <dynamic>[
                WeatherState(
                  status: WeatherStatus.loading,
                  unit: TemperatureUnit.F,
                ),
                isA<WeatherState>()
                    .having((ws) => ws.status, 'status', WeatherStatus.success)
                    .having(
                        (ws) => ws.weather,
                        'weather',
                        isA<Weather>()
                            .having((w) => w.lastUpd, 'lastUpd', isNotNull)
                            .having((w) => w.condition, 'condition', condition)
                            .having((w) => w.temperature, 'temperature',
                                Temperature(value: temperature.toF()))
                            .having((w) => w.loc, 'loc', loc))
              ]);
    });
    group('toggleUnits()', () {
      blocTest(
        '!state.status.isSuccess',
        build: () => weatherCubit,
        act: (cubit) => cubit.toggleUnits(),
        expect: () => <WeatherState>[WeatherState(unit: TemperatureUnit.F)],
      );
      blocTest(
        'to celsius',
        build: () => weatherCubit,
        seed: () => WeatherState(
          status: WeatherStatus.success,
          unit: TemperatureUnit.F,
          weather: Weather(
            loc: loc,
            temperature: Temperature(value: temperature),
            lastUpd: DateTime(2020),
            condition: Condition.rainy,
          ),
        ),
        act: (cubit) => cubit.toggleUnits(),
        expect: () => <WeatherState>[
          WeatherState(
            status: WeatherStatus.success,
            unit: TemperatureUnit.C,
            weather: Weather(
              loc: loc,
              temperature: Temperature(value: temperature.toC()),
              lastUpd: DateTime(2020),
              condition: Condition.rainy,
            ),
          ),
        ],
      );
      blocTest('to Fahrenheit',
          build: () => weatherCubit,
          seed: () {
            WeatherState ws = WeatherState(
              status: WeatherStatus.success,
              weather: Weather(
                loc: loc,
                temperature: Temperature(value: temperature),
                lastUpd: DateTime(2020),
                condition: Condition.rainy,
              ),
            );
            return ws;
          },
          act: (cubit) => cubit.toggleUnits(),
          expect: () {
            List<WeatherState> w = <WeatherState>[
              WeatherState(
                status: WeatherStatus.success,
                unit: TemperatureUnit.F,
                weather: Weather(
                  loc: loc,
                  temperature: Temperature(value: temperature.toF()),
                  lastUpd: DateTime(2020),
                  condition: Condition.rainy,
                ),
              ),
            ];
            return w;
          });
    });
  });
}
