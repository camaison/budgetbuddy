import 'dart:ui';
import 'package:budgetbuddy/Theme/constants.dart';
import 'package:budgetbuddy/functions/sortData.dart';
import 'package:budgetbuddy/functions/weekManager.dart';
import 'package:budgetbuddy/screens/allTransactions.dart';
import 'package:budgetbuddy/screens/profileScreen.dart';
import 'package:budgetbuddy/database/database_functions.dart';
import 'package:flutter/material.dart';
import '../functions/getGreeting.dart';
import '../widgets/transaction_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:budgetbuddy/backup/backup_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  List data = [];
  List expenseList = [];
  static bool isPopped = false;

  late List recentData = [];

  @override
  Widget build(context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF4B860).withOpacity(0.2),

              const Color(0xFF4A5859).withOpacity(0.3),

              //const Color(0xFF4A5859).withOpacity(0.3),
              //Color(0xFFC83E4D).withOpacity(0.1),
              // const Color(0xFFF4B860).withOpacity(0.1)
            ],
          ),
        ),
      ),
      BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                  child: Column(children: [
                Head(),
                const SizedBox(height: 20),
                // get all Transactions  suing _getallTransactions() from database and store in recentData
                FutureBuilder(
                    future: DatabaseFunctions.instance.getTransactionList(),
                    builder: (context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.hasData) {
                        recentData = snapshot.data!;
                        return Column(children: [
                          Card(),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Recent Transactions',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Colors.white70,
                                    )),
                                GestureDetector(
                                  onTap: () {
                                    //Open Backup Screen
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BackupPage()));

                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const AllTransactions()));
                                    SortData.index = 0;
                                    SortData.isDisplayIncome = false;
                                    SortData.isDisplayExpense = false;
                                    SortData.isYear = false;
                                    SortData.yearHint = 'Year';
                                    SortData.monthHint = 'Month';
                                    SortData.dayHint = 'Day';
                                    SortData.currentDay = 0;
                                    SortData.currentMonthIndex = 0;
                                    SortData.currentYear = '';
                                    SortData.isYear = false;
                                  },
                                  child: const Text(
                                    'See all',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Color(0xFFF4B860),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          recentData.isNotEmpty
                              ? SizedBox(
                                  //margin: EdgeInsets.only(left: 5, right: 5),
                                  height: 400,
                                  child: TransactionsBlock(recentData))
                              : const SizedBox(
                                  height: 390,
                                  child: Center(
                                      child: Text(
                                    "No Transactions",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ))),
                          const SizedBox(height: 5),
                        ]);
                      } else {
                        return ShimmerLoading(context);
                      }
                    }),

                // Column(children: [
                //   Card(requiredTransactions),
                //   const SizedBox(height: 20),
                //   Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 15),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         const Text('Recent Transactions',
                //             style: TextStyle(
                //               fontWeight: FontWeight.w500,
                //               fontSize: 18,
                //               color: Colors.white70,
                //             )),
                //         GestureDetector(
                //           onTap: () {
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) =>
                //                         const AllTransactions()));
                //             SortData.index = 0;
                //             SortData.isDisplayIncome = false;
                //             SortData.isDisplayExpense = false;
                //             SortData.isYear = false;
                //             SortData.yearHint = 'Year';
                //             SortData.monthHint = 'Month';
                //             SortData.dayHint = 'Day';
                //             SortData.currentDay = 0;
                //             SortData.currentMonthIndex = 0;
                //             SortData.currentYear = '';
                //             SortData.isYear = false;
                //           },
                //           child: const Text(
                //             'See all',
                //             style: TextStyle(
                //               fontWeight: FontWeight.w600,
                //               fontSize: 15,
                //               color: Color(0xFFF4B860),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                //   const SizedBox(height: 10),
                //   recentData.isNotEmpty
                //       ? SizedBox(
                //           //margin: EdgeInsets.only(left: 5, right: 5),
                //           height: 400,
                //           child: TransactionsBlock(recentData))
                //       : const SizedBox(
                //           height: 390,
                //           child: Center(
                //               child: Text(
                //             "No Transactions",
                //             style: TextStyle(
                //                 color: Colors.grey,
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.bold),
                //           ))),
                //     const SizedBox(height: 5),
                //   ])
                // ]))))
              ]))))
    ]));
  }
}

Widget TransactionsBlock(List recentTransactions) {
  return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: recentTransactions.length,
      itemBuilder: (context, index) {
        return TransactionTile(
          transactionName: recentTransactions[index]['title'],
          money: recentTransactions[index]['amount'].toString(),
          dateTime: DateTime.parse(recentTransactions[index]['date_time']),
          isIncome:
              recentTransactions[index]['type'] == "Income" ? true : false,
          transactionId: recentTransactions[index]['transaction_id'],
          category: recentTransactions[index]['category'],
        );
      });
}

