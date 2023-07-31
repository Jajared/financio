import 'package:financio/models/personal_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PersonalCategoryChart extends StatefulWidget {
  final List<PersonalModel> transactionData;
  final String type;
  const PersonalCategoryChart(
      {required this.transactionData, required this.type, Key? key})
      : super(key: key);

  @override
  PersoanlCategoryChartState createState() => PersoanlCategoryChartState();
}

class PersoanlCategoryChartState extends State<PersonalCategoryChart> {
  int touchedIndex = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.transactionData.isEmpty) {
      // If transactionData is empty, show a default "No Chart Data" pie chart section
      return const Center(
        child: Text(
          'No Chart Data',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: 1,
        child: AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              sections: showingSections(),
            ),
          ),
        ),
      );
    }
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> generateSections(transactionData) {
      List<PieChartSectionData> sections = [];
      Map<String, Color> sectionColors = {
        'Transport': Colors.blue,
        'Food': Colors.red,
        'Shopping': Colors.orange,
        'Entertainment': Colors.purple,
        'Travel': Colors.yellow,
        'Health': Colors.pink,
        'Education': Colors.green,
        'Other': Colors.grey,
        'Salary': Colors.green,
        'Investment': Colors.blue,
        'Gift': Colors.green,
        'Other Income': Colors.grey,
      };
      Map<String, double> categoryMap = {};
      transactionData.forEach((element) {
        if (categoryMap.containsKey(element.category)) {
          categoryMap[element.category] =
              categoryMap[element.category]! + element.amount;
        } else {
          categoryMap[element.category] = element.amount;
        }
      });
      double total = 0;
      categoryMap.forEach((key, value) {
        if (widget.type == "Income" ? value < 0 : value > 0) {
          total += value.toDouble();
        }
      });
      categoryMap.forEach((key, value) {
        if (widget.type == "Income" ? value < 0 : value > 0) {
          sections.add(PieChartSectionData(
            color: sectionColors[key],
            value: value / total * 100,
            title: value.toString(),
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(255, 255, 255, 0.96),
            ),
            badgeWidget: _Badge(
              key,
              size: 40,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: 1,
          ));
        }
      });
      return sections;
    }

    List<PieChartSectionData> sections =
        generateSections(widget.transactionData);

    return List.generate(sections.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      // final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: sections[i].color,
        value: sections[i].value,
        title: '${sections[i].value.toStringAsFixed(2)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
        badgeWidget: sections[i].badgeWidget,
        badgePositionPercentageOffset:
            sections[i].badgePositionPercentageOffset,
        titlePositionPercentageOffset: 0.55,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.category, {
    required this.size,
    required this.borderColor,
  });
  final String category;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: PieChart.defaultDuration,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(56, 56, 56, 1),
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(135, 57, 249, 0.9),
              offset: Offset(3, 3),
              blurRadius: 3,
            ),
          ],
        ),
        padding: EdgeInsets.all(size * .15),
        child: Center(child: _buildIcon(category)));
  }

  Widget _buildIcon(String category) {
    switch (category) {
      case 'Transport':
        return const Icon(Icons.directions_car, size: 26, color: Colors.blue);
      case 'Food':
        return const Icon(Icons.restaurant, size: 26, color: Colors.red);
      case 'Shopping':
        return const Icon(Icons.shopping_bag, size: 26, color: Colors.orange);
      case 'Entertainment':
        return const Icon(Icons.movie, size: 26, color: Colors.purple);
      case 'Travel':
        return const Icon(Icons.flight, size: 26, color: Colors.yellow);
      case 'Health':
        return const Icon(Icons.favorite, size: 26, color: Colors.pink);
      case 'Education':
        return const Icon(Icons.school, size: 26, color: Colors.green);
      case 'Other':
        return const Icon(Icons.category, size: 26, color: Colors.grey);
      case 'Salary':
        return const Icon(Icons.money, size: 26, color: Colors.green);
      case 'Investment':
        return const Icon(Icons.attach_money, size: 26, color: Colors.blue);
      case 'Gift':
        return const Icon(Icons.card_giftcard, size: 26, color: Colors.green);
      case 'Other Income':
        return const Icon(Icons.category, size: 26, color: Colors.grey);
      default:
        return const Icon(Icons.category, size: 26, color: Colors.grey);
    }
  }
}
