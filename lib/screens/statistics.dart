import 'dart:ui';
import 'package:budgetbuddy/screens/chart.dart';
import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

ValueNotifier kj = ValueNotifier(0);

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF4B860).withOpacity(0.2),
                const Color(0xFF4A5859).withOpacity(0.3),
                //Color(0xFFC83E4D).withOpacity(0.1),
              ],
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: SafeArea(
            top: false,
            child: ValueListenableBuilder(
              valueListenable: kj,
              builder: (BuildContext context, dynamic value, Widget? child) {
                return custom();
              },
            ),
          ),
        ),
      ]),
    );
  }

  custom() {
    return Column(children: [
      Container(
        decoration: BoxDecoration(color: Color(0xFFF4B860), boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.01),
            spreadRadius: 10,
            blurRadius: 3,
          ),
        ]),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 60, right: 20, left: 20, bottom: 25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Statistics",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Chart(),
    ]);
  }
}
