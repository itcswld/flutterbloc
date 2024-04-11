import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../bloc/login/login_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    LoginState? curState;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        curState = state;
        if (state.submitStatus.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Authentication Failure')));
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UsernameInput(),
            _PwdInput(),
            _SubmitBtn(),
          ],
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (pre, cur) => pre.username != cur.username,
        builder: (context, state) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
            child: TextField(
              key: const Key('_UsernameInput'),
              decoration: InputDecoration(
                labelText: 'username',
                errorText: state.username.displayError != null
                    ? 'valid username'
                    : null,
              ),
              onChanged: (v) =>
                  context.read<LoginBloc>().add(LoginUserChanged(v)),
            ),
          );
        });
  }
}

class _PwdInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (pre, cur) => pre.pwd != cur.pwd,
        builder: (context, state) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
            child: TextField(
              key: const Key('_pwdInput'),
              decoration: InputDecoration(
                labelText: 'password',
                errorText:
                    state.pwd.displayError != null ? 'valid password' : null,
              ),
              obscureText: true,
              onChanged: (v) =>
                  context.read<LoginBloc>().add(LoginPwdChanged(v)),
            ),
          );
        });
  }
}

class _SubmitBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.submitStatus.isInProgress
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: state.isValid
                  ? () => context.read<LoginBloc>().add(LoginSubmitted())
                  : null,
              key: const Key('_SubmitBtn'),
              child: const Text('Login'),
            );
    });
  }
}
