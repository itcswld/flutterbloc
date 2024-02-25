part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthStatusChanged extends AuthEvent {
  final AuthStatus authStatus;
  AuthStatusChanged(this.authStatus);
}

class AuthLogoutRequested extends AuthEvent {}
