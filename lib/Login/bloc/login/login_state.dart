part of 'login_bloc.dart';

class LoginState extends Equatable {
  final FormzSubmissionStatus submitStatus;
  final Username username;
  final Pwd pwd;
  final bool isValid;

  const LoginState(
      {this.submitStatus = FormzSubmissionStatus.initial,
      this.username = const Username.pure(),
      this.pwd = const Pwd.pure(),
      this.isValid = false});

  LoginState copyWith({
    FormzSubmissionStatus? submitStatus,
    Username? username,
    Pwd? pwd,
    bool? isValid,
  }) {
    return LoginState(
        submitStatus: submitStatus ?? this.submitStatus,
        username: username ?? this.username,
        pwd: pwd ?? this.pwd,
        isValid: isValid ?? this.isValid);
  }

  @override
  List get props => [submitStatus, username, pwd, isValid];
}
