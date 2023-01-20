import 'dart:collection';
import 'package:budgetbuddy/functions/crudFunctions.dart';
import 'package:budgetbuddy/functions/sortData.dart';
import 'package:budgetbuddy/functions/weekManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddTransaction {
  final String title;
  final String amount;
  final bool isIncome;
  late DateTime dateTime;
  final String category;
  List collectionIDs = [];

  String transactionId =
      "${ConvertDateTime(DateTime.now()).getDateNumbers()} ; ${ConvertDateTime(DateTime.now()).getTime()}";

  AddTransaction(
      this.title, this.amount, this.isIncome, this.dateTime, this.category) {
    WeekManager.checkWeek();
    RefactorInactiveBudgets();
    addTransaction();
    if (!isIncome) {
      updateBudget();
    }
    updateStatistics();
  }

  addTransaction() {
    DocumentReference transactions = FirebaseFirestore.instance
        .collection((FirebaseAuth.instance.currentUser!.uid).toString())
        .doc('transactions');

    List recents = [];
    Queue recentQueue;

    transactions.get().then((value) => {
          value['years'] == null
              ? transactions.set({
                  'years': [dateTime.year.toString()]
                }, SetOptions(merge: true))
              : {
                  collectionIDs = value['years'],
                  if (!collectionIDs.contains(dateTime.year.toString()))
                    {
                      // print("Year not found, adding year to collectionIDs"),
                      collectionIDs.add(dateTime.year.toString()),
                      transactions.set(
                          {'years': collectionIDs}, SetOptions(merge: true)),
                    }
                },
          isIncome
              ? value['income'] == null
                  ? transactions.set(
                      {'income': double.parse(amount)}, SetOptions(merge: true))
                  : transactions.set(
                      {'income': value['income'] + double.parse(amount)},
                      SetOptions(merge: true))
              : value['expense'] == null
                  ? transactions.set({'expense': double.parse(amount)},
                      SetOptions(merge: true))
                  : transactions.set(
                      {'expense': value['expense'] + double.parse(amount)},
                      SetOptions(merge: true)),
          recents = value['recent'],
          if (recents.isEmpty)
            {
              SortData.recentData = [
                {
                  transactionId: {
                    'Title': title,
                    'Amount': amount,
                    'isIncome': isIncome,
                    'Date': dateTime,
                    'Category': category,
                  }
                }
              ],
              transactions.set({
                'recent': [
                  {
                    transactionId: {
                      'Title': title,
                      'Amount': amount,
                      'isIncome': isIncome,
                      'Date': dateTime,
                      'Category': category,
                    }
                  }
                ]
              }, SetOptions(merge: true)),
            }
          else
            {
              recentQueue = Queue.from(recents),
              recentQueue.addFirst({
                transactionId: {
                  'Title': title,
                  'Amount': amount,
                  'isIncome': isIncome,
                  'Date': dateTime,
                  'Category': category,
                }
              }),
              if (recentQueue.length > 15)
                {
                  recentQueue.removeLast(),
                },
              SortData.recentData = recentQueue.toList(),
              transactions.set(
                  {'recent': recentQueue.toList()}, SetOptions(merge: true)),
            },
        });
    SortData.allData.addAll({
      dateTime.year.toString(): {
        dateTime.month.toString(): {
          dateTime.day.toString(): {
            transactionId: {
              'Title': title,
              'Amount': amount,
              'isIncome': isIncome,
              'Date': Timestamp.fromDate(dateTime),
              'Category': category,
              'Date Added': Timestamp.fromDate(DateTime.now()),
            }
          }
        }
      }
    });
    transactions
        .collection(dateTime.year.toString())
        .doc(dateTime.month.toString())
        .set({
      dateTime.day.toString(): {
        transactionId: {
          'Title': title,
          'Amount': amount,
          'isIncome': isIncome,
          'Date': dateTime,
          'Category': category,
          'Date Added': DateTime.now(),
        }
      }
    }, SetOptions(merge: true)).onError((error, stackTrace) => {
              SnackBar(
                  content: const Text("Error Adding Transaction..."),
                  duration: const Duration(seconds: 5),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: "Retry",
                    onPressed: () {
                      AddTransaction(
                          title, amount, isIncome, dateTime, category);
                    },
                  )),
              print("Error: $error"),
              print("Stack Trace: $stackTrace"),
            });
  }

  updateBudget() {
    //  print("Checking Budgets for Category: $category");
    DocumentReference budgets = FirebaseFirestore.instance
        .collection((FirebaseAuth.instance.currentUser!.uid).toString())
        .doc('budgets');
    budgets
        .collection("active")
        .get()
        .then((value) => {
              value.docs.forEach((budget) {
                if (budget.data()['Category'] == category ||
                    budget.data()['Category'] == "General") {
                  // print("Found Category in Budget: ${budget.id}");
                  if (budget.data()['Start Date'].toDate().isBefore(dateTime) &&
                          budget
                              .data()['End Date']
                              .toDate()
                              .isAfter(dateTime) ||
                      budget.data()['Start Date'].toDate().isBefore(dateTime) &&
                          budget
                              .data()['End Date']
                              .toDate()
                              .isAtSameMomentAs(dateTime) ||
                      budget
                              .data()['Start Date']
                              .toDate()
                              .isAtSameMomentAs(dateTime) &&
                          budget
                              .data()['End Date']
                              .toDate()
                              .isAfter(dateTime) ||
                      budget
                              .data()['Start Date']
                              .toDate()
                              .isAtSameMomentAs(dateTime) &&
                          budget
                              .data()['End Date']
                              .toDate()
                              .isAtSameMomentAs(dateTime)) {
                    //   print(
                    //     "Found Budget: ${budget.id} that matches the date range");

                    //  print("Updating Budget: ${budget.id}");
                    budgets.collection("active").doc(budget.id).set({
                      'Current Amount': double.parse(
                          (budget.data()['Current Amount'] +
                                  double.parse(amount))
                              .toStringAsFixed(2)),
                      'Transactions': FieldValue.arrayUnion([
                        {transactionId: amount}
                      ])
                    }, SetOptions(merge: true));
                  }
                }
              })
            })
        .onError((error, stackTrace) => {
              SnackBar(
                  content: const Text("Error Updating Budget..."),
                  duration: const Duration(seconds: 5),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: "Retry",
                    onPressed: () {
                      updateBudget();
                    },
                  )),
              print("Error: $error"),
              print("Stack Trace: $stackTrace"),
            });
  }

  updateStatistics() {
    DocumentReference stats = FirebaseFirestore.instance
        .collection((FirebaseAuth.instance.currentUser!.uid).toString())
        .doc('statistics');
    stats.get().then((value) => {
          if ((dateTime.isAfter(value['start'].toDate()) &&
                  dateTime.isBefore(value['end'].toDate())) ||
              (dateTime.isAtSameMomentAs(value['start'].toDate()) &&
                  dateTime.isBefore(value['end'].toDate())))
            {
              stats.set({
                'thisWeek': {
                  dateTime.weekday.toString(): {
                    'income': value['thisWeek'][dateTime.weekday.toString()]
                                ['income'] ==
                            null
                        ? (isIncome ? double.parse(amount) : 0)
                        : (double.parse(value['thisWeek']
                                    [dateTime.weekday.toString()]['income']) +
                                (isIncome ? double.parse(amount) : 0))
                            .toStringAsFixed(2),
                    'expense': value['thisWeek'][dateTime.weekday.toString()]
                                ['expense'] ==
                            null
                        ? (!isIncome ? double.parse(amount) : 0)
                        : (double.parse(value['thisWeek']
                                    [dateTime.weekday.toString()]['expense']) +
                                (!isIncome ? double.parse(amount) : 0))
                            .toStringAsFixed(2),
                  },
                },
                'transactions': FieldValue.arrayUnion([
                  {
                    transactionId: {
                      'Title': title,
                      'Amount': amount,
                      'isIncome': isIncome,
                      'Date': dateTime,
                      'Category': category,
                    }
                  }
                ])
              }, SetOptions(merge: true)),
            }
        });
  }
