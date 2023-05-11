import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:weather/models/constants.dart';

import '../home/home_screen.dart';
// import 'package:weather/ui/welcome.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void requestPermission() async {
    LocationPermission permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus == LocationPermission.denied) {
      LocationPermission status = await Geolocator.requestPermission();
      if (status == PermissionStatus.denied) {
        // Permission denied
        SystemNavigator.pop();
      } else if (status == LocationPermission.always) {
        // fetchLocation();
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          forceAndroidLocationManager: true,
        );
        if (position != null) {
          log('Lat:${position.latitude},log:${position.longitude}');
        } else {
          log('not Available');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: myConstants.primaryColor.withOpacity(.5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/get-started.png'),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                child: Container(
                  height: 50,
                  width: size.width * 0.7,
                  decoration: BoxDecoration(
                    color: myConstants.primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Center(
                    child: Text(
                      'Get started',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
