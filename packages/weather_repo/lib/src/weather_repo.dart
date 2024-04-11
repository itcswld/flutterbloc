import 'package:meteo_api/meteo_api.dart' hide Weather;
import 'package:weather_repo/weather_repo.dart';

class WeatherRepo {
  final MeteoApiClient _meteoApiClient;
  WeatherRepo({MeteoApiClient? meteoApiClient})
      : _meteoApiClient = meteoApiClient ?? MeteoApiClient();

  Future<Weather> getWeather(String city) async {
    final loc = await _meteoApiClient.locationSearch(city);
    final weather = await _meteoApiClient.getWeather(
      latitude: loc.latitude,
      longitude: loc.longitude,
    );
    return Weather(
      location: loc.name,
      temperature: weather.temperature,
      condition: weather.weatherCode.toInt().getCondition,
    );
  }
}

extension on int {
  Condition get getCondition {
    switch (this) {
      case 0:
        return Condition.clear;
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return Condition.cloudy;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return Condition.rainy;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return Condition.snowy;
      default:
        return Condition.unknown;
    }
  }
}