/*
    _stats
        .collection(dateTime.year.toString())
        .doc('monthData')
        .get()
        .then((value) => {
              value.exists
                  ? _stats
                      .collection(dateTime.year.toString())
                      .doc('monthData')
                      .set(
                      {
                        (dateTime.month - 1).toString(): {
                          'income':
                              value.data()![(dateTime.month - 1).toString()]
                                          ?['income'] ==
                                      null
                                  ? (isIncome ? double.parse(amount) : 0)
                                  : isIncome
                                      ? value[(dateTime.month - 1).toString()]
                                              ['income'] +
                                          double.parse(amount)
                                      : value[(dateTime.month - 1).toString()]
                                          ['income'],
                          'expense':
                              value.data()![(dateTime.month - 1).toString()]
                                          ?['expense'] ==
                                      null
                                  ? (isIncome ? 0 : double.parse(amount))
                                  : isIncome
                                      ? value[(dateTime.month - 1).toString()]
                                          ['expense']
                                      : value[(dateTime.month - 1).toString()]
                                              ['expense'] +
                                          double.parse(amount)
                        },
                      },
                      SetOptions(merge: true),
                    )
                  : _stats
                      .collection(dateTime.year.toString())
                      .doc('monthData')
                      .set({
                      (dateTime.month - 1).toString(): {
                        'income': isIncome ? double.parse(amount) : 0,
                        'expense': isIncome ? 0 : double.parse(amount),
                      },
                      'transactions': [],
                    })
            });

    _stats
        .collection(week.values.first[2].toString())
        .doc(week.values.first[1].toString())
        .get()
        .then(
      (value) {
        (value.exists == false)
            ? _stats
                .collection(week.values.first[2].toString())
                .doc(week.values.first[1].toString())
                .set({
                (week.keys.first - 1).toString(): {
                  'income': isIncome ? double.parse(amount) : 0,
                  'expense': isIncome ? 0 : double.parse(amount),
                },
                'transactions': []
              })
            : _stats
                .collection(week.values.first[2].toString())
                .doc(week.values.first[1].toString())
                .set({
                (week.keys.first - 1).toString(): {
                  'income': value.data()?[(week.keys.first - 1).toString()] ==
                          null
                      ? (isIncome ? double.parse(amount) : 0)
                      : (isIncome
                          ? value[(week.keys.first - 1).toString()]['income'] +
                              double.parse(amount)
                          : value[(week.keys.first - 1).toString()]),
                  'expense': value.data()?[(week.keys.first - 1).toString()] ==
                          null
                      ? (isIncome ? 0 : double.parse(amount))
                      : (isIncome
                          ? value[(week.keys.first - 1).toString()]['expense']
                          : value[(week.keys.first - 1).toString()]['expense'] +
                              double.parse(amount))
                },
              }, SetOptions(merge: true));
      },
    );
    _stats
        .collection(week.values.first[2].toString())
        .doc(week.values.first[1].toString())
        .collection("Week" + week.keys.first.toString())
        .doc('WeekData')
        .get()
        .then((value) => {
              (value.exists == false)
                  ? _stats
                      .collection(week.values.first[2].toString())
                      .doc(week.values.first[1].toString())
                      .collection("Week" + week.keys.first.toString())
                      .doc('WeekData')
                      .set({
                      (dateTime.weekday - 1).toString(): {
                        'income': isIncome ? double.parse(amount) : 0,
                        'expense': isIncome ? 0 : double.parse(amount),
                      },
                      'Week Start': week.values.first[0][0],
                      'Week End': week.values.first[0][1],
                    }, SetOptions(merge: true))
                  : _stats
                      .collection(week.values.first[2].toString())
                      .doc(week.values.first[1].toString())
                      .collection("Week" + week.keys.first.toString())
                      .doc('WeekData')
                      .set({
                      (dateTime.weekday - 1).toString(): {
                        'income':
                            value.data()![(dateTime.weekday - 1).toString()]
                                        ?['income'] ==
                                    null
                                ? (isIncome ? double.parse(amount) : 0)
                                : isIncome
                                    ? value[(dateTime.weekday - 1).toString()]
                                            ['income'] +
                                        double.parse(amount)
                                    : value[(dateTime.weekday - 1).toString()]
                                        ['income'],
                        'expense':
                            value.data()![(dateTime.weekday - 1).toString()]
                                        ?['expense'] ==
                                    null
                                ? (isIncome ? 0 : double.parse(amount))
                                : isIncome
                                    ? value[(dateTime.weekday - 1).toString()]
                                        ['expense']
                                    : value[(dateTime.weekday - 1).toString()]
                                            ['expense'] +
                                        double.parse(amount),
                      }
                    }, SetOptions(merge: true))
            });*/

}
