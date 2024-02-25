part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginUserChanged extends LoginEvent {
  final String username;
  LoginUserChanged(this.username);

  @override
  List<Object> get props => [username];
}

class LoginPwdChanged extends LoginEvent {
  final String pwd;
  LoginPwdChanged(this.pwd);
  @override
  List<Object> get props => [pwd];
}

class LoginSubmitted extends LoginEvent {
  LoginSubmitted();
}
