import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterbloc/Counter/View/CounterPage.dart';
import 'package:flutterbloc/InfiniteList/View/posts_page.dart';
import 'package:flutterbloc/Login/View/login_page.dart';
import 'package:flutterbloc/bloc_observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_repo/weather_repo.dart';

import 'Timer/View/timer_page.dart';
import 'View/MenuPage.dart';
import 'Weather/view/weather_view.dart';

//Entrypoint
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const ObserveBlocs();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Bloc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: MenuPage.id,
      routes: {
        MenuPage.id: (_) => const MenuPage(),
        CounterPage.id: (_) => const CounterPage(),
        TimerPage.id: (_) => const TimerPage(),
        PostsPage.id: (_) => const PostsPage(),
        LoginPage.id: (_) => const LoginPage(),
        WeatherApp.id: (_) => WeatherApp(weatherRepo: WeatherRepo()),
      },
    );
  }
}
