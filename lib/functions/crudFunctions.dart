import 'dart:io';
import 'package:budgetbuddy/functions/weekManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RefactorInactiveBudgets {
  RefactorInactiveBudgets() {
    DocumentReference budgets = FirebaseFirestore.instance
        .collection((FirebaseAuth.instance.currentUser!.uid).toString())
        .doc('budgets');
    budgets
        .collection("active")
        .where('End Date', isLessThan: DateTime.now())
        .get()
        .then((value) => {
              value.docs.forEach((budget) {
                if (budget
                    .data()['End Date']
                    .toDate()
                    .isBefore(DateTime.now())) {
                  double score = ((budget['End Date']
                                      .toDate()
                                      .difference(budget['Start Date'].toDate())
                                      .inHours /
                                  24)
                              .round() *
                          (budget['Limit'] - budget['Current Amount']) /
                          100)
                      .round();
                  budgets
                      .get()
                      .then((value) => {
                            budgets.set({
                              'score': value['score'] + score,
                            }),
                          })
                      .then((value) {
                    budgets
                        .collection("inactive")
                        .doc(budget.id)
                        .set({'score': score}, SetOptions(merge: true));
                  });
                  budgets
                      .collection("inactive")
                      .doc(budget.id)
                      .set(budget.data(), SetOptions(merge: true));
                  budgets.collection("active").doc(budget.id).delete();
                }
              })
            });
  }
}

class InitDatabase {
  final String name;
  final String email;
  final File pic;
  final User? user;
  InitDatabase(
      {required this.name,
      required this.email,
      required this.pic,
      required this.user}) {
    init();
  }

  init() async {
    DateTime date = DateTime.now();
    DateTime endOfWeek = WeekManager.getDate(
        date.add(Duration(days: DateTime.daysPerWeek - date.weekday + 1)));
    DateTime startOfWeek =
        WeekManager.getDate(date.subtract(Duration(days: date.weekday - 1)));
    String fileName = user!.uid;
    late String profilPicURL = '';
    if (pic != File('assets/images/placeholder.jpg')) {
      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child('profilePictures/$fileName');
      await firebaseStorageRef.putFile(pic).then((val) async {
        profilPicURL = await firebaseStorageRef.getDownloadURL();
      });
    }

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'name': name,
      'email': email,
      'picURL': profilPicURL,
      "id": user!.uid,
    }).then((value) => {
          print("User Document Created!"),
        });

    await FirebaseFirestore.instance
        .collection(user!.uid)
        .doc('statistics')
        .set({
      'start': startOfWeek,
      'end': endOfWeek,
      'thisWeek': {
        '1': {'income': '0', 'expense': '0'},
        '2': {'income': '0', 'expense': '0'},
        '3': {'income': '0', 'expense': '0'},
        '4': {'income': '0', 'expense': '0'},
        '5': {'income': '0', 'expense': '0'},
        '6': {'income': '0', 'expense': '0'},
        '7': {'income': '0', 'expense': '0'},
      },
    }).then((value) => {
              print("Statistics Collection Created!"),
            });

    await FirebaseFirestore.instance
        .collection(user!.uid)
        .doc('transactions')
        .set({
      'score': 0,
      'recent': [],
      'years': [],
      'income': 0,
      'expense': 0,
    }).then((value) => {
              print("Transactions Collection Created!"),
            });
  }
}

class CreateBudget {
  final String title;
  final String amount;
  final DateTime dateTime;
  final String category;
  CreateBudget(this.title, this.amount, this.dateTime, this.category) {
    RefactorInactiveBudgets();
    String docName =
        "${ConvertDateTime(DateTime.now()).getDateNumbers()} ; ${ConvertDateTime(DateTime.now()).getTime()}";
    DocumentReference budgets = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc('budgets');
    budgets.collection("active").doc(docName).set({
      'Title': title,
      'Current Amount': 0,
      'Limit': double.parse(amount),
      'Start Date': DateTime.now(),
      'End Date': dateTime,
      'Category': category,
    }).onError((error, stackTrace) => {
          SnackBar(
              content: const Text("Error Creating Budget..."),
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: "Retry",
                onPressed: () {
                  CreateBudget(title, amount, dateTime, category);
                },
              )),
          print("Error: $error"),
          print("Stack Trace: $stackTrace"),
        });
  }
}

class ConvertDateTime {
  final DateTime dateTime;
  late int year;
  late int month;
  late int day;
  late String hour;
  late String minute;
  late String second;
  late String time;
  late String date;
  late String dayofWeek;
  List days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static List months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  ConvertDateTime(this.dateTime) {
    dayofWeek = days[dateTime.weekday - 1];
    year = dateTime.year;
    month = dateTime.month;
    day = dateTime.day;
    hour = dateTime.hour.toString();
    minute = dateTime.minute.toString();
    second = dateTime.second.toString();
  }

  static String convertMonth(int month) {
    return months[month - 1];
  }

  String getTime() {
    return '$hour:$minute:$second';
  }

  String getDate() {
    return '${'$dayofWeek, ${dateTime.day} ' + months[dateTime.month - 1]} ${dateTime.year}';
  }

  String getDateNumbers() {
    return '$day.$month.$year';
  }
}
