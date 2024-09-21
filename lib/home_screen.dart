// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenhouse/auth.dart';
import 'package:greenhouse/input_screen.dart';
import 'package:greenhouse/login_screen.dart';
import 'package:greenhouse/soil_sensors.dart';
import 'package:greenhouse/weather_sensor.dart'; // Ensure this import is correct and the file exists

import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  final dynamic username;

  const HomeScreen({super.key, required this.username});
  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  final database = FirebaseDatabase.instance.ref();
  String currentTemp = "Current Temprature";
  String currentHumi = "Current Humidity";
  String currentSoil = "Current Soil Moistuer";
  String currentWater = "Current Water Level";
  String name = "username";
  @override
  void initState() {
    super.initState();
    _Listener();
    getUserName();
  }

  void _Listener() {
    database.child("/Sensores/Temprature/currentTemp/").onValue.listen((event) {
      final Object? read = event.snapshot.value;
      setState(() {
        currentTemp = 'Temperature: $read°C';
      });
    });
    database
        .child("/Sensores/Water_Level/currentWater/")
        .onValue
        .listen((event) {
      final Object? read = event.snapshot.value;
      setState(() {
        if (read == 10) {
        currentWater = 'Water Level: <=10 mm';
      } else {
        currentWater = 'Water Level: $read mm';
      }  
      });
    });
    database.child("/Sensores/Humidity/currentHumi/").onValue.listen((event) {
      final Object? read = event.snapshot.value;
      setState(() {
        currentHumi = 'Humidity: $read%';
      });
    });
    database
        .child("/Sensores/Soil_Moisture/currentSoil/")
        .onValue
        .listen((event) {
      final Object? read = event.snapshot.value;
      setState(() {
        currentSoil = 'Soil Moisture: $read%';
      });
    });
  }

  void getUserName() async {
    try {
      final DatabaseEvent event = await database
          .child("Users")
          .orderByChild('email')
          .equalTo(widget.username)
          .once();
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.exists) {
        final userdata = snapshot.value as Map<dynamic, dynamic>;
        final user = userdata.values.first as Map<dynamic, dynamic>;
        setState(() {
          name = user["username"];
        });
      } else {
        setState(() {
          name = "user not found";
        });
      }
    } catch (e) {
      return null;
    }
  }

  Widget _show_temp() {
    return Text(
      currentTemp, // Replace with actual temperature reading
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    );
  }

  Widget _show_humi() {
    return Text(
      currentHumi, // Replace with actual humidity reading
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    );
  }

  Widget _show_water() {
    return Text(
      currentWater, // Replace with actual water level reading
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    );
  }

  Widget _show_soil() {
    return Text(
      currentSoil, // Replace with actual soil moisture reading
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(
                      0xFF508D4E), // Replace with actual colors from SignUpScreen
                  Color(
                      0xFF80AF81), // Replace with actual colors from SignUpScreen
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                  ),
                  const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Color(0xFF80AF81)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'Greenhouse',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors
                        .white, // This color will be overridden by the ShaderMask
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 120), // Move the row down
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50, // Increase avatar size
                      backgroundColor:
                          Colors.transparent, // Set background to transparent
                      backgroundImage: AssetImage('assets/green_leaf.png'),
                    ),
                    const SizedBox(
                        height: 8), // Add some space between avatar and text
                    Text(
                      'Welcome, ${name}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                        height:
                            50), // Add some space before the sensor readings
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WeatherSensors(username: widget.username)));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.symmetric(horizontal: 40.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.thermostat, color: Colors.white),
                                SizedBox(width: 8),
                                _show_temp(),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.water_drop, color: Colors.white),
                                SizedBox(width: 8),
                                _show_humi(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                        height:
                            20), // Add some space before the next sensor readings
                    GestureDetector(
                      onTap: () {
                        // Handle button tap
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SoilSensors(username: name)));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.symmetric(horizontal: 40.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.opacity, color: Colors.white),
                                SizedBox(width: 8),
                                _show_water(),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.grass, color: Colors.white),
                                SizedBox(width: 8),
                                _show_soil(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 20), // Add some space before the edit button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const InputScreen()));
                      },
                      child: const Column(
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(height: 8),
                          Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
