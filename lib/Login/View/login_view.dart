import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/Login/bloc/login/login_bloc.dart';

import 'login_from.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => const LoginView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) =>
              LoginBloc(authRepo: RepositoryProvider.of<AuthRepo>(context)),
          child: const LoginForm(),
        ),
      ),
    );
  }
}
