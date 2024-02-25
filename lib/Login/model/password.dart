import 'package:formz/formz.dart';

enum PwdValidErr { empty }

//formz --to create reusable and standard models
//to simplify form representation and validation in a generic way.
class Pwd extends FormzInput<String, PwdValidErr> {
  const Pwd.pure() : super.pure('');
  const Pwd.dirty([super.value = '']) : super.dirty();

  //validating the username to ensure that it is not empty
  @override
  PwdValidErr? validator(String value) {
    if (value.isEmpty) return PwdValidErr.empty;
    return null;
  }
}
