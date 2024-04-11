import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbloc/Weather/theme/cubit/theme_cubit.dart';
import 'package:flutterbloc/Weather/weather.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/hydrated_bloc.dart';

class MockWeather extends Mock implements Weather {
  final Condition _condition;
  MockWeather(this._condition);

  @override
  Condition get condition => _condition;
}

void main() {
  initHydratedStorage();

  group('ThemCubit', () {
    test('initial state',
        () => expect(ThemeCubit().state, ThemeCubit.defaultColor));

    group('fromJson/toJson()', () {
      test('fromJson/toJson()', () {
        final themeCubit = ThemeCubit();
        expect(themeCubit.fromJson(themeCubit.toJson(themeCubit.state)),
            themeCubit.state);
      });
    });

    group('updateTheme()', () {
      final clearWeather = MockWeather(Condition.clear);
      final snowyWeather = MockWeather(Condition.snowy);
      final unknownWeather = MockWeather(Condition.unknown);

      blocTest<ThemeCubit, Color>(
        'clearWeather',
        build: ThemeCubit.new,
        act: (cubit) => cubit.updateTheme(clearWeather),
        expect: () => <Color>[Colors.yellow],
      );
      blocTest<ThemeCubit, Color>(
        'snowyWeather',
        build: ThemeCubit.new,
        act: (cubit) => cubit.updateTheme(snowyWeather),
        expect: () => <Color>[Colors.lightBlueAccent],
      );
      blocTest<ThemeCubit, Color>(
        'unknownWeather',
        build: ThemeCubit.new,
        act: (cubit) => cubit.updateTheme(unknownWeather),
        expect: () => <Color>[ThemeCubit.defaultColor],
      );
    });
  });
}
