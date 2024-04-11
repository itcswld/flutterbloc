import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meteo_api/meteo_api.dart';

class LocReqExc implements Exception {}

class LocNotFoundExc implements Exception {}

class WeatherReqExc implements Exception {}

class WeatherNotFoundExc implements Exception {}

//`/v1/search/?name=(query)`
class MeteoApiClient {
  late final http.Client _httpClient;
  MeteoApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<Location> locationSearch(String query) async {
    final _host = 'geocoding-api.open-meteo.com';
    final String _path = '/v1/search';
    Map<String, String> _param = {'name': query, 'count': '1'};
    final url = Uri.https(_host, _path, _param);
    final resp = await _httpClient.get(url);
    if (resp.statusCode != 200) throw LocReqExc();

    final json = jsonDecode(resp.body) as Map;
    if (!json.containsKey('results')) throw LocNotFoundExc();
    final locJson = json['results'] as List;
    if (locJson.isEmpty) throw LocNotFoundExc();
    return Location.fromJson(locJson.first as Map<String, dynamic>);
  }

  Future<Weather> getWeather(
      {required double latitude, required double longitude}) async {
    String _host = 'api.open-meteo.com';
    String _path = '/v1/forecast';
    Map<String, String> _param = {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current_weather': 'true'
    };
    final _url = Uri.https(_host, _path, _param);
    final weatherResp = await _httpClient.get(_url);
    if (weatherResp.statusCode != 200) throw WeatherReqExc();
    final json = jsonDecode(weatherResp.body) as Map<String, dynamic>;
    if (!json.containsKey('current_weather')) throw WeatherNotFoundExc();
    final weatherJson = json['current_weather'] as Map<String, dynamic>;
    return Weather.fromJson(weatherJson);
  }
}
