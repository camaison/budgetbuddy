import 'dart:ui';
import 'package:budgetbuddy/functions/deleteTransaction.dart';
import 'package:budgetbuddy/screens/updateTransactionScreen.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  final String transactionName;
  final String money;
  final bool isIncome;
  final String transactionId;
  final DateTime dateTime;
  final String category;
  const TransactionScreen(
      {super.key,
      required this.transactionName,
      required this.money,
      required this.isIncome,
      required this.transactionId,
      required this.dateTime,
      required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFF4B860),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Transaction Screen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              )),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateTransactionScreen(
                              initialTitle: transactionName,
                              initialAmount: money,
                              initialIsincome: isIncome,
                              initialTransactionId: transactionId,
                              initialDateTime: dateTime,
                              initialCategory: category,
                            )));
              },
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor:
                              const Color(0xFF4A5859).withOpacity(0.8),
                          title: const Text('Delete Transaction'),
                          content: const Text(
                              'Are you sure you want to delete this transaction?',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18))),
                            TextButton(
                                onPressed: () {
                                  DeleteTransaction(transactionId, money,
                                      isIncome, dateTime, category, null);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.redAccent, fontSize: 18),
                                )),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.delete),
                color: Colors.white),
          ],
        ),
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF4A5859).withOpacity(0.3),
                  //Color(0xFFC83E4D).withOpacity(0.1),
                  const Color(0xFFF4B860).withOpacity(0.1)
                ],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
                child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Container(
                                margin: const EdgeInsets.all(20),
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Image.asset(
                                  'assets/images/$category.png',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.contain,
                                )),
                          ),
                          Text(
                            category,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.all(20),
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      "Date : ${dateTime.day}/${dateTime.month}/${dateTime.year}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      "Time : ${dateTime.hour}:${dateTime.minute}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]))),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Title: $transactionName",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Ammount: ₵$money",
                    style: TextStyle(
                        color: isIncome ? Colors.green : Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Description: ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            )),
          ),
        ]));
  }
}
