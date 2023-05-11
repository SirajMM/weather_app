import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/models/constants.dart';
import 'package:weather/presentation/home/widgets/weather_item.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

double temperature = 0;
double maxTemp = 0;
String weatherStateName = 'Loading...';
int humidity = 0;
double windSpeed = 0;
String? location = 'Loading...';
TextEditingController controller = TextEditingController();
var currentDate = 'Loading...';
String imageUrl = '';

class _HomeState extends State<Home> {
  Constants myConstants = Constants();

  @override
  void initState() {
    fetchLocation();

    super.initState();
  }

  //Create a shader linear gradient
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: size.width,
            child: CupertinoSearchTextField(
              // style: ,
              controller: controller,
              onSubmitted: (String s) {
                if (controller.text.isNotEmpty) {
                  loadingProgress(context);
                  setState(() {
                    location = s;
                    getCityWeather(s);
                  });
                  controller.clear();
                  Future.delayed(const Duration(milliseconds: 450), () {
                    Navigator.pop(context);
                  });
                } else {
                  const snackbar = SnackBar(
                    content: Text('Enter any city to Search'),
                    behavior: SnackBarBehavior.floating,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
              },
              placeholder: "Search Location ",
              prefixIcon: const Icon(CupertinoIcons.location),
            )),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      location!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () => fetchLocation(),
                      icon: const Icon(
                        Icons.my_location,
                      ),
                    )
                  ],
                ),
                Text(
                  currentDate,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 106, 241, 111),
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),

                /*  ==== Main Card ==== */
                DisplayCard(
                  size: size,
                  myConstants: myConstants,
                  linearGradient: linearGradient,
                ),
                const SizedBox(
                  height: 80,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DeatherItem(
                        text: 'Wind Speed',
                        value: windSpeed.toString(),
                        unit: 'km/h',
                        imageUrl: 'assets/windspeed.png',
                      ),
                      DeatherItem(
                          text: 'Humidity',
                          value: humidity.toString(),
                          unit: '⁒',
                          imageUrl: 'assets/humidity.png'),
                      DeatherItem(
                        text: 'Max Temp',
                        value: maxTemp.toStringAsFixed(3),
                        unit: '℃',
                        imageUrl: 'assets/max-temp.png',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<dynamic> loadingProgress(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const Center(
          child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.deepPurple,
      )),
    );
  }

  /*==== Searched city weather ====*/

  getCityWeather(String cityName) async {
    // final dio = Dio();
    var uri = "${domain}q=$cityName&appid=$apiKey";
    final client = http.Client();
    final url = Uri.parse(uri);
    final response = await client.get(url);
    try {
      log('STATUS CODE ()=>${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        final decodeData = json.decode(data);

        log("DECODE DATA ()=> $decodeData");
        updateUi(decodeData);
      } else {
        log('STATUS CODE ()=>${response.statusCode}');
        updateUi(null);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /*==== Get the current city weather ====*/

  getCurrentCityWeather(Position position) async {
    var uri =
        "${domain}lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey";
    final client = http.Client();
    final url = Uri.parse(uri);
    final response = await client.get(url);
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        final decodeData = json.decode(data);

        log(data.toString());
        log("DECODE DATA ()=> $decodeData");
        updateUi(decodeData);
      } else {
        log('STATUS CODE ()=>${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /*==== Fetch location ====*/

  void fetchLocation() async {
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );
    if (position != null) {
      getCurrentCityWeather(position);
      log('Lat:${position.latitude},log:${position.longitude}');
    } else {
      log('not Available');
    }
  }

  /*==== Update UI ====*/

  updateUi(decodeData) {
    log('hey');
    setState(() {
      if (decodeData == null) {
        temperature = 0;
        windSpeed = 0;
        humidity = 0;
        maxTemp = 0;
        imageUrl = '';
        currentDate = 'Not Available';
        weatherStateName = 'Not Available';
        location = 'Not Available';
      } else {
        temperature = decodeData['main']['temp'] - 273;
        windSpeed = decodeData['wind']['speed'];
        humidity = decodeData['main']['humidity'];
        imageUrl = decodeData['weather'][0]['icon'];
        location = decodeData['name'];
        maxTemp = decodeData['main']['temp_max'] - 273;
        currentDate = decodeData['sys']['country'];
        weatherStateName = decodeData['weather'][0]['description'];
      }
    });
  }
}
