import 'dart:async';

import 'package:auth_repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:user_repo/user_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo;
  final UserRepo _userRepo;
  late StreamSubscription<AuthStatus> _authStatusSubscription;

  AuthBloc({required AuthRepo authRepo, required UserRepo userRepo})
      : _authRepo = authRepo,
        _userRepo = userRepo,
        super(const AuthState.unknown()) {
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<AuthLogoutRequested>((event, emit) {
      _authRepo.logout();
    });
    _authStatusSubscription = _authRepo.status.listen((status) {
      add(AuthStatusChanged(status));
    });
  }

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthStatusChanged(AuthStatusChanged event, emit) async {
    switch (event.authStatus) {
      case AuthStatus.unauthenticated:
        return emit(const AuthState.unauthenticated());
      case AuthStatus.authenticated:
        final user = await _getUser();
        return emit(user != null
            ? AuthState.authenticated(user)
            : const AuthState.unauthenticated());
      case AuthStatus.unknown:
        return emit(const AuthState.unknown());
    }
  }

  Future<User?> _getUser() async {
    try {
      return await _userRepo.getUser();
    } catch (_) {
      return null;
    }
  }
}
