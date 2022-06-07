import 'dart:convert';

import '../models/openweathermap.dart';

import 'package:http/http.dart' as http;

Future<Openweathermap> getDataAPI(String city) async {
  Openweathermap dataCity;

  final queryParameters = {
    'q': city,
    'appid': '3788670491baf2cb8bd1d0e95e6119e8',
    'units': 'metric',
    'lang': 'fr'
  };

  var url =
      Uri.https("api.openweathermap.org/data/2.5/weather", "", queryParameters);
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var jsonReponse = jsonDecode(response.body);
    dataCity = Openweathermap(jsonReponse['weather'], jsonReponse['main']);

    /// BLABLABLA
  } else {
    //print('Request failed with status: ${response.statusCode}.');
    return Future.error('error');
  }
  return (dataCity);
}
