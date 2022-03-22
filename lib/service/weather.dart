import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = "55931ddcbfe5cd1b4db7da7303b6a175";

Future<dynamic> getData(String locality) async {
  Uri url = Uri.parse(
      "http://api.openweathermap.org/data/2.5/weather?q=${locality}&units=metric&appid=$apiKey");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  }
}
