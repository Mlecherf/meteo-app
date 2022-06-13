import 'dart:convert';

import '../models/daily.dart';

import 'package:http/http.dart' as http;

import '../models/weekly.dart';

//3788670491baf2cb8bd1d0e95e6119e8

Future<Daily> getDailyDataAPI(String city) async {
  var url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=3788670491baf2cb8bd1d0e95e6119e8&units=metric&lang=fr");
  var response = await http.get(url);

  if (response.statusCode == 200) {
    return Daily.fromJson(json.decode(response.body));
  } else {
    return Future.error('error');
  }
}

Future<Weekly> getWeeklyDataAPI(double lat, double lon) async {
  var url = Uri.parse(
      "http://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&appid=3788670491baf2cb8bd1d0e95e6119e8&units=metric&exclude=minutely,hourly,current");
  var response = await http.get(url);

  if (response.statusCode == 200) {
    return Weekly.fromJson(json.decode(response.body));
  } else {
    return Future.error('error');
  }
}
