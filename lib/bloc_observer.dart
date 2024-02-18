import 'package:bloc/bloc.dart';

class ObserveBlocs extends BlocObserver {
  const ObserveBlocs();

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print(
      '${bloc.runtimeType}, $change',
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print(error);
  }
}
