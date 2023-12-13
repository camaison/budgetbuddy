import 'dart:math';
import 'package:budgetbuddy/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    Map graphData = {};
    List weekTransactions = [];

    // return StreamBuilder(
    //     stream: FirebaseFirestore.instance
    //         .collection(FirebaseAuth.instance.currentUser!.uid)
    //         .doc('statistics')
    //         .get()
    //         .asStream(),
    //     builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //       if (snapshot.hasData) {
    //         Map graphData = snapshot.data!.data() as Map;
    //         List weekTransactions = graphData['transactions'] != null
    //             ? graphData['transactions'].reversed.toList()
    //             : [];

    //         return
    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 10),
          AspectRatio(
              aspectRatio: 1,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                color: const Color(0xFF4A5859).withOpacity(0.2),
                child: Text(''),
                // child: barChart(graphData: graphData['thisWeek']),
              )),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "This Week's Transactions",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          weekTransactions.isNotEmpty
              ? SizedBox(
                  height: 365,
                  child: Scrollbar(
                    interactive: true,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: weekTransactions.length,
                        itemBuilder: (context, index) {
                          List keys = weekTransactions[index].keys.toList();
                          List values = weekTransactions[index].values.toList();

                          return TransactionTile(
                            transactionName: values[0]['Title'],
                            money: values[0]['Amount'],
                            dateTime: DateTime.fromMillisecondsSinceEpoch(
                                values[0]['Date'].millisecondsSinceEpoch),
                            isIncome: values[0]['isIncome'],
                            transactionId: keys[0],
                            category: values[0]['Category'],
                          );
                        }),
                  ))
              : const SizedBox(
                  height: 200,
                  child: Center(
                      child: Text(
                    "No Transactions",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ))),
        ]),
      ),
    );
  }
}
// } else {
//   return ShimmerLoading();
// }

Widget ShimmerLoading() {
  Map graphData = {
    '1': {"income": '45', "expense": '82'},
    '2': {'income': '66', 'expense': '92'},
    '3': {'income': '10', 'expense': '50'},
    '4': {'income': '100', 'expense': '90'},
    '5': {'income': '0.00', 'expense': '13.00'},
    '6': {'income': '90', 'expense': '37'},
    '7': {'income': '52', 'expense': '19'}
  };
  return Expanded(
      child: Shimmer(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFC83E4D).withOpacity(0.1),
              const Color(0xFFF4B860).withOpacity(0.2),
              const Color(0xFF4A5859).withOpacity(0.3),
            ],
          ),
          child: Column(children: [
            const SizedBox(height: 10),
            AspectRatio(
                aspectRatio: 1,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  color: const Color(0xFF4A5859).withOpacity(0.2),
                  child: barChart(graphData: graphData),
                )),
            const SizedBox(height: 20),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 20,
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      title: Container(
                        height: 20,
                        width: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      subtitle: Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      trailing: Container(
                        height: 20,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }),
            )
          ])));
}

Widget makeTransactionsIcon() {
  const width = 4.5;
  const space = 3.5;
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        width: width,
        height: 10,
        color: Colors.white.withOpacity(0.1),
      ),
      const SizedBox(
        width: space,
      ),
      Container(
        width: width,
        height: 28,
        color: Colors.white.withOpacity(0.2),
      ),
      const SizedBox(
        width: space,
      ),
      Container(
        width: width,
        height: 42,
        color: Colors.white.withOpacity(0.4),
      ),
      const SizedBox(
        width: space,
      ),
      Container(
        width: width,
        height: 28,
        color: Colors.white.withOpacity(0.2),
      ),
      const SizedBox(
        width: space,
      ),
      Container(
        width: width,
        height: 10,
        color: Colors.white.withOpacity(0.1),
      ),
    ],
  );
}

class barChart extends StatefulWidget {
  final Map graphData;
  const barChart({super.key, required this.graphData});

  @override
  State<barChart> createState() => _barChartState(graphData);
}

class _barChartState extends State<barChart> {
  final double width = 7;
  final Map graphData;
  final Color leftBarColor = Colors.greenAccent;
  final Color rightBarColor = Colors.redAccent;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  int touchedGroupIndex = -1;
  bool showgrid = false;
  double maxVal = 0;
  double minVal = double.infinity;
  List<BarChartGroupData> graphList = [];

