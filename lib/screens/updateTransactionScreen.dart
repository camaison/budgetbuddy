import 'dart:ui';
import 'package:budgetbuddy/database/database_functions.dart';
import 'package:budgetbuddy/database/transaction_item.dart';
import 'package:budgetbuddy/functions/addTransaction.dart';
import 'package:budgetbuddy/functions/create_budget_json.dart';
import 'package:budgetbuddy/functions/deleteTransaction.dart';
import 'package:budgetbuddy/screens/bottomnavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

// ignore: must_be_immutable
class UpdateTransactionScreen extends StatefulWidget {
  final String initialTitle;
  final String initialAmount;
  final DateTime initialDateTime;
  final bool initialIsincome;
  final String initialCategory;
  final String initialTransactionId;
  const UpdateTransactionScreen({
    super.key,
    required this.initialTitle,
    required this.initialAmount,
    required this.initialDateTime,
    required this.initialIsincome,
    required this.initialCategory,
    required this.initialTransactionId,
  });

  @override
  State<UpdateTransactionScreen> createState() => _UpdateTransactionScreenState(
        initialTitle,
        initialAmount,
        initialDateTime,
        initialIsincome,
        initialCategory,
        initialTransactionId,
      );
}

class _UpdateTransactionScreenState extends State<UpdateTransactionScreen> {
  final DatabaseFunctions _dbFunctions = DatabaseFunctions.instance;
  _updateTransaction() async {
    await _dbFunctions.updateTransaction(
      TransactionItem(
        transactionId: int.parse(initialTransactionId),
        dateTime: _dateTime.toString(),
        amount: double.parse(_amount),
        category: transactionCategories[activeCategory]['name'],
        type: _isIncome ? 'Income' : 'Expense',
        title: _title,
        createdDateTime: DateTime.now().toString(),
        description: '',
      ).toMap(),
      int.parse(initialTransactionId),
    );
  }

  _UpdateTransactionScreenState(
    this.initialTitle,
    this.initialAmount,
    this.initialDateTime,
    this.initialIsincome,
    this.initialCategory,
    this.initialTransactionId,
  ) {
    for (var i = 0; i < transactionCategories.length; i++) {
      if (transactionCategories[i]['name'] == initialCategory) {
        activeCategory = i;
      }
    }
  }
  late int activeCategory;
  final String initialTitle;
  final String initialAmount;
  final DateTime initialDateTime;
  final bool initialIsincome;
  final String initialCategory;
  final String initialTransactionId;
  late bool _isIncome = initialIsincome;
  late DateTime _dateTime = initialDateTime;
  late String _amount;
  late String _title;
  late String id;

  final GlobalKey<FormState> _transactionKey = GlobalKey<FormState>();

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
              const Color(0xFF4A5859).withOpacity(0.3),
              //Color(0xFFC83E4D).withOpacity(0.1),
              const Color(0xFFF4B860).withOpacity(0.1)
            ],
          ),
        ),
      ),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration:
                    const BoxDecoration(color: Color(0xFFF4B860), boxShadow: [
                  BoxShadow(
                    color: Colors.transparent,
                    spreadRadius: 10,
                    blurRadius: 3,
                    // changes position of shadow
                  ),
                ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 60, right: 20, left: 20, bottom: 25),
                  child: Column(
                    children: [
                      Row(
                        //S mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                );
                              },
                              icon: const Icon(Icons.arrow_back)),
                          const Text(
                            "Update Transaction",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Text(
                  "Choose Category",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children:
                        List.generate(transactionCategories.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        activeCategory = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                        ),
                        width: 150,
                        height: 170,
                        decoration: BoxDecoration(
                            color: const Color(0xFF4A5859).withOpacity(0.15),
                            border: Border.all(
                                width: 2,
                                color: activeCategory == index
                                    ? Colors.orange
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.01),
                                spreadRadius: 10,
                                blurRadius: 3,
                                // changes position of shadow
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 20, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.withOpacity(0.15)),
                                  child: Center(
                                    child: Image.asset(
                                      transactionCategories[index]['icon'],
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                              Text(
                                transactionCategories[index]['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Form(
                    key: _transactionKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Date & Time",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.bottomLeft,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.white.withOpacity(0.1))),
                              width: 190,
                              child: TextButton(
                                onPressed: () async {
                                  DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: _dateTime,
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2100));
                                  if (newDate == Null) return;
                                  TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime:
                                          TimeOfDay.fromDateTime(_dateTime),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return MediaQuery(
                                          data:
                                              MediaQuery.of(context).copyWith(),
                                          child: child!,
                                        );
                                      });
                                  setState(() {
                                    _dateTime = DateTime(
                                        newDate!.year,
                                        newDate.month,
                                        newDate.day,
                                        newTime!.hour,
                                        newTime.minute);
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    '${_dateTime.day}/${_dateTime.month}/${_dateTime.year}  @${_dateTime.hour}:${_dateTime.minute}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            LiteRollingSwitch(
                              value: initialIsincome,
                              textOn: 'Income',
                              textOff: 'Expense',
                              colorOn: Colors.green,
                              colorOff: Colors.red,
                              iconOn: Icons.arrow_upward,
                              iconOff: Icons.arrow_downward,
                              textOnColor: Colors.white,
                              textSize: 15.0,
                              onTap: () {},
                              onSwipe: () {},
                              onDoubleTap: () {},
                              onChanged: (bool state) {
                                _isIncome = state;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "Transaction Name",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        TextFormField(
                          cursorColor: Colors.white,
                          initialValue: initialTitle,
                          decoration: const InputDecoration(
                              hintText: "Enter Transaction Name",
                              border: InputBorder.none),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Enter a Transaction Name';
                            }
                          },
                          onSaved: (String? input) {
                            _title = input.toString();
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Enter Amount",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  TextFormField(
                                    cursorColor: Colors.black,
                                    initialValue: initialAmount,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter an Amount',
                                    ),
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Enter an Amount';
                                      }
                                      if (double.tryParse(text) == null) {
                                        return 'Enter a valid Amount';
                                      }
                                    },
                                    onSaved: (String? input) {
                                      _amount = input.toString();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF4B860),
                                    borderRadius: BorderRadius.circular(15)),
                                child: IconButton(
                                  onPressed: () async {
                                    if (!_transactionKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    _transactionKey.currentState!.save();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const Scaffold(
                                            backgroundColor: Colors.transparent,
                                            body: Center(
                                                child: Column(children: [
                                              SizedBox(
                                                height: 200,
                                              ),
                                              CircularProgressIndicator(
                                                color: Colors.orangeAccent,
                                              ),
                                              Text(
                                                "Updating Transaction...",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              )
                                            ])),
                                          );
                                        });
                                    // Future.delayed(
                                    //   const Duration(seconds: 2),
                                    //   () {
                                    _updateTransaction();
                                    //   },
                                    // );

                                    // Future.delayed(const Duration(seconds: 3),
                                    //     () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Bottom()),
                                        (route) => false);
                                    //   });

                                    _transactionKey.currentState!.reset();
                                  },
                                  icon: const Icon(Icons.check),
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    ]));
  }
}