Widget Card() {
  double income = 0;
  double expense = 0;

  Widget CardWidget() {
    return SizedBox(
        height: 185,
        width: 320,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.withOpacity(0.1),
                  /*gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF4A5859).withOpacity(0.3),
                        Color(0xFFC83E4D).withOpacity(0.1),
                        //Color(0xFFF4B860).withOpacity(0.1)
                      ],
                        ),
                       */
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Balance',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          // IconButton(
                          //   icon: Icon(Icons.more_horiz),
                          //   color: Colors.white,
                          //   onPressed: (() {}),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Text(
                            '₵ ${(income - expense).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor:
                                    Color.fromARGB(255, 52, 63, 62),
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.green,
                                  size: 19,
                                ),
                              ),
                              SizedBox(width: 7),
                              Text(
                                'Income',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 216, 216, 216),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor:
                                    Color.fromARGB(255, 52, 63, 62),
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.red,
                                  size: 19,
                                ),
                              ),
                              SizedBox(width: 7),
                              Text(
                                'Expenses',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 216, 216, 216),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\₵ ${income.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '₵ ${expense.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ])));
  }

  return FutureBuilder(
      future: DatabaseFunctions.instance.getIncomeExpenseTotal(),
      builder: (context, AsyncSnapshot<Map<String, double>> snapshot) {
        if (snapshot.hasData) {
          income = snapshot.data!['income']!;
          expense = snapshot.data!['expense']!;
          return CardWidget();
        } else {
          return ShimmerLoading(context);
        }
      });
}

Widget ShimmerLoading(context) {
  return SizedBox(
    //fit height to bottom of screen
    height: MediaQuery.of(context).size.height - 200,

    child: Shimmer(
        //period: Duration(seconds: 1),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFC83E4D).withOpacity(0.1),
            const Color(0xFFF4B860).withOpacity(0.2),
            const Color(0xFF4A5859).withOpacity(0.3),
          ],
        ),
        child: Column(children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 185,
            width: 320,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.white,
                )),
          ),
          const SizedBox(height: 20),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 20,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    title: Container(
                      height: 20,
                      width: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    subtitle: Container(
                      height: 20,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    trailing: Container(
                      height: 20,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }),
          )
        ])),
  );
}

Widget Head() {
  return Container(
      width: double.infinity,
      height: 160,
      decoration: const BoxDecoration(
        color: Color(0xFFF4B860),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 55,
            left: 300,
            child: GestureDetector(
              onTap: () {
                // final date = //DateTime.now();
                //     DateTime.parse('2023-02-28 15:43:03.887');

                // WeekManager(DateTime.now()).test(date);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  height: 65,
                  width: 65,
                  color: Colors.transparent,
                  child: const CircleAvatar(
                      radius: 15,
                      backgroundImage:
                          AssetImage('assets/images/placeholder.jpg')),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 60, left: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 20, top: 20),
                        child: Column(children: [
                          Text(GetGreeting().getGreeting(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 22,
                              )),
                          const Text(
                            "Test User",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        ]))
                  ])),
        ],
      ));
}
              
          
              // return Shimmer(
              //     //period: Duration(seconds: 1),
              //     gradient: LinearGradient(
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //       colors: [
              //         const Color(0xFFC83E4D).withOpacity(0.1),
              //         const Color(0xFFF4B860).withOpacity(0.2),
              //         const Color(0xFF4A5859).withOpacity(0.3),
              //       ],
              //     ),
              //     child: Column(children: [
              //       Container(
              //         width: double.infinity,
              //         height: 160,
              //         decoration: const BoxDecoration(
              //           borderRadius: BorderRadius.only(
              //             bottomLeft: Radius.circular(10),
              //             bottomRight: Radius.circular(10),
              //           ),
              //         ),
              //         child: Stack(
              //           children: [
              //             Positioned(
              //               top: 55,
              //               left: 300,
              //               child: ClipRRect(
              //                 borderRadius: BorderRadius.circular(7),
              //                 child: Container(
              //                   margin: const EdgeInsets.only(top: 30),
              //                   height: 65,
              //                   width: 65,
              //                   color: Colors.transparent,
              //                   child: const CircleAvatar(
              //                     radius: 15,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             const SizedBox(height: 10),
              //             Padding(
              //               padding: const EdgeInsets.only(top: 60, left: 10),
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Container(
              //                       margin: const EdgeInsets.only(
              //                           left: 20, top: 30),
              //                       child: Column(children: [
              //                         Container(
              //                           height: 20,
              //                           width: 200,
              //                           decoration: BoxDecoration(
              //                             color: Colors.grey,
              //                             borderRadius:
              //                                 BorderRadius.circular(10),
              //                           ),
              //                         ),
              //                         const SizedBox(height: 10),
              //                         Container(
              //                           height: 20,
              //                           width: 150,
              //                           decoration: BoxDecoration(
              //                             color: Colors.grey,
              //                             borderRadius:
              //                                 BorderRadius.circular(10),
              //                           ),
              //                         ),
              //                       ])),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ]));
 
