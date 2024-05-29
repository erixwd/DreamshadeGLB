import 'package:flutter/material.dart';
import 'package:tint_changer/Pages/homepage.dart';

void main() {
  runApp(MaterialApp(
    title: 'Dreamshade',
    debugShowCheckedModeBanner: false,
    home: const Homepage(
      endTime: 5.3,
      startTime: 20.75,
      gradientLength: 0.5, // Adjust this value to control the distance for Point C
    ),
  ));
}
