import 'dart:async';

/*AuthRepo exposes a Stream of AuthenticationStatus updates
which will be used to notify the application when a user signs in or out.
 */
enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthRepo {
  final _streamCtrl = StreamController<AuthStatus>();
  //async * 标记的方法都是生成器，返回值只能是Stream类型
  Stream<AuthStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    //每yield一次都会向返回的流中添加一次数据
    yield AuthStatus.unauthenticated;
    yield* _streamCtrl.stream;
  }

  Future<void> login({required String username, required String pwd}) async {
    await Future.delayed(const Duration(seconds: 1),
        () => _streamCtrl.add(AuthStatus.authenticated));
  }

  void logout() {
    _streamCtrl.add(AuthStatus.unauthenticated);
  }

  void dispose() => _streamCtrl.close();
}
