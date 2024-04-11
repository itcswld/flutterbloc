import 'package:meteo_api/meteo_api.dart' as MeteoApi;
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:weather_repo/weather_repo.dart';

class MockMeteoApiClient extends Mock implements MeteoApi.MeteoApiClient {}

class MockLocation extends Mock implements MeteoApi.Location {}

class MockWeather extends Mock implements MeteoApi.Weather {}

void main() {
  group('WeatherRepo', () {
    late MeteoApi.MeteoApiClient mockApiClient;
    late WeatherRepo weatherRepo;
    final exception = Exception('oops');

    setUp(() {
      mockApiClient = MockMeteoApiClient();
      weatherRepo = WeatherRepo(meteoApiClient: mockApiClient);
    });

    group('constructor', () {
      test('internal meteo api client when not injected', () {
        expect(WeatherRepo(), isNotNull);
      });
    });

    group('getWeather', () {
      const city = 'chicago';
      const latitude = 41.85003;
      const longitude = -87.65005;

      test('1.Api locationSearch', () async {
        try {
          await weatherRepo.getWeather(city);
        } catch (_) {}
        verify(() => mockApiClient.locationSearch(city)).called(1);
      });

      test('2. throws exception', () {
        when(() => mockApiClient.locationSearch(any())).thenThrow(exception);
        expect(() async => weatherRepo.getWeather(city), throwsA(exception));
      });

      test('3. Repo&Api getWeather', () async {
        final mockLocation = MockLocation();
        when(() => mockLocation.latitude).thenReturn(latitude);
        when(() => mockLocation.longitude).thenReturn(longitude);
        when(() => mockApiClient.locationSearch(any()))
            .thenAnswer((_) async => mockLocation);
        try {
          await weatherRepo.getWeather(city);
        } catch (_) {}
        verify(() => mockApiClient.getWeather(
            latitude: latitude, longitude: longitude)).called(1);
      });

      test('4. throws getWeather exception', () {
        final mockLocation = MockLocation();
        when(() => mockLocation.latitude).thenReturn(latitude);
        when(() => mockLocation.longitude).thenReturn(longitude);
        when(() => mockApiClient.locationSearch(any()))
            .thenAnswer((_) async => mockLocation);
        when(() => mockApiClient.getWeather(
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
            )).thenThrow(exception);
        expect(() async => weatherRepo.getWeather(city), throwsA(exception));
      });

      test('5. returns clear Weather', () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(0);
        when(() => mockApiClient.locationSearch(any()))
            .thenAnswer((_) async => location);
        when(() => mockApiClient.getWeather(
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
            )).thenAnswer((_) async => weather);

        final actual = await weatherRepo.getWeather(city);
        expect(
            actual,
            Weather(
                location: city,
                temperature: 42.42,
                condition: Condition.clear));
      });

      test('6. returns cloudy Weather', () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(1);
        when(() => mockApiClient.locationSearch(any()))
            .thenAnswer((_) async => location);
        when(() => mockApiClient.getWeather(
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
            )).thenAnswer((_) async => weather);

        final actual = await weatherRepo.getWeather(city);
        expect(
            actual,
            Weather(
                location: city,
                temperature: 42.42,
                condition: Condition.cloudy));
      });
    });
  });
}
