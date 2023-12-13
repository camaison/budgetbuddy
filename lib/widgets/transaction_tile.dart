import 'package:budgetbuddy/database/database_functions.dart';
import 'package:budgetbuddy/database/transaction_item.dart';
import 'package:budgetbuddy/functions/crudFunctions.dart';
import 'package:budgetbuddy/functions/deleteTransaction.dart';
import 'package:budgetbuddy/screens/bottomnavigationbar.dart';
import 'package:budgetbuddy/screens/updateTransactionScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionTile extends StatelessWidget {
  final String transactionName;
  final String money;
  final bool isIncome;
  final int transactionId;
  final DateTime dateTime;
  final String category;
  TransactionTile({
    super.key,
    required this.transactionName,
    required this.money,
    required this.isIncome,
    required this.transactionId,
    required this.dateTime,
    required this.category,
  });
  final DatabaseFunctions _dbFunctions = DatabaseFunctions.instance;

  _deleteTransaction() async {
    await _dbFunctions.deleteTransaction(transactionId);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80,
        child: Padding(
            padding:
                const EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 10),
            child: Slidable(
                endActionPane: ActionPane(
                  extentRatio: 0.25,
                  motion: const ScrollMotion(),
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    SlidableAction(
                      padding: const EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(10),
                      onPressed: (context) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateTransactionScreen(
                                      initialTitle: transactionName,
                                      initialAmount: money,
                                      initialIsincome: isIncome,
                                      initialTransactionId:
                                          transactionId.toString(),
                                      initialDateTime: dateTime,
                                      initialCategory: category,
                                    )));
                      },
                      backgroundColor: Colors.teal.withOpacity(0.2),
                      icon: Icons.edit,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SlidableAction(
                      backgroundColor: Colors.red.withOpacity(0.2),
                      icon: Icons.delete,
                      padding: const EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(10),
                      onPressed: (context) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor:
                                    const Color(0xFF4A5859).withOpacity(0.8),
                                title: const Text('Delete Transaction'),
                                content: const Text(
                                    'Are you sure you want to delete this transaction?',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18))),
                                  TextButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Scaffold(
                                                backgroundColor:
                                                    Colors.transparent,
                                                body: Center(
                                                    child:
                                                        Column(children: const [
                                                  SizedBox(
                                                    height: 200,
                                                  ),
                                                  CircularProgressIndicator(
                                                    color: Colors.orangeAccent,
                                                  ),
                                                  Text(
                                                    "Deleting Transaction...",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                  )
                                                ])),
                                              );
                                            });
                                        _deleteTransaction();
                                        // Future.delayed(
                                        //     const Duration(seconds: 2), () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Bottom()),
                                            (route) => false);
                                        // });
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 18),
                                      )),
                                ],
                              );
                            });
                      },
                    ),
                  ],
                ),
                child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF4A5859).withOpacity(0.1),
                      /*gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4A5859).withOpacity(0.2),
                      //Color(0xFFC83E4D).withOpacity(0.1),
                      Color(0xFFF4D6CC).withOpacity(0.1)
                    ],
                  ),*/
                    ),
                    child: ListTile(
                        dense: true,
                        visualDensity: const VisualDensity(vertical: -3),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset('assets/images/$category.png',
                              height: 40),
                        ),
                        title: Text(
                          transactionName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${ConvertDateTime(dateTime).getDateNumbers()}   @${TimeOfDay.fromDateTime(dateTime).format(context)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Text(
                          '${isIncome ? '+' : '-'}₵$money',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                        onTap: () {})))));
  }
}
