import 'package:budgetbuddy/screens/addScreen.dart';
import 'package:budgetbuddy/screens/budget_page.dart';
import 'package:budgetbuddy/screens/home.dart';
import 'package:budgetbuddy/screens/profileScreen.dart';
import 'package:budgetbuddy/screens/statistics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;

  List Screen = [
    const Home(),
    const Statistics(),
    BudgetPage(),
    ProfileScreen(),
    const AddNew(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Screen[index_color],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(
            () {
              index_color = 4;
            },
          );
        },
        backgroundColor: const Color(0xFFF4B860),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black.withOpacity(0.1),
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color: index_color == 0
                      ? const Color(0xFFF4B860)
                      : const Color(0xFF4A5859),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color: index_color == 1
                      ? const Color(0xFFF4B860)
                      : const Color(0xFF4A5859),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 2;
                  });
                },
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 30,
                  color: index_color == 2
                      ? const Color(0xFFF4B860)
                      : const Color(0xFF4A5859),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 3;
                  });
                },
                child: Icon(
                  Icons.person_outlined,
                  size: 30,
                  color: index_color == 3
                      ? const Color(0xFFF4B860)
                      : const Color(0xFF4A5859),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
