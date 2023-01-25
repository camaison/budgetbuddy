import 'dart:ui';

import 'package:budgetbuddy/functions/addTransaction.dart';
import 'package:budgetbuddy/functions/create_budget_json.dart';
import 'package:budgetbuddy/functions/crudFunctions.dart';
import 'package:flutter/material.dart';

import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class AddNew extends StatefulWidget {
  const AddNew({super.key});

  @override
  State<AddNew> createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  int activeCategoryBudgets = 0;
  int activeCategoryTransactions = 0;
  late String title;
  List choices = ["Add Transaction", "Create Budget"];
  bool _isIncome = true;
  DateTime _dateTime = DateTime.now();
  late String _amount;
  late String _title;
  late String id;
  late String initialTitle;
  late String initialAmount;
  late var initialDateTime;
  final GlobalKey<FormState> _transactionKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _budgetKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                floating: true,
                expandedHeight: 70,
                backgroundColor: const Color(0xFF4A5859).withOpacity(0.3),
                title: TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), // Creates border

                    color: const Color(0xFFF4B860).withOpacity(0.1),
                  ),
                  tabs: [
                    ScreenTab(0),
                    ScreenTab(1),
                  ],
                ),
              ),
            ];
          },
          body: Stack(children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    //Color(0xFFC83E4D).withOpacity(0.1),
                    const Color(0xFFF4B860).withOpacity(0.2),
                    const Color(0xFF4A5859).withOpacity(0.3),
                  ],
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: TabBarView(children: [
                AddTransactionScreen(0),
                CreateBudgetScreen(1),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget ScreenTab(index) {
    List icons = [
      'assets/images/Transaction.png',
      'assets/images/Budget.png',
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: 40,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.withOpacity(0.15)),
              child: Center(
                child: Image.asset(
                  icons[index],
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                ),
              )),
          Container(
              width: 110,
              height: 60,
              child: Center(
                  child: Text(
                choices[index],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              )))
        ],
      ),
    );
  }

  Widget CreateBudgetScreen(index) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration:
                BoxDecoration(color: const Color(0xFFF4B860), boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.01),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Create Budget",
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
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(budgetCategories.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    activeCategoryBudgets = index;
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
                        color: Colors.grey.withOpacity(0.1),
                        border: Border.all(
                            width: 2,
                            color: activeCategoryBudgets == index
                                ? const Color(0xFFF4B860)
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
                                  budgetCategories[index]['icon'],
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.contain,
                                ),
                              )),
                          Text(
                            budgetCategories[index]['name'],
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
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Form(
                key: _budgetKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "End Date & Time",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(width: 2, color: Colors.transparent)),
                      width: 300,
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
                              initialTime: TimeOfDay.fromDateTime(_dateTime),
                              builder: (BuildContext context, Widget? child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(),
                                  child: child!,
                                );
                              });
                          setState(() {
                            _dateTime = DateTime(newDate!.year, newDate.month,
                                newDate.day, newTime!.hour, newTime.minute);
                          });
                        },
                        child: Text(
                          'Date: ${_dateTime.day}/${_dateTime.month}/${_dateTime.year}      Time: ${_dateTime.hour}:${_dateTime.minute}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        color: Colors.white, height: 1, width: double.infinity),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Budget Name",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    TextFormField(
                      cursorColor: Colors.white,
                      initialValue: '',
                      decoration: const InputDecoration(
                          hintText: "Enter Budget Name",
                          border: InputBorder.none),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Enter a Budget Name';
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
                        color: Colors.white, height: 1, width: double.infinity),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: (size.width - 140),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Budget Limit",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              TextFormField(
                                cursorColor: Colors.white,
                                initialValue: '',
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter a Budget Limit',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an Budget Limit';
                                  }
                                  if (double.tryParse(text) == null) {
                                    return 'Enter a valid Limit';
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
                              onPressed: () {
                                if (!_budgetKey.currentState!.validate()) {
                                  return;
                                }
                                _budgetKey.currentState!.save();
                                CreateBudget(
                                  _title,
                                  _amount,
                                  _dateTime,
                                  budgetCategories[activeCategoryBudgets]
                                      ['name'],
                                );
                                _budgetKey.currentState!.reset();
                              },
                              icon: const Icon(Icons.arrow_forward),
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget AddTransactionScreen(index) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration:
                const BoxDecoration(color: const Color(0xFFF4B860), boxShadow: [
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Add Transaction",
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
                children: List.generate(transactionCategories.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    activeCategoryTransactions = index;
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
                        color: Colors.grey.withOpacity(0.1),
                        border: Border.all(
                            width: 2,
                            color: activeCategoryTransactions == index
                                ? const Color(0xFFF4B860)
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
                              if (newDate == null) return;
                              TimeOfDay? newTime = await showTimePicker(
                                  context: context,
                                  initialTime:
                                      TimeOfDay.fromDateTime(_dateTime),
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(),
                                      child: child!,
                                    );
                                  });
                              setState(() {
                                _dateTime = DateTime(
                                    newDate.year,
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
                          value: true,
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
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    TextFormField(
                      cursorColor: Colors.white,
                      initialValue: '',
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
                        Container(
                          width: (size.width - 140),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Enter Amount",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              TextFormField(
                                cursorColor: Colors.black,
                                initialValue: '',
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
                              onPressed: () {
                                if (!_transactionKey.currentState!.validate()) {
                                  return;
                                }
                                _transactionKey.currentState!.save();
                                AddTransaction(
                                  title: _title,
                                  amount: _amount,
                                  dateTime: _dateTime,
                                  isIncome: _isIncome,
                                  category: transactionCategories[
                                      activeCategoryTransactions]['name'],
                                );
                                _transactionKey.currentState!.reset();
                              },
                              icon: const Icon(Icons.arrow_forward),
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
