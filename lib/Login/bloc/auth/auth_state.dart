part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final User user;
  const AuthState._(
      {this.authStatus = AuthStatus.unknown, this.user = User.empty});

  const AuthState.unknown() : this._();
  const AuthState.authenticated(User user)
      : this._(authStatus: AuthStatus.authenticated, user: user);
  const AuthState.unauthenticated()
      : this._(authStatus: AuthStatus.unauthenticated);

  @override
  List get props => [authStatus, user];
}