  _barChartState(this.graphData) {
    graphData.forEach((key, value) {
      if (key != 'transactions') {
        maxVal = max(maxVal,
            max(double.parse(value['income']), double.parse(value['expense'])));
        minVal = min(minVal,
            min(double.parse(value['income']), double.parse(value['expense'])));
        graphList.add(makeGroupData(int.parse(key),
            double.parse(value['income']), double.parse(value['expense'])));
      }
    });

    rawBarGroups = graphList;
    showingBarGroups = rawBarGroups;
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 2,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    minVal = minVal <= 100 ? 0 : minVal;
    int wholeMax =
        ((maxVal / pow(10, maxVal.round().toString().length - 1)).ceil() *
                pow(10, maxVal.round().toString().length - 1))
            .toInt();
    ;
    int wholeMin =
        ((minVal / pow(10, minVal.round().toString().length - 1)).floor() *
                pow(10, minVal.round().toString().length - 1))
            .toInt();
    int diff = wholeMax - wholeMin;
    List<int> leftMarks = [];
    leftMarks.add(wholeMin);
    for (int i = 0; i < 9; i++) {
      leftMarks.add(leftMarks[i] + (diff / 10).round());
    }

    leftMarks.add(wholeMax);
    String text;
    if (value == leftMarks[0]) {
      text = leftMarks[0].toStringAsFixed(0);
    } else if (value == leftMarks[1]) {
      text = leftMarks[1].toStringAsFixed(0);
    } else if (value == leftMarks[2]) {
      text = leftMarks[2].toStringAsFixed(0);
    } else if (value == leftMarks[3]) {
      text = leftMarks[3].toStringAsFixed(0);
    } else if (value == leftMarks[4]) {
      text = leftMarks[4].toStringAsFixed(0);
    } else if (value == leftMarks[5]) {
      text = leftMarks[5].toStringAsFixed(0);
    } else if (value == leftMarks[6]) {
      text = leftMarks[6].toStringAsFixed(0);
    } else if (value == leftMarks[7]) {
      text = leftMarks[7].toStringAsFixed(0);
    } else if (value == leftMarks[8]) {
      text = leftMarks[8].toStringAsFixed(0);
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NormalGraph();
  }

  Widget NormalGraph() {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  makeTransactionsIcon(),
                  const SizedBox(
                    width: 38,
                  ),
                  const Text(
                    'Transaction',
                    style: TextStyle(color: Colors.grey, fontSize: 22),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    'Data',
                    style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                  ),
                  const SizedBox(
                    width: 38,
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        showgrid = !showgrid;
                      });
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.lightbulb,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: BarChart(
                        dayChart(graphData),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ]));
  }

  yearChart(graphData) {
    final titles = graphData.keys.toList();

    Widget bottomTitles(double value, TitleMeta meta) {
      final Widget text = Text(
        graphData[titles[0]]['year'],
        style: const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

      return SideTitleWidget(
        //angle: 45,
        axisSide: meta.axisSide,
        space: 14, //margin top
        child: text,
      );
    }

    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.grey.withOpacity(0.3),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String text;
            String income;
            String expense;
            switch (group.x) {
              case 0:
                text = graphData[titles[0]]['year'];
                income = graphData[titles[0]]['income'];
                expense = graphData[titles[0]]['expense'];
                break;
              case 1:
                text = titles[1];
                income = graphData[titles[1]]['income'];
                expense = graphData[titles[1]]['expense'];
                break;
              case 2:
                text = 'March';
                income = graphData['2']['income'];
                expense = graphData['2']['expense'];
                break;
              case 3:
                text = 'April';
                income = graphData['3']['income'];
                expense = graphData['3']['expense'];
                break;
              case 4:
                text = 'May';
                income = graphData['4']['income'];
                expense = graphData['4']['expense'];
                break;
              case 5:
                text = 'June';
                income = graphData['5']['income'];
                expense = graphData['5']['expense'];
                break;
              case 6:
                text = 'July';
                income = graphData['6']['income'];
                expense = graphData['6']['expense'];
                break;
              case 7:
                text = 'August';
                income = graphData['7']['income'];
                expense = graphData['7']['expense'];
                break;
              case 8:
                text = 'September';
                income = graphData['8']['income'];
                expense = graphData['8']['expense'];
                break;
              case 9:
                text = 'October';
                income = graphData['9']['income'];
                expense = graphData['9']['expense'];
                break;
              case 10:
                text = 'November';
                income = graphData['10']['income'];
                expense = graphData['10']['expense'];
                break;
              case 11:
                text = 'December';
                income = graphData['11']['income'];
                expense = graphData['11']['expense'];
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$text\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '$income\n',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: '$expense\n',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: (rod.toY).toString(),
                  style: const TextStyle(
                    color: const Color(0xFFF4B860),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, response) {
          setState(() {
            if (response == null || response.spot == null) {
              touchedGroupIndex = -1;
              showingBarGroups = List.of(rawBarGroups);

              return;
            }

            touchedGroupIndex = response.spot!.touchedBarGroupIndex;

            if (!event.isInterestedForInteractions) {
              touchedGroupIndex = -1;
              showingBarGroups = List.of(rawBarGroups);
              return;
            }

            if (touchedGroupIndex != -1) {
              var sum = 0.0;
              for (final rod in showingBarGroups[touchedGroupIndex].barRods) {
                sum += rod.toY;
              }
              final avg =
                  sum / showingBarGroups[touchedGroupIndex].barRods.length;

              showingBarGroups[touchedGroupIndex] =
                  showingBarGroups[touchedGroupIndex].copyWith(
                barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                  return rod.copyWith(toY: avg);
                }).toList(),
              );
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: bottomTitles,
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1,
            getTitlesWidget: leftTitles,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingBarGroups, //snapshot.data as List<BarChartGroupData>,
      gridData: FlGridData(
        show: showgrid,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.15),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xFFF4B860).withOpacity(0.15),
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  monthChart(graphData) {
    Widget bottomTitles(double value, TitleMeta meta) {
      final titles = <String>[
        'Jn',
        'Fb',
        'Mr',
        'Ap',
        'My',
        'Jn',
        'Jl',
        'Au',
        'Sp',
        'Oc',
        'Nv',
        'Dc',
      ];

      final Widget text = Text(
        titles[value.toInt()],
        style: const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

      return SideTitleWidget(
        //angle: 45,
        axisSide: meta.axisSide,
        space: 14, //margin top
        child: text,
      );
    }

    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.grey.withOpacity(0.3),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String text;
            String income;
            String expense;
            switch (group.x) {
              case 0:
                text = 'January';
                income = graphData['0']['income'];
                expense = graphData['0']['expense'];
                break;
              case 1:
                text = 'February';
                income = graphData['1']['income'];
                expense = graphData['1']['expense'];
                break;
              case 2:
                text = 'March';
                income = graphData['2']['income'];
                expense = graphData['2']['expense'];
                break;
              case 3:
                text = 'April';
                income = graphData['3']['income'];
                expense = graphData['3']['expense'];
                break;
              case 4:
                text = 'May';
                income = graphData['4']['income'];
                expense = graphData['4']['expense'];
                break;
              case 5:
                text = 'June';
                income = graphData['5']['income'];
                expense = graphData['5']['expense'];
                break;
              case 6:
                text = 'July';
                income = graphData['6']['income'];
                expense = graphData['6']['expense'];
                break;
              case 7:
                text = 'August';
                income = graphData['7']['income'];
                expense = graphData['7']['expense'];
                break;
              case 8:
                text = 'September';
                income = graphData['8']['income'];
                expense = graphData['8']['expense'];
                break;
              case 9:
                text = 'October';
                income = graphData['9']['income'];
                expense = graphData['9']['expense'];
                break;
              case 10:
                text = 'November';
                income = graphData['10']['income'];
                expense = graphData['10']['expense'];
                break;
              case 11:
                text = 'December';
                income = graphData['11']['income'];
                expense = graphData['11']['expense'];
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$text\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '$income\n',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: '$expense\n',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: (rod.toY).toString(),
                  style: const TextStyle(
                    color: const Color(0xFFF4B860),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, response) {
          setState(() {
            if (response == null || response.spot == null) {
              touchedGroupIndex = -1;
              showingBarGroups = List.of(rawBarGroups);

              return;
            }

            touchedGroupIndex = response.spot!.touchedBarGroupIndex;

            if (!event.isInterestedForInteractions) {
              touchedGroupIndex = -1;
              showingBarGroups = List.of(rawBarGroups);
              return;
            }

            if (touchedGroupIndex != -1) {
              var sum = 0.0;
              for (final rod in showingBarGroups[touchedGroupIndex].barRods) {
                sum += rod.toY;
              }
              final avg =
                  sum / showingBarGroups[touchedGroupIndex].barRods.length;

              showingBarGroups[touchedGroupIndex] =
                  showingBarGroups[touchedGroupIndex].copyWith(
                barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                  return rod.copyWith(toY: avg);
                }).toList(),
              );
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: bottomTitles,
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1,
            getTitlesWidget: leftTitles,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingBarGroups, //snapshot.data as List<BarChartGroupData>,
      gridData: FlGridData(
        show: showgrid,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.15),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xFFF4B860).withOpacity(0.15),
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  weekChart(graphData) {
    Widget bottomTitles(double value, TitleMeta meta) {
      final titles = <String>['Wk 1', 'Wk 2', 'Wk 3', 'Wk 4'];

      final Widget text = Text(
        titles[value.toInt()],
        style: const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

      return SideTitleWidget(
        //angle: 45,
        axisSide: meta.axisSide,
        space: 14, //margin top
        child: text,
      );
    }

    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.grey.withOpacity(0.3),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String text;
            String income;
            String expense;
            switch (group.x) {
              case 0:
                text = 'Week 1';
                income = graphData['0']['income'];
                expense = graphData['0']['expense'];
                break;
              case 1:
                text = 'Week 2';
                income = graphData['1']['income'];
                expense = graphData['1']['expense'];
                break;
              case 2:
                text = 'Week 3';
                income = graphData['2']['income'];
                expense = graphData['2']['expense'];
                break;
              case 3:
                text = 'Week 4';
                income = graphData['3']['income'];
                expense = graphData['3']['expense'];
                break;

              default:
                throw Error();
            }
            return BarTooltipItem(
              '$text\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '$income\n',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: '$expense\n',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: (rod.toY).toString(),
                  style: const TextStyle(
                    color: const Color(0xFFF4B860),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, response) {
          setState(() {
            if (response == null || response.spot == null) {
              touchedGroupIndex = -1;
              showingBarGroups = List.of(rawBarGroups);

              return;
            }

            touchedGroupIndex = response.spot!.touchedBarGroupIndex;

            if (!event.isInterestedForInteractions) {
              touchedGroupIndex = -1;
              showingBarGroups = List.of(rawBarGroups);
              return;
            }

            if (touchedGroupIndex != -1) {
              var sum = 0.0;
              for (final rod in showingBarGroups[touchedGroupIndex].barRods) {
                sum += rod.toY;
              }
              final avg =
                  sum / showingBarGroups[touchedGroupIndex].barRods.length;

              showingBarGroups[touchedGroupIndex] =
                  showingBarGroups[touchedGroupIndex].copyWith(
                barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                  return rod.copyWith(toY: avg);
                }).toList(),
              );
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: bottomTitles,
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1,
            getTitlesWidget: leftTitles,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingBarGroups, //snapshot.data as List<BarChartGroupData>,
      gridData: FlGridData(
        show: showgrid,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.15),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xFFF4B860).withOpacity(0.15),
            strokeWidth: 1,
          );
        },
      ),
    );
  }

  dayChart(temp) {
    Map graphData = {};

    temp.forEach((key, value) {
      graphData[(int.parse(key) - 1).toString()] = value;
    });

    Widget bottomTitles(double value, TitleMeta meta) {
      final titles = <String>['Mn', 'Tu', 'Wd', 'Th', 'Fr', 'Sa', 'Su'];

      final Widget text = Text(
        titles[value.toInt() - 1],
        style: const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

      return SideTitleWidget(
        //angle: 45,
        axisSide: meta.axisSide,
        space: 14, //margin top
        child: text,
      );
    }

    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.grey.withOpacity(0.3),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String text;
            String income;
            String expense;
            switch (group.x) {
              case 1:
                text = 'Monday';
                income = graphData['0']['income'];
                expense = graphData['0']['expense'];
                break;
              case 2:
                text = 'Tuesday';
                income = graphData['1']['income'];
                expense = graphData['1']['expense'];
                break;
              case 3:
                text = 'Wednesday';
                income = graphData['2']['income'];
                expense = graphData['2']['expense'];
                break;
              case 4:
                text = 'Thursday';
                income = graphData['3']['income'];
                expense = graphData['3']['expense'];
                break;
              case 5:
                text = 'Friday';
                income = graphData['4']['income'];
                expense = graphData['4']['expense'];
                break;
              case 6:
                text = 'Saturday';
                income = graphData['5']['income'];
                expense = graphData['5']['expense'];
                break;
              case 7:
                text = 'Sunday';
                income = graphData['6']['income'];
                expense = graphData['6']['expense'];
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$text\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '$income\n',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: '$expense\n',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: (rod.toY).toString(),
                  style: const TextStyle(
                    color: const Color(0xFFF4B860),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, response) {
          setState(() {
            if (response == null || response.spot == null) {
              touchedGroupIndex = -1;
              showingBarGroups = List.of(rawBarGroups);

              return;
            }

            touchedGroupIndex = response.spot!.touchedBarGroupIndex;

            if (!event.isInterestedForInteractions) {
              touchedGroupIndex = -1;
              showingBarGroups = List.of(rawBarGroups);
              return;
            }

            if (touchedGroupIndex != -1) {
              var sum = 0.0;
              for (final rod in showingBarGroups[touchedGroupIndex].barRods) {
                sum += rod.toY;
              }
              final avg =
                  sum / showingBarGroups[touchedGroupIndex].barRods.length;

              showingBarGroups[touchedGroupIndex] =
                  showingBarGroups[touchedGroupIndex].copyWith(
                barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                  return rod.copyWith(toY: avg);
                }).toList(),
              );
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: bottomTitles,
            reservedSize: 30,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1,
            getTitlesWidget: leftTitles,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingBarGroups, //snapshot.data as List<BarChartGroupData>,
      gridData: FlGridData(
        show: showgrid,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.15),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xFFF4B860).withOpacity(0.15),
            strokeWidth: 1,
          );
        },
      ),
    );
  }
}
