import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF508D4E),
                  Color(0xFF80AF81),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30, // Slightly bigger size
                    backgroundImage: AssetImage('assets/green_leaf.png'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Greenhouse',
                    style: TextStyle(
                      fontSize: 24, // Increased font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White color
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'This app helps you monitor and control the environmental conditions of your greenhouse. '
                      'You can track temperature, humidity, and soil moisture levels to ensure optimal growth conditions for your plants.',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center, // Center justify the text
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white), // White color
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}