import 'dart:ui';
import 'package:budgetbuddy/functions/sortData.dart';
import 'package:budgetbuddy/functions/weekManager.dart';
import 'package:budgetbuddy/screens/allTransactions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../functions/getGreeting.dart';
import '../widgets/transaction_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

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

  @override
  Widget build(context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          print("Refreshed");
        });
      },
      child: Scaffold(
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
            child: SafeArea(
              top: false,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(FirebaseAuth.instance.currentUser!.uid)
                      .doc('transactions')
                      .get()
                      .asStream(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    WeekManager.getWeekInfo(DateTime(
                        DateTime.now().year, DateTime.now().month, 31));
                    if (snapshot.hasError) {
                      return const SnackBar(
                          content: Text('Something went wrong'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ShimmerLoading();
                    }

                    Map requiredTransactions = snapshot.data!.data() as Map;
                    List recentData = requiredTransactions != null
                        ? requiredTransactions['recent']
                        : [];
                    // return a scrollable column
                    return SingleChildScrollView(
                        child: Column(
                      children: [
                        Head(),
                        const SizedBox(height: 20),
                        Card(requiredTransactions),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Transactions',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 19,
                                  color: Colors.white70,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AllTransactions()));
                                  SortData.index = 0;
                                  SortData.isDisplayIncome = false;
                                  SortData.isDisplayExpense = false;
                                  // SortData.dayHint = 'Day';
                                  // SortData.monthHint = 'Month';
                                  // SortData.yearHint = 'Year';
                                },
                                child: const Text(
                                  'See all',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        recentData.length > 0
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
                      ],
                    ));
                  }),
            ),
          ),
        ]),
      ),
    );
  }

  Widget TransactionsBlock(List recentTransactions) {
    List<String> keys = [];
    List<Map> values = [];

    for (int i = 0; i < recentTransactions.length; i++) {
      keys.add(recentTransactions[i].keys.first);
      values.add(recentTransactions[i].values.first);
    }

    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount:
            recentTransactions.length > 6 ? 6 : recentTransactions.length,
        itemBuilder: (context, index) {
          return TransactionTile(
            transactionName: values[index]['Title'],
            money: values[index]['Amount'],
            dateTime: DateTime.fromMillisecondsSinceEpoch(
                values[index]['Date'].millisecondsSinceEpoch),
            isIncome: values[index]['isIncome'],
            transactionId: keys[index],
            category: values[index]['Category'],
          );
        });
  }

  Widget Card(Map requiredTransactions) {
    double expense = requiredTransactions['expense'].toDouble() ?? 0.00;
    double income = requiredTransactions['income'].toDouble() ?? 0.00;
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
                  color: Colors.orangeAccent.withOpacity(0.05),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
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
                            children: const [
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

  Widget ShimmerLoading() {
    return Shimmer(
        //period: Duration(seconds: 1),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4A5859).withOpacity(0.3),
            Colors.orangeAccent.withOpacity(0.2),
            Colors.grey.withOpacity(0.1),
          ],
        ),
        child: Column(children: [
          Container(
            width: double.infinity,
            height: 160,
            decoration: const BoxDecoration(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      height: 65,
                      width: 65,
                      color: Colors.transparent,
                      child: const CircleAvatar(
                        radius: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 20, top: 30),
                          child: Column(children: [
                            Container(
                              height: 20,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 20,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ])),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
        ]));
  }

  Widget Head() {
    late String picUrl;
    late String name;

    return Container(
      width: double.infinity,
      height: 160,
      decoration: const BoxDecoration(
        color: Colors.orangeAccent,
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
                    backgroundImage: AssetImage('assets/images/Test.jpg'),
                  ),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 60, left: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<dynamic>(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc('test@test.com')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError || !snapshot.hasData) {
                            print(snapshot.error); //returns null
                            return const Text('Something Went Wrong...');
                          }
                          return Container(
                              margin: const EdgeInsets.only(left: 20, top: 30),
                              child: Column(children: [
                                Text(GetGreeting().getGreeting(),
                                    style: const TextStyle(
                                      fontSize: 22,
                                    )),
                                const Text("Cyprian Maison",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.white,
                                    ))
                              ]));
                        }),
                  ])),
        ],
      ),
    );
  }
}
