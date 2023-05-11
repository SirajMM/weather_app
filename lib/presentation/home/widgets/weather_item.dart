import 'package:flutter/material.dart';
import '../../../models/constants.dart';
import '../home_screen.dart';

class DeatherItem extends StatelessWidget {
  const DeatherItem({
    Key? key,
    required this.value,
    required this.text,
    required this.unit,
    required this.imageUrl,
  }) : super(key: key);

  final String value;
  final String text;
  final String unit;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            color: Color(0xffE0E8FB),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Image.asset(imageUrl),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value.toString() + unit,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class DisplayCard extends StatelessWidget {
  const DisplayCard({
    Key? key,
    required this.size,
    required this.myConstants,
    required this.linearGradient,
  }) : super(key: key);

  final Size size;
  final Constants myConstants;
  final Shader linearGradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: 200,
      decoration: BoxDecoration(
          color: myConstants.primaryColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: myConstants.primaryColor.withOpacity(.5),
              offset: const Offset(0, 25),
              blurRadius: 10,
              spreadRadius: -12,
            )
          ]),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -70,
            left: 20,
            child: imageUrl == null || imageUrl.isEmpty
                ? const Text('')
                : Image.asset(
                    'assets/' + imageUrl + '.png',
                    errorBuilder: (context, error, stackTrace) => Container(),
                    width: 150,
                  ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: Text(
              weatherStateName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    temperature.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()..shader = linearGradient,
                    ),
                  ),
                ),
                Text(
                  'o',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..shader = linearGradient,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
