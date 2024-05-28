import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:insideout/mainpage.dart';
class MentalDegree extends StatefulWidget {
  const MentalDegree({super.key});

  @override
  State<MentalDegree> createState() => _MentalDegreeState();
}

class _MentalDegreeState extends State<MentalDegree> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('멘탈지수'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '나의 멘탈지수는?',
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '100',
                        style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add your onPressed code here!

                        },
                        child: Text('설문조사버튼'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '멘탈지수 그래프',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  MentalHealthChart(),
                  SizedBox(height: 32),
                  Text(
                    '성실도 그래프',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  DiligenceChart(),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: isCheck,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheck = value!;
                          });
                          // Handle checkbox state change
                        },
                      ),
                      Text('조금 더 분발하세요'),
                    ],
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

class MentalHealthChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(fromY: 0,toY: 10, color: Colors.green, ),
              BarChartRodData(fromY: 0,toY: 8, color: Colors.orange, ),
              BarChartRodData(fromY: 0,toY: 6, color: Colors.red, ),
            ]),
            BarChartGroupData(x: 5, barRods: [
              BarChartRodData(fromY: 0,toY: 10, color: Colors.green, ),
              BarChartRodData(fromY: 0,toY: 8, color: Colors.orange, ),
              BarChartRodData(fromY: 0,toY: 6, color: Colors.red, ),
            ]),
            BarChartGroupData(x: 10, barRods: [
              BarChartRodData(fromY: 0,toY: 10, color: Colors.green, ),
              BarChartRodData(fromY: 0,toY: 8, color: Colors.orange, ),
              BarChartRodData(fromY: 0,toY: 6, color: Colors.red, ),
            ]),
            BarChartGroupData(x: 15, barRods: [
              BarChartRodData(fromY: 0,toY: 10, color: Colors.green, ),
              BarChartRodData(fromY: 0,toY: 8, color: Colors.orange, ),
              BarChartRodData(fromY: 0,toY: 6, color: Colors.red, ),
            ]),
            // Add more BarChartGroupData here
          ],
        ),
      ),
    );
  }
}

class DiligenceChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(fromY: 0, color: Colors.grey, toY: 20),
              BarChartRodData(fromY: 0, color: Colors.grey[400]!, toY: 25),
              BarChartRodData(fromY: 0, color: Colors.grey[600]!, toY: 22),
              BarChartRodData(fromY: 0, color: Colors.grey[800]!, toY: 24),
            ]),
            BarChartGroupData(x: 5, barRods: [
              BarChartRodData(fromY: 0, color: Colors.grey, toY: 20),
              BarChartRodData(fromY: 0, color: Colors.grey[400]!, toY: 25),
              BarChartRodData(fromY: 0, color: Colors.grey[600]!, toY: 22),
              BarChartRodData(fromY: 0, color: Colors.grey[800]!, toY: 24),
            ]),
            BarChartGroupData(x: 10, barRods: [
              BarChartRodData(fromY: 0, color: Colors.grey, toY: 20),
              BarChartRodData(fromY: 0, color: Colors.grey[400]!, toY: 25),
              BarChartRodData(fromY: 0, color: Colors.grey[600]!, toY: 22),
              BarChartRodData(fromY: 0, color: Colors.grey[800]!, toY: 24),
            ]),
            BarChartGroupData(x: 15, barRods: [
              BarChartRodData(fromY: 0, color: Colors.grey, toY: 20),
              BarChartRodData(fromY: 0, color: Colors.grey[400]!, toY: 25),
              BarChartRodData(fromY: 0, color: Colors.grey[600]!, toY: 22),
              BarChartRodData(fromY: 0, color: Colors.grey[800]!, toY: 24),
            ]),
            // Add more BarChartGroupData here
          ],
        ),
      ),
    );
  }
}