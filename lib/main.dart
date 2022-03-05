import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_practise_app/network/location.dart';
import 'package:weather_practise_app/service/weather.dart';
import 'package:weather_practise_app/settings.dart';

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
  var icon = '';
  String url = '';
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController city = TextEditingController();

  void getCity() async {
    data = await getData(address);
    icon = data['weather'][0]['icon'];
    url = 'http://openweathermap.org/img/wn/$icon@2x.png';
    _isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(Duration.zero).then((value) async {
      Position position = await determinePosition();
      address = await getAddress(position);
      getCity();
    });
    super.initState();
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
          PopupMenuButton(
            initialValue: 0,
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 1,
                  child: Text('Change City'),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text('Settings'),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 1) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Change City'),
                        content: Form(
                          key: key,
                          child: TextFormField(
                            controller: city,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'City cannot be empty';
                              }
                              key.currentState!.save();
                              address = city.text;
                              setState(() {});
                            },
                            decoration:
                                const InputDecoration(hintText: 'Enter City'),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black),
                              onPressed: () {
                                if (key.currentState!.validate()) {
                                  Navigator.of(context).pop();
                                  _isLoading = true;
                                  getCity();
                                }
                              },
                              child: const Text('Change'))
                        ],
                      );
                    });
              } else {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              }
            },
            icon: const Icon(Icons.more_vert, color: Colors.grey),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                height: height,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.1),
                    Text(
                      data['name'],
                      style: const TextStyle(fontSize: 28, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      data['weather'][0]['description']
                          .toString()
                          .toUpperCase(),
                      style: const TextStyle(fontSize: 24, letterSpacing: 4),
                    ),
                    const SizedBox(height: 20),
                    Image.network(url),
                    const SizedBox(height: 20),
                    Text.rich(TextSpan(
                        text: data['main']['temp'].toString().substring(
                            0, data['main']['temp'].toString().indexOf('.')),
                        style: const TextStyle(fontSize: 100),
                        children: const [TextSpan(text: '°')])),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildColumn('max', data['main']['temp_max']),
                        const VerticalDividerWidget(),
                        buildColumn('min', data['main']['temp_min'])
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: Colors.grey,
                      endIndent: 20,
                      indent: 20,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'wind speed',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                            const SizedBox(height: 10),
                            Text(data['wind']['speed'].toString() + ' m/s',
                                style: const TextStyle(fontSize: 16))
                          ],
                        ),
                        const VerticalDividerWidget(),
                        Column(
                          children: [
                            const Text(
                              'sunrise',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                            const SizedBox(height: 10),
                            Text(
                                DateFormat.Hm()
                                        .format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                data['sys']['sunrise']))
                                        .toString() +
                                    ' AM',
                                style: const TextStyle(fontSize: 16))
                          ],
                        ),
                        const VerticalDividerWidget(),
                        Column(
                          children: [
                            Text(
                              'sunset',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 20),
                            ),
                            const SizedBox(height: 10),
                            Text(
                                DateFormat.Hm()
                                        .format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                data['sys']['sunset']))
                                        .toString() +
                                    ' PM',
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const VerticalDividerWidget(),
                        Column(
                          children: [
                            const Text(
                              'humidity',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                            const SizedBox(height: 10),
                            Text(data['main']['humidity'].toString() + ' %',
                                style: const TextStyle(fontSize: 16))
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Column buildColumn(String text, var data) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(color: Colors.grey, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text.rich(TextSpan(
            text: data.toString(), children: const [TextSpan(text: '°')]))
      ],
    );
  }
}

class VerticalDividerWidget extends StatelessWidget {
  const VerticalDividerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 35,
      child: VerticalDivider(
        color: Colors.grey,
        thickness: 2,
        indent: 5,
        endIndent: 0,
        width: 20,
      ),
    );
  }
}
