import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  double _temperature = 0;
  double _humidity = 0;
  double _moisture = 0;
  final database = FirebaseDatabase.instance.ref();
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
                  const Text(
                    'Settings Control',
                    style: TextStyle(
                      fontSize: 24, // Increased font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White color
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/green_leaf.png',
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Colors.white), // White color
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 220.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildSlider('Temperature', _temperature, (value) {
                  setState(() {
                    _temperature = value;
                  });
                }),
                _buildSlider('Humidity', _humidity, (value) {
                  setState(() {
                    _humidity = value;
                  });
                }),
                _buildSlider('Moisture', _moisture, (value) {
                  setState(() {
                    _moisture = value;
                  });
                }),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF80AF81),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(
                        color: Color(0xFF80AF81),
                        width: 2,
                      ),
                    ),
                  ),
                  onPressed: () async{
                    final user_inputs = database.child("/user_inputs/");
                    await user_inputs.update(
                      {
                        "humi" : _humidity
                      }
                    );
                    await user_inputs.update(
                      {
                        "temp" : _temperature
                      }
                    );
                    await user_inputs.update(
                      {
                        "soil" : _moisture
                      }
                    );
                    
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
      String title, double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ${value.toInt()}',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 100,
            label: value.toInt().toString(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
