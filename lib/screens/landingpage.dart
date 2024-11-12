import 'dart:async';

import 'package:dtt_real_estate/screens/Homepage.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE65541),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
                'assets/Images/dtt_launcher.png'), //Adding the baground removed icon
          )),
        ));
  }
}
