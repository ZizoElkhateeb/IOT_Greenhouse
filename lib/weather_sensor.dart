import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';

class WeatherSensors extends StatefulWidget {
  final String username;

  const WeatherSensors({super.key, required this.username});
  _WeatherSensorsStates createState() => _WeatherSensorsStates();
}

class _WeatherSensorsStates extends State<WeatherSensors>
{
  final database = FirebaseDatabase.instance.ref();
  int currentTemp = 0;
  int currentHumi = 0;

    @override
    void initState()
    {
      super.initState();
      _Listener();
    }

    void _Listener() {
    database.child("/Sensores/Temprature/currentTemp/").onValue.listen((event) {
      final Object? read = event.snapshot.value;
      setState(() {
        currentTemp = read as int;
      });
    });
    database.child("/Sensores/Humidity/currentHumi/").onValue.listen((event) {
      final Object? read = event.snapshot.value;
      setState(() {
        currentHumi = read as int;
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
                    Navigator.pop(context, 'username');
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
                      'Weather Sensors',
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
                  title: 'Temperature',
                  value: "$currentTemp°C", // Replace with actual temperature value
                  icon: Icons.thermostat,
                ),
                _ParameterWidget(
                  title: 'Humidity',
                  value: '$currentHumi%', // Replace with actual humidity value
                  icon: Icons.water_drop,
                ),
              ],
            ),
            const SizedBox(height: 10), // Add spacing between graphs
            const Text(
              'Temperature',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            // Add the graphs
            Expanded(
              child: Column(
                children: [
                  // Temperature graph
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                FlSpot(1, currentTemp.toDouble()), // Temperature
                                FlSpot(2, currentTemp.toDouble()),
                                FlSpot(3, currentTemp.toDouble()),
                                FlSpot(4, currentTemp.toDouble()),
                                FlSpot(5, currentTemp.toDouble()),
                              ],
                              isCurved: true,
                              color: Colors.red[400],
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
                                showTitles: true, // Show temperature on left
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
                          maxY: 80,
                          minX: 1,
                          maxX: 9,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10), // Add spacing between graphs
                  const Text(
                    'Humidity',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  // Humidity graph
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                FlSpot(1, currentHumi.toDouble()), // humi
                                FlSpot(2, currentHumi.toDouble()),
                                FlSpot(3, currentHumi.toDouble()),
                                FlSpot(4, currentHumi.toDouble()),
                                FlSpot(5, currentHumi.toDouble()),
                              ],
                              isCurved: true,
                              color: Colors.blue[200],
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
                                showTitles: true, // Show Humidity on left
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
