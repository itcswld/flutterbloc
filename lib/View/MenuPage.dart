import 'package:flutter/material.dart';
import 'package:flutterbloc/Counter/View/CounterPage.dart';
import 'package:flutterbloc/InfiniteList/View/posts_page.dart';

import '../Login/View/login_page.dart';
import '../Timer/View/timer_page.dart';
import '../Weather/view/weather_view.dart';

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
      body: const Center(
        child: Column(
          children: [
            _PageBtn(id: CounterPage.id, name: 'Counter'),
            _PageBtn(id: TimerPage.id, name: 'Timer'),
            _PageBtn(id: PostsPage.id, name: 'Infinite List'),
            _PageBtn(id: LoginPage.id, name: 'Login'),
            _PageBtn(id: WeatherApp.id, name: 'WeatherApp')
          ],
        ),
      ),
    );
  }
}

class _PageBtn extends StatelessWidget {
  final String id;
  final String name;

  const _PageBtn({required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => Navigator.pushReplacementNamed(context, id),
        child: Text(name));
  }
}
