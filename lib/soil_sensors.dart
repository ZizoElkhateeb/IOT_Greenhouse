import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';

class SoilSensors extends StatefulWidget {
  final String username;

  const SoilSensors({super.key, required this.username});
  _SoilSensorsState createState() => _SoilSensorsState();
}

class _SoilSensorsState extends State<SoilSensors>{

  final database = FirebaseDatabase.instance.ref();
    int currentSoil = 0;
    int currentWater = 0;

    @override
    void initState()
    {
      super.initState();
      _Listener();
    }

    void _Listener() {
    
    database
        .child("/Sensores/Water_Level/currentWater/")
        .onValue
        .listen((event) {
      final Object? read = event.snapshot.value;
      setState(() {
        currentWater = read as int;
      });
    });
    database
        .child("/Sensores/Soil_Moisture/currentSoil/")
        .onValue
        .listen((event) {
      final Object? read = event.snapshot.value;
      setState(() {
        currentSoil = read as int;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF508D4E), // Replace with actual colors from SignUpScreen
              Color(0xFF80AF81), // Replace with actual colors from SignUpScreen
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10), // Move the row down
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context, "username");
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0), // Increase padding
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Color(0xFF80AF81)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: const Text(
                      'Soil Sensors',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .white, // This color will be overridden by the ShaderMask
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
                height: 30), // Add spacing between avatar and welcome message
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ParameterWidget(
                  title: 'Water Level',
                  value: currentWater==10? "<=10 mm" : "$currentWater mm",
                  icon: Icons.water,
                ),
                _ParameterWidget(
                  title: 'Soil Moisture',
                  value: '$currentSoil%', // Replace with actual soil moisture value
                  icon: Icons.grass,
                ),
              ],
            ),
            const SizedBox(height: 10), // Add spacing between graphs
            const Text(
              'Water Level',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            // Add the graphs
            Expanded(
              child: Column(
                children: [
                  // Water Level graph
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                FlSpot(1, currentWater.toDouble()), // Water Level
                                FlSpot(2, currentWater.toDouble()),
                                FlSpot(3, currentWater.toDouble()),
                                FlSpot(4, currentWater.toDouble()),
                                FlSpot(5, currentWater.toDouble()),
                              ],
                              isCurved: true,
                              color: Colors.blue[400],
                              barWidth: 2,
                              dotData: const FlDotData(
                                show: true,
                              ),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            show: true,
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                reservedSize: 30,
                                showTitles: true, // Show Water Level on left
                                getTitlesWidget: (value, meta) {
                                  return Text(value.toInt().toString(),
                                      style:
                                          const TextStyle(color: Colors.white));
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameWidget: const Text('min',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)),
                              sideTitles: SideTitles(
                                showTitles: true, // Show time on bottom
                                getTitlesWidget: (value, meta) {
                                  return Text(value.toInt().toString(),
                                      style: const TextStyle(color: Colors.white));
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false, // Hide right titles
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false, // Hide top titles
                              ),
                            ),
                          ),
                          gridData: const FlGridData(
                            show: true,
                          ),
                          minY: 0,
                          maxY: 50,
                          minX: 1,
                          maxX: 9,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10), // Add spacing between graphs
                  const Text(
                    'Soil Moisture',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  // Soil Moisture graph
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                 FlSpot(1, currentSoil.toDouble()), // Soil Moisture
                                 FlSpot(2, currentSoil.toDouble()),
                                 FlSpot(3, currentSoil.toDouble()),
                                 FlSpot(4, currentSoil.toDouble()),
                                 FlSpot(5, currentSoil.toDouble()),
                              ],
                              isCurved: true,
                              color: Colors.yellowAccent,
                              barWidth: 2,
                              dotData: const FlDotData(
                                show: true,
                              ),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            show: true,
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                reservedSize: 30,
                                showTitles: true, // Show Soil Moisture on left
                                getTitlesWidget: (value, meta) {
                                  return Text(value.toInt().toString(),
                                      style:
                                          const TextStyle(color: Colors.white));
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              axisNameWidget: const Text('min',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)),
                              sideTitles: SideTitles(
                                showTitles: true, // Show time on bottom
                                getTitlesWidget: (value, meta) {
                                  return Text(value.toInt().toString(),
                                      style: const TextStyle(color: Colors.white));
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false, // Hide right titles
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false, // Hide top titles
                              ),
                            ),
                          ),
                          gridData: const FlGridData(
                            show: true,
                          ),
                          minY: 0,
                          maxY: 100,
                          minX: 1,
                          maxX: 9,
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
    );
  }
}

// Custom widget to display a single parameter
class _ParameterWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ParameterWidget(
      {required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.white),
        Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}
