import 'package:flutter/material.dart';
import 'package:flutterbloc/Counter/View/CounterPage.dart';
import 'package:flutterbloc/InfiniteList/View/PostsPage.dart';

import '../Timer/View/TimerPage.dart';

class MenuPage extends StatefulWidget {
  static const id = 'MenuPage';
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, CounterPage.id),
                child: const Text('Counter')),
            TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, TimerPage.id),
                child: const Text('Timer')),
            TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, PostsPage.id),
                child: const Text('Infinite List'))
          ],
        ),
      ),
    );
  }
}
