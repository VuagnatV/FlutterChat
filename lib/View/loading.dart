import 'package:eferei2023gr109/View/my_background.dart';
import 'package:eferei2023gr109/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const MyBackground(),
          PageView(
            children: [
              Lottie.asset("assets/01.json"),
              Lottie.asset("assets/02.json"),
              Lottie.asset("assets/03.json"),
              const MyHomePage(title: "coucou")

            ],
          ),
        ],
      ),
    );
  }
}
