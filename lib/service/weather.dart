import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = "55931ddcbfe5cd1b4db7da7303b6a175";

Future<dynamic> getData(double lat, double lon) async {
  Uri url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=hourly,minutely&units=metric&appid=$apiKey");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  }
}
