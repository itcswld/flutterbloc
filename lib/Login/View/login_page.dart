import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/Login/bloc/auth/auth_bloc.dart';
import 'package:user_repo/user_repo.dart';

import 'login_nav.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthRepo _authRepo;
  late final UserRepo _userRepo;

  @override
  void initState() {
    super.initState();
    _authRepo = AuthRepo();
    _userRepo = UserRepo();
  }

  @override
  void dispose() {
    _authRepo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepo,
      child: BlocProvider(
        create: (_) => AuthBloc(authRepo: _authRepo, userRepo: _userRepo),
        child: const LoginNav(),
      ),
    );
  }
}
