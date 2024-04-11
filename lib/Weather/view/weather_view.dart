import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/Weather/theme/cubit/theme_cubit.dart';
import 'package:flutterbloc/Weather/view/weather_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_repo/weather_repo.dart';

class WeatherApp extends StatelessWidget {
  static const id = 'WeatherApp';
  const WeatherApp({required WeatherRepo weatherRepo, super.key})
      : _weatherRepo = weatherRepo;

  final WeatherRepo _weatherRepo;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _weatherRepo,
      child: BlocProvider(
        create: (_) => ThemeCubit(),
        child: const WeatherView(),
      ),
    );
  }
}

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, Color>(builder: (context, color) {
      return MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: color),
          textTheme: GoogleFonts.rajdhaniTextTheme(),
        ),
        home: const WeatherPage(),
      );
    });
  }
}
