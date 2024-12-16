import 'package:flutter/material.dart';
import 'package:foodly/Screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _logoOpacity = 0.0;
  double _textOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Initial delay
    setState(() {
      _logoOpacity = 1.0;
    });

    await Future.delayed(
        const Duration(milliseconds: 800)); // Wait for logo animation
    setState(() {
      _textOpacity = 1.0;
    });

    await Future.delayed(
        const Duration(milliseconds: 1000)); // End of animation
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    // Navigate to the next screen after the splash animation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FoodlyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align the content to the top
          children: [
            SizedBox(height: 250), // Add some space from the top
            AnimatedOpacity(
              opacity: _logoOpacity,
              duration: const Duration(milliseconds: 1000),
              child: Image.asset(
                'assets/Logonew.png', // Path to your image
                height: 130,
                width: 130,
              ),
            ),
            const SizedBox(height: 10),
            AnimatedOpacity(
              opacity: _textOpacity,
              duration: const Duration(milliseconds: 500),
              child: const Text(
                'Foodly',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: Color(0xFFFF4B3E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
