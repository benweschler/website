import 'package:flutter/material.dart';

class LayoverPartyPage extends StatelessWidget {
  const LayoverPartyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Layover Party',
                  style: TextStyle(
                    fontFamily: 'Libre Baskerville',
                    color: Colors.white,
                    fontSize: 36,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }
}
