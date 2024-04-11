import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/Login/bloc/auth/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(builder: (context) {
              final userId =
                  context.select((AuthBloc authBloc) => authBloc.state.user.id);
              return Text('UserID: $userId');
            }),
            ElevatedButton(
                child: const Text('Logout'),
                //bloc => repo =>stream status => bloc
                onPressed: () =>
                    context.read<AuthBloc>().add(AuthLogoutRequested())),
          ],
        ),
      ),
    );
  }
}
