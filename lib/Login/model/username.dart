import 'package:formz/formz.dart';

enum UsernameValidErr { empty }

//formz --to create reusable and standard models
//to simplify form representation and validation in a generic way.
class Username extends FormzInput<String, UsernameValidErr> {
  //formz pure 代表初始狀態，表示資料未被修改；dirty 則代表資料已被修改過。
  const Username.pure() : super.pure('');
  const Username.dirty([super.value = '']) : super.dirty();

  //override validator，一旦資料被修改便會進行驗證，隨時更新資料的狀態以及 Error狀態。
  //validating the username to ensure that it is not empty
  @override
  UsernameValidErr? validator(String value) {
    if (value.isEmpty) return UsernameValidErr.empty;
    return null;
  }
}
