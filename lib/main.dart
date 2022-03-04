import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_practise_app/network/location.dart';
import 'package:weather_practise_app/service/weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var data;
  var address;
  bool _isLoading = false;
  @override
  void initState() {
    _isLoading = true;
    Future.delayed(Duration.zero).then((value) async {
      Position position = await determinePosition();
      print(position);
      address = await getAddress(position);
      data = await getData(position.latitude, position.longitude);
      print(data);
      _isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  String getIcon(String description) {
    String url = '';
    if (description == "CLEAR SKY") {
      url = "assets/icons/wi-day-sunny.svg";
    } else if (description == "CLOUDY") {
      url = "assets/icons/wi-cloud.svg";
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          DateFormat.yMMMMEEEEd().format(DateTime.now()),
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            color: Colors.grey,
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : Container(
              height: height,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    address.toString(),
                    style: const TextStyle(fontSize: 28, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Text(
                    data['current']['weather'][0]['description']
                        .toString()
                        .toUpperCase(),
                    style: TextStyle(fontSize: 24, letterSpacing: 4),
                  ),
                  SizedBox(height: 20),
                  SvgPicture.asset(
                    getIcon(data['current']['weather'][0]['description']
                        .toString()
                        .toUpperCase()),
                    height: 80,
                    width: 80,
                  ),
                  SizedBox(height: 20),
                  Text.rich(TextSpan(
                      text: data['current']['temp'].toString(),
                      style: TextStyle(fontSize: 80),
                      children: [TextSpan(text: '°')])),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildColumn('max', data['daily'][0]['temp']['max']),
                      buildColumn('min', data['daily'][0]['temp']['min'])
                    ],
                  ),
                  Row(
                    children: [],
                  )
                ],
              ),
            ),
    );
  }

  Column buildColumn(String text, var data) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
        SizedBox(height: 10),
        Text.rich(
            TextSpan(text: data.toString(), children: [TextSpan(text: '°')]))
      ],
    );
  }
}
