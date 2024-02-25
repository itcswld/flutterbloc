import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/Login/View/home_page.dart';
import 'package:flutterbloc/Login/View/login_view.dart';
import 'package:flutterbloc/Login/View/splash_page.dart';
import 'package:flutterbloc/Login/bloc/auth/auth_bloc.dart';

class LoginNav extends StatefulWidget {
  const LoginNav({super.key});

  @override
  State<LoginNav> createState() => _LoginNavState();
}

class _LoginNavState extends State<LoginNav> {
  //拿到全局的context
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (_, child) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (_, state) {
            switch (state.authStatus) {
              case AuthStatus.authenticated:
                _navigator.pushAndRemoveUntil(
                    HomePage.route(), (route) => false);
              case AuthStatus.unauthenticated:
                _navigator.pushAndRemoveUntil(
                    LoginView.route(), (route) => false);
              case AuthStatus.unknown:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
