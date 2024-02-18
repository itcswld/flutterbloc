//StreamSubscription
//be the data source for the application. can subscribe and react to.
class Ticker {
  Stream<int> tick({required int ticks}) {
    //emits the remaining seconds every second.
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}
