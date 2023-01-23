import 'dart:collection';
import 'package:budgetbuddy/functions/crudFunctions.dart';
import 'package:budgetbuddy/functions/sortData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateTransaction {
  final Function? init;
  final String title;
  final String amount;
  final bool isIncome;
  late DateTime dateTime;
  final String category;
  final String id;
  List collectionIDs = [];

  String transactionId =
      "${ConvertDateTime(DateTime.now()).getDateNumbers()} ; ${ConvertDateTime(DateTime.now()).getTime()}";

  UpdateTransaction(
      {required this.title,
      required this.amount,
      required this.isIncome,
      required this.dateTime,
      required this.category,
      required this.id,
      this.init}) {
    removeTransaction();
    removeFromStatistics();
    if (!isIncome) {
      removeFromBudget();
    }
  }

  removeTransaction() {
    DocumentReference transactions = FirebaseFirestore.instance
        .collection((FirebaseAuth.instance.currentUser!.uid).toString())
        .doc('transactions');

    List recents = [];
    Queue recentQueue;

    transactions.get().then((value) => {
          isIncome
              ? transactions.set(
                  {'income': value['income'] - double.parse(amount)},
                  SetOptions(merge: true))
              : transactions.set(
                  {'expense': value['expense'] - double.parse(amount)},
                  SetOptions(merge: true)),
          recents = value['recent'],
          recentQueue = Queue.from(recents),
          for (int i = 0; i < recentQueue.length; i++)
            {
              if (recentQueue.elementAt(i).containsKey(id))
                {
                  recentQueue.toList().removeAt(i),
                }
            },
          SortData.recentData = recentQueue.toList(),
          transactions
              .set({'recent': recentQueue.toList()}, SetOptions(merge: true)),
        });

    // SortData.allData.addAll({
    //   dateTime.year.toString(): {
    //     dateTime.month.toString(): {
    //       dateTime.day.toString(): {
    //         transactionId: {
    //           'Title': title,
    //           'Amount': amount,
    //           'isIncome': isIncome,
    //           'Date': Timestamp.fromDate(dateTime),
    //           'Category': category,
    //           'Date Added': Timestamp.fromDate(DateTime.now()),
    //         }
    //       }
    //     }
    //   }
    // });
    transactions
        .collection(dateTime.year.toString())
        .doc(dateTime.month.toString())
        .set({
      dateTime.day.toString(): {transactionId: FieldValue.delete()}
    }).then((value) => print("Transaction Deleted!"));
  }

  removeFromBudget() {
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
                    List transactions = budget.data()['Transactions'];
                    for (int i = 0; i < transactions.length; i++) {
                      if (transactions[i].containsKey(id)) {
                        transactions.removeAt(i);
                      }
                    }

                    //  print("Updating Budget: ${budget.id}");
                    budgets.collection("active").doc(budget.id).set({
                      'Current Amount': double.parse(
                          (budget.data()['Current Amount'] -
                                  double.parse(amount))
                              .toStringAsFixed(2)),
                      'Transactions': transactions
                    }, SetOptions(merge: true));
                  }
                }
              })
            })
        .then((value) => {
              print("Budget Updated!"),
            });
  }

  removeFromStatistics() {
    List<Map> transactions;
    DocumentReference stats = FirebaseFirestore.instance
        .collection((FirebaseAuth.instance.currentUser!.uid).toString())
        .doc('statistics');
    stats
        .get()
        .then((value) => {
              if ((dateTime.isAfter(value['start'].toDate()) &&
                      dateTime.isBefore(value['end'].toDate())) ||
                  (dateTime.isAtSameMomentAs(value['start'].toDate()) &&
                      dateTime.isBefore(value['end'].toDate())))
                {
                  transactions = value['transactions'],
                  for (int i = 0; i < transactions.length; i++)
                    {
                      if (transactions[i].containsKey(id))
                        {
                          transactions.removeAt(i),
                        }
                    },
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
                    'transactions': transactions,
                  }, SetOptions(merge: true)),
                }
            })
        .then((value) => print("Statistics Updated"));
  }
}
