import 'package:budgetbuddy/functions/crudFunctions.dart';
import 'package:budgetbuddy/functions/sortData.dart';
import 'package:budgetbuddy/functions/weekManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteTransaction {
  final String id;
  final DateTime dateTime;
  final String amount;
  final bool isIncome;
  final String category;
  final Function? init;

  DeleteTransaction(this.id, this.amount, this.isIncome, this.dateTime,
      this.category, this.init) {
    WeekManager.checkWeek();
    RefactorInactiveBudgets();
    deleteFromTransactions();
    deleteFromStatistics();
    deleteFromBudgets();
  }

  deleteFromTransactions() {
    DocumentReference transactions = FirebaseFirestore.instance
        .collection((FirebaseAuth.instance.currentUser!.uid).toString())
        .doc('transactions');
    List recents = [];
    transactions.get().then((value) => {
          isIncome
              ? transactions.set(
                  {'income': value['income'] - double.parse(amount)},
                  SetOptions(merge: true))
              : transactions.set(
                  {'expense': value['expense'] - double.parse(amount)},
                  SetOptions(merge: true)),
          recents = value['recent'],
          for (int i = 0; i < recents.length; i++)
            {
              if (recents[i].containsKey(id))
                {
                  recents.removeAt(i),
                  SortData.recentData = recents,
                  transactions.set(
                      {'recent': recents.toList()}, SetOptions(merge: true)),
                }
            },
          SetOptions(merge: true)
        });
    transactions
        .collection(dateTime.year.toString())
        .doc(dateTime.month.toString())
        .set({
      dateTime.day.toString(): {id: FieldValue.delete()}
    }, SetOptions(merge: true)).onError((error, stackTrace) => {
              SnackBar(
                  content: const Text("Error Adding Transaction..."),
                  duration: const Duration(seconds: 5),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: "Retry",
                    onPressed: () {
                      deleteFromTransactions();
                    },
                  )),
              print("Error: $error"),
              print("Stack Trace: $stackTrace"),
            });
  }

  deleteFromStatistics() {
    DocumentReference stats = FirebaseFirestore.instance
        .collection((FirebaseAuth.instance.currentUser!.uid).toString())
        .doc('statistics');
    List transactions;
    stats.get().then((value) => {
          transactions = value['transactions'],
          for (int i = 0; i < transactions.length; i++)
            {
              if (transactions[i].containsKey(id))
                {
                  transactions.removeAt(i),
                }
            },
          if ((dateTime.isAfter(value['start'].toDate()) &&
                  dateTime.isBefore(value['end'].toDate())) ||
              (dateTime.isAtSameMomentAs(value['start'].toDate()) &&
                  dateTime.isBefore(value['end'].toDate())))
            {
              stats.set({
                'thisWeek': {
                  dateTime.weekday.toString(): {
                    'income': (double.parse(value['thisWeek']
                                [dateTime.weekday.toString()]['income']) -
                            (isIncome ? double.parse(amount) : 0))
                        .toStringAsFixed(2),
                    'expense': (double.parse(value['thisWeek']
                                [dateTime.weekday.toString()]['expense']) -
                            (!isIncome ? double.parse(amount) : 0))
                        .toStringAsFixed(2),
                  },
                },
                'transactions': transactions.toList()
              }, SetOptions(merge: true)),
            }
        });
  }

  deleteFromBudgets() {
    DocumentReference budgets = FirebaseFirestore.instance
        .collection((FirebaseAuth.instance.currentUser!.uid).toString())
        .doc('budgets');
    List transactions;
    budgets
        .collection("active")
        .get()
        .then((value) => {
              value.docs.forEach((budget) {
                transactions = budget.data()['Transactions'];
                for (int i = 0; i < transactions.length; i++) {
                  if (transactions[i].containsKey(id)) {
                    transactions.removeAt(i);
                  }
                }
                if (budget.data()['Category'] == category ||
                    budget.data()['Category'] == "General") {
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
                    budgets.collection("active").doc(budget.id).set({
                      'Current Amount': (budget.data()['Current Amount'] -
                          double.parse(amount)),
                      'Transactions': transactions.toList()
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
                      deleteFromBudgets();
                    },
                  )),
              print("Error: $error"),
              print("Stack Trace: $stackTrace"),
            });
  }
}
