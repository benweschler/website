import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:website/style/theme.dart';
import 'package:website/widgets/responsive_button.dart';

class UnderConstructionScreen extends StatefulWidget {
  final VoidCallback validateAdmin;

  const UnderConstructionScreen({super.key, required this.validateAdmin});

  @override
  State<UnderConstructionScreen> createState() =>
      _UnderConstructionScreenState();
}

class _UnderConstructionScreenState extends State<UnderConstructionScreen> {
  // HAHA you sneaky sneaker. Checking the source code to try and get in smh...
  // Try breaking SHA256 n00b :)
  final _magicWordHash =
      'd2a27049b0b146881e0c7bb4e760704ee9689f5c21c3f6279c6529fb66cca8ac';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validate() {
    final inputBytes = utf8.encode(_controller.value.text);
    final inputHash = sha256.convert(inputBytes);
    if (inputHash.toString() == _magicWordHash) {
      widget.validateAdmin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'This website is under construction and is waiting for DNS propagation, but it won\'t be for long! Check back the morning of October 7th.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.25,
                  letterSpacing: 1.33,
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Are you an admin and want to get in? What\'s the magic word then...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.25,
                  letterSpacing: 1.33,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 500,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Are you magic?',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    ResponsiveButton(
                      onClicked: _validate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: AppColors.of(context).headerColor,
                        ),
                        child: const Text(
                          'Validate',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            height: 1.25,
                            letterSpacing: 1.33,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
