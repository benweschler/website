import 'package:flutter/material.dart';
import 'package:website/screens/global_header.dart';
import 'package:website/screens/landing_page/landing_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              const LandingPage(),
            ]
                // Allow each page to fill a container the size of the screen.
                .map((page) => SizedBox.fromSize(
                      size: MediaQuery.of(context).size,
                      child: page,
                    ))
                .toList(),
          ),
          Positioned(top: 30, right: 30, left: 30, child: GlobalHeader()),
        ],
      ),
    );
  }
}
