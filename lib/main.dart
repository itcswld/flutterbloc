import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutterbloc/Counter/View/CounterPage.dart';
import 'package:flutterbloc/InfiniteList/View/PostsPage.dart';
import 'package:flutterbloc/bloc_observer.dart';

import 'Timer/View/TimerPage.dart';
import 'View/MenuPage.dart';

void main() {
  Bloc.observer = const ObserveBlocs();
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
      },
    );
  }
}
