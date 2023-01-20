import 'dart:ui';
import 'package:budgetbuddy/functions/addTransaction.dart';
import 'package:budgetbuddy/functions/create_budget_json.dart';
import 'package:budgetbuddy/functions/deleteTransaction.dart';
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
  late var size;
  bool _isIncome = true;
  late DateTime _dateTime = initialDateTime;
  late String _amount;
  late String _title;
  String _description = '';
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
              Color(0xFF4A5859).withOpacity(0.3),
              //Color(0xFFC83E4D).withOpacity(0.1),
              Color(0xFFF4B860).withOpacity(0.1)
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
                    BoxDecoration(color: Colors.orangeAccent, boxShadow: [
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
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back)),
                          Text(
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
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Text(
                  "Choose Category",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.5)),
                ),
              ),
              SizedBox(
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
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        width: 150,
                        height: 170,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.15),
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
                                style: TextStyle(
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
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Form(
                    key: _transactionKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date & Time",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff67727d)),
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
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
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
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Transaction Name",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff67727d)),
                        ),
                        TextFormField(
                          cursorColor: Colors.white,
                          initialValue: initialTitle,
                          decoration: InputDecoration(
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
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Enter Amount",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff67727d)),
                                  ),
                                  TextFormField(
                                    cursorColor: Colors.black,
                                    initialValue: initialAmount,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
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
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.circular(15)),
                                child: IconButton(
                                  onPressed: () {
                                    if (!_transactionKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    _transactionKey.currentState!.save();
                                    AddTransaction(
                                      _title,
                                      _amount,
                                      _isIncome,
                                      _dateTime,
                                      transactionCategories[activeCategory]
                                          ['name'],
                                    );
                                    DeleteTransaction(
                                        initialTitle,
                                        initialAmount,
                                        initialIsincome,
                                        initialDateTime,
                                        initialCategory,
                                        null);
                                    Navigator.pop(context);

                                    _transactionKey.currentState!.reset();
                                  },
                                  icon: Icon(Icons.check),
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
