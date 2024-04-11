import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/Weather/cubit/weather_cubit.dart';
import 'package:flutterbloc/Weather/theme/cubit/theme_cubit.dart';
import 'package:flutterbloc/Weather/view/search_page.dart';
import 'package:flutterbloc/Weather/view/settings_page.dart';
import 'package:flutterbloc/Weather/view/widgets/weather_err.dart';
import 'package:flutterbloc/Weather/view/widgets/weather_init.dart';
import 'package:flutterbloc/Weather/view/widgets/weather_loading.dart';
import 'package:flutterbloc/Weather/view/widgets/weather_success.dart';
import 'package:weather_repo/weather_repo.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});
  static const id = 'WeatherPage';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit(context.read<WeatherRepo>()),
      child: const WeatherView(),
    );
  }
}

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(SettingsPage.route(context.read<WeatherCubit>())),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Center(
        child: BlocConsumer<WeatherCubit, WeatherState>(
          listener: (context, state) {
            if (state.status.isSuccess)
              context.read<ThemeCubit>().updateTheme(state.weather);
          },
          builder: (BuildContext context, WeatherState state) {
            switch (state.status) {
              case WeatherStatus.initial:
                return const WeatherInit();
              case WeatherStatus.loading:
                return const WeatherLoading();
              case WeatherStatus.success:
                return WeatherSuccess(
                  weather: state.weather,
                  unit: state.unit,
                  onRefresh: () {
                    return context.read<WeatherCubit>().refreshWeather();
                  },
                );
              default:
                return WeatherErr();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search, semanticLabel: 'Search'),
        onPressed: () async {
          final city = await Navigator.of(context).push(SearchPage.route());
          if (!context.mounted) return;
          await context.read<WeatherCubit>().fetchWeather(city);
        },
      ),
    );
  }
}
