import 'package:flutter/material.dart';
import 'package:tint_changer/Pages/homepage.dart';

void main() {
  runApp(MaterialApp(
    title: 'Dreamshade',
    debugShowCheckedModeBanner: false,
    home: Homepage(
      amplitude: 80.0,
      waveLengthFactor: 2, // Adjust this factor as needed
      gradientControl: 0.8,
      gradientEndColor: Color.fromARGB(255, 194, 226, 238),
      gradientStartColor: Color.fromARGB(255, 243, 150, 63),
      customHour: 14,
      customMinute: 30,
    ),
  ));
}