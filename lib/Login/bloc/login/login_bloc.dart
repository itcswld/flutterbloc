import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterbloc/Login/model/models.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepo _authRepo;

  LoginBloc({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(const LoginState()) {
    on<LoginUserChanged>(_onLoginUserChanged);
    on<LoginPwdChanged>(_onLoginPwdChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginUserChanged(LoginUserChanged event, emit) {
    final username = Username.dirty(event.username);
    //update the form status via the Formz.validate API.
    emit(state.copyWith(
        username: username, isValid: Formz.validate([state.pwd, username])));
  }

  void _onLoginPwdChanged(LoginPwdChanged event, emit) {
    final pwd = Pwd.dirty(event.pwd);
    emit(state.copyWith(
        pwd: pwd, isValid: Formz.validate([pwd, state.username])));
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, emit) async {
    //state.isValid
    emit(state.copyWith(submitStatus: FormzSubmissionStatus.inProgress));
    try {
      await _authRepo.login(
          username: state.username.value, pwd: state.pwd.value);
      emit(state.copyWith(submitStatus: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(submitStatus: FormzSubmissionStatus.failure));
    }
  }
}
