import 'package:http/http.dart' as http;
import 'package:meteo_api/meteo_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResp extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('client', () {
    late http.Client mockHttpClient;
    late MeteoApiClient apiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      mockHttpClient = MockHttpClient();
      apiClient = MeteoApiClient(httpClient: mockHttpClient);
    });
    //client group - constructor
    group('constructor', () {
      test('does not require a mockHttpClient',
          () => expect(MeteoApiClient(), isNotNull));
    });
    //client -- Location
    group('locationSearch', () {
      const name = 'mock-query';

      test('1.makes correct http request', () async {
        final resp = MockResp();
        when(() => resp.statusCode).thenReturn(200);
        when(() => resp.body).thenReturn('{}');
        when(() => mockHttpClient.get(any())).thenAnswer((_) async => resp);
//https://geocoding-api.open-meteo.com/v1/search?name=mock-query&count=1
        try {
          await apiClient.locationSearch(name);
        } catch (_) {}
        verify(() {
          final host = 'geocoding-api.open-meteo.com';
          final path = '/v1/search';
          final param = {'name': name, 'count': '1'};
          final url = Uri.https(host, path, param);
          return mockHttpClient.get(url);
        }).called(1);
      });

      test('2.throws LocReqExc on non-200 resp', () async {
        final resp = MockResp();
        when(() => resp.statusCode).thenReturn(400);
        when(() => mockHttpClient.get(any())).thenAnswer((_) async => resp);
        expect(() async => apiClient.locationSearch(name),
            throwsA(isA<LocReqExc>()));
      });

      test('3.throws LocNotFoundExc on Err resp', () async {
        final resp = MockResp();
        when(() => resp.statusCode).thenReturn(200);
        when(() => resp.body).thenReturn('{}');
        when(() => mockHttpClient.get(any())).thenAnswer((_) async => resp);
        expect(() async => apiClient.locationSearch(name),
            throwsA(isA<LocNotFoundExc>()));
      });

      test('4.throws LocNotFoundExc on Empty resp', () async {
        final resp = MockResp();
        final jsonBody = '{"results": []}';
        when(() => resp.statusCode).thenReturn(200);
        when(() => resp.body).thenReturn(jsonBody);
        when(() => mockHttpClient.get(any())).thenAnswer((_) async => resp);
        expect(() async => apiClient.locationSearch(name),
            throwsA(isA<LocNotFoundExc>()));
      });

      test('5.on valid resp', () async {
        final resp = MockResp();
        final jsonBody = '''
{
  "results": [
    {
      "id": 4887398,
      "name": "Chicago",
      "latitude": 41.85003,
      "longitude": -87.65005
    }
  ]
}''';
        when(() => resp.statusCode).thenReturn(200);
        when(() => resp.body).thenReturn(jsonBody);
        when(() => mockHttpClient.get(any())).thenAnswer((_) async => resp);
        final actual = await apiClient.locationSearch(name);
        expect(
            actual,
            isA<Location>()
                .having((loc) => loc.id, 'id', 4887398)
                .having((loc) => loc.name, 'name', 'Chicago')
                .having((loc) => loc.latitude, 'latitude', 41.85003)
                .having((loc) => loc.longitude, 'longitude', -87.65005));
      });
    });

    //client group - Weather
    group('getWeather', () {
      const latitude = 41.85003;
      const longitude = -87.6500;

      test('6.makes correct http request', () async {
        final resp = MockResp();
        when(() => resp.statusCode).thenReturn(200);
        when(() => resp.body).thenReturn('{}');
        when(() => mockHttpClient.get(any())).thenAnswer((_) async => resp);
        try {
          await apiClient.getWeather(latitude: latitude, longitude: longitude);
        } catch (_) {}
        verify(() {
          final host = 'api.open-meteo.com';
          final path = '/v1/forecast';
          final param = {
            'latitude': latitude.toString(),
            'longitude': longitude.toString(),
            'current_weather': 'true'
          };
          final url = Uri.https(host, path, param);
          return mockHttpClient.get(url);
        }).called(1);
      });

      test('7.throws WeatherReqExc on non-200 resp', () async {
        final resp = MockResp();
        when(() => resp.statusCode).thenReturn(400);
        when(() => mockHttpClient.get(any())).thenAnswer((_) async => resp);
        expect(
            () async =>
                apiClient.getWeather(latitude: latitude, longitude: longitude),
            throwsA(isA<WeatherReqExc>()));
      });

      test('8.throws WeatherNotFoundExc on Empty resp', () async {
        final resp = MockResp();
        when(() => resp.statusCode).thenReturn(200);
        when(() => resp.body).thenReturn('{}');
        when(() => mockHttpClient.get(any())).thenAnswer((_) async => resp);
        expect(
            () async =>
                apiClient.getWeather(latitude: latitude, longitude: longitude),
            throwsA(isA<WeatherNotFoundExc>()));
      });

      test('9. returns Weather', () async {
        final resp = MockResp();
        final jsonBody = '''
{
"latitude": 43,
"longitude": -87.875,
"generationtime_ms": 0.2510547637939453,
"utc_offset_seconds": 0,
"timezone": "GMT",
"timezone_abbreviation": "GMT",
"elevation": 189,
"current_weather": {
"temperature": 15.3,
"windspeed": 25.8,
"winddirection": 310,
"weathercode": 63,
"time": "2022-09-12T01:00"
}
}
        ''';
        when(() => resp.statusCode).thenReturn(200);
        when(() => resp.body).thenReturn(jsonBody);
        when(() => mockHttpClient.get(any())).thenAnswer((_) async => resp);
        final actual = await apiClient.getWeather(
            latitude: latitude, longitude: longitude);
        expect(
            actual,
            isA<Weather>()
                .having((w) => w.temperature, 'temperature', 15.3)
                .having((w) => w.weatherCode, 'weatherCode', 63));
      });
    });
  });
}
