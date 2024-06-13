import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insideout/signup/Signup.dart';
import 'package:insideout/style.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class MentalDegree extends StatefulWidget {
  const MentalDegree({super.key});

  @override
  State<MentalDegree> createState() => _MentalDegreeState();
}

Widget mainButton(String text, Function() func) {
  return SizedBox(
    child: ElevatedButton(
      onPressed: () {
        debugPrint("function: $func");
        func(); // 여기를 수정해서 func가 실행되도록 합니다.
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorStyle.mainColor1,
        minimumSize: Size(100, 50), // Width and height of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: ColorStyle.bgColor1,
          fontSize: 18, // Adjust the font size as needed
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

class _MentalDegreeState extends State<MentalDegree> {
  bool isCheck = false;

  @override
  void initState() {
    super.initState();
    context.read<ApplicationState>().fetchMentalHealthData();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    return Scaffold(
      backgroundColor: ColorStyle.bgColor1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorStyle.mainColor2,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  Text(
                    '나의 멘탈지수는?',
                    style: MyTextStyles.smallTitleTextStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${appState.mental}',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      mainButton('설문조사버튼', () => context.go("/test")),
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
                  /*
                  SizedBox(height: 32),
                  Text(
                    '성실도 그래프',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  DiligenceChart(),*/
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: isCheck,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheck = value!;
                          });
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
    var appState = context.watch<ApplicationState>();

    // Extract unique categories
    final categories = appState.mentalHealthDataList
        .map((data) => data.category)
        .toList();

    return Container(
      decoration: BoxDecorationStyle.graphBox1,
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    final category = categories[value.toInt()];
                    final displayCategory = category.contains('(')
                        ? category.split('(')[0]
                        : category;
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        displayCategory,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                  reservedSize: 30,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
            ),
            barGroups: appState.mentalHealthDataList.asMap().entries.map(
                  (entry) {
                final index = entry.key;
                final data = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      fromY: 0,
                      toY: data.value.toDouble(),
                      color: Colors.green,
                    ),
                  ],
                );
              },
            ).toList(),
          ),
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
      decoration: BoxDecorationStyle.graphBox2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barGroups: [
              BarChartGroupData(x: 0, barRods: [
                BarChartRodData(
                    fromY: 0, toY: 20, color: Colors.lightBlue[100]!),
                BarChartRodData(
                    fromY: 0, toY: 25, color: Colors.lightBlue[300]!),
                BarChartRodData(
                    fromY: 0, toY: 22, color: Colors.lightBlue[500]!),
                BarChartRodData(
                    fromY: 0, toY: 24, color: Colors.lightBlue[700]!),
              ]),
              BarChartGroupData(x: 5, barRods: [
                BarChartRodData(
                    fromY: 0, toY: 20, color: Colors.lightBlue[100]!),
                BarChartRodData(
                    fromY: 0, toY: 25, color: Colors.lightBlue[300]!),
                BarChartRodData(
                    fromY: 0, toY: 22, color: Colors.lightBlue[500]!),
                BarChartRodData(
                    fromY: 0, toY: 24, color: Colors.lightBlue[700]!),
              ]),
              BarChartGroupData(x: 10, barRods: [
                BarChartRodData(
                    fromY: 0, toY: 20, color: Colors.lightBlue[100]!),
                BarChartRodData(
                    fromY: 0, toY: 25, color: Colors.lightBlue[300]!),
                BarChartRodData(
                    fromY: 0, toY: 22, color: Colors.lightBlue[500]!),
                BarChartRodData(
                    fromY: 0, toY: 24, color: Colors.lightBlue[700]!),
              ]),
              BarChartGroupData(x: 15, barRods: [
                BarChartRodData(
                    fromY: 0, toY: 20, color: Colors.lightBlue[100]!),
                BarChartRodData(
                    fromY: 0, toY: 25, color: Colors.lightBlue[300]!),
                BarChartRodData(
                    fromY: 0, toY: 22, color: Colors.lightBlue[500]!),
                BarChartRodData(
                    fromY: 0, toY: 24, color: Colors.lightBlue[700]!),
              ]),
              // Add more BarChartGroupData here
            ],
          ),
        ),
      ),
    );
  }
}
