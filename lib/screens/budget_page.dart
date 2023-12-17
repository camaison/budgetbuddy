import 'dart:ui';
import 'package:budgetbuddy/database/transaction_item.dart';
import 'package:budgetbuddy/database/budget_item.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:budgetbuddy/database/database_functions.dart';

//import 'package:flutter_icons/flutter_icons.dart';

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  int activeCategory = 3;
  List activeBudgets = [];
  final DatabaseFunctions _dbFunctions = DatabaseFunctions.instance;

  _addTransactionItem(
      {required double amount,
      required String category,
      required String type,
      required String title,
      required String description}) async {
    TransactionItem transactionItem = TransactionItem(
      transactionId: DateTime.now().millisecondsSinceEpoch,
      dateTime: DateTime.now().toString(),
      amount: amount,
      category: category,
      type: type,
      title: title,
      createdDateTime: DateTime.now().toString(),
      description: description,
    );
    await _dbFunctions.insertTransaction(transactionItem.toMap());
  }

  //get all budgets
  _getAllBudgets() async {
    List budgets = await _dbFunctions.getBudgetList();
    setState(() {
      activeBudgets = budgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black.withOpacity(0.05),
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
                //Color(0xFFC83E4D).withOpacity(0.1),
              ],
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: SafeArea(
            top: false,
            child: DefaultTabController(
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
                          borderRadius:
                              BorderRadius.circular(20), // Creates border

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
                body: TabBarView(
                  children: [active(), history()],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget ScreenTab(index) {
    List choices = ['Active', 'History'];
    List icons = [
      'assets/images/activeBudgets.png',
      'assets/images/inactiveBudgets.png',
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

  Widget activeShimmer() {
    return Expanded(
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

      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color(0xFF4A5859).withOpacity(
                                0.15), //Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.01),
                                spreadRadius: 10,
                                blurRadius: 3,
                                // changes position of shadow
                              ),
                            ]),
                        child:
                            // A list tile displaying budget title, current amount, limit, and percentage with progress bar
                            Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, bottom: 25, top: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 15,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Container(
                                      height: 20,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Stack(
                                children: [
                                  Container(
                                    width: 600,
                                    height: 5,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color(0xff67727d)
                                            .withOpacity(0.4)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                ],
              ));
        },
      ),
    ));
  }

  Widget active() {
    var size = MediaQuery.of(context).size;

    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        //width: (size.width - 140),
        decoration: BoxDecoration(color: const Color(0xFFF4B860), boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.01),
            spreadRadius: 10,
            blurRadius: 3,
            // changes position of shadow
          ),
        ]),
        child: const Padding(
          padding: EdgeInsets.only(top: 60, right: 20, left: 20, bottom: 25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Active Budgets",
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
      Expanded(
          child: activeBudgets.isEmpty
              ? const Center(
                  child: Text('No Active Budgets',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontStyle: FontStyle.italic)))
              : Scrollbar(
                  interactive: true,
                  child: ListView.builder(
                      itemCount: activeBudgets.length,
                      itemBuilder: (context, index) {
                        activeBudgets[index].currentAmount <=
                                activeBudgets[index].limit
                            ? 1 -
                                (activeBudgets[index].currentAmount /
                                    activeBudgets[index].limit)
                            : 1;

                        return GestureDetector(onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    backgroundColor: const Color(0xFF4A5859)
                                        .withOpacity(0.8),
                                    title: const Text('Delete Budget'),
                                    content: const Text(
                                        'Are you sure you want to delete this budget?',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16))),
                                      TextButton(
                                          onPressed: () {},
                                          child: const Text("Delete"))
                                    ]);
                              });
                          //List the entries in activeBudgets
                        });
                      })))
    ]));
  }
  //return activeShimmer();

  Widget historyShimmer() {
    return Expanded(
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
            child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(8, (index) {
                  return Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A5859).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 20, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: RotatedBox(
                                  quarterTurns: -4,
                                  child: CircularPercentIndicator(
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.3),
                                    radius: 35,
                                    lineWidth: 4,
                                    percent: 0.6,
                                    progressColor: Colors.grey,
                                    center: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 20,
                                width: 80,
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
                          ),
                        ),
                      ));
                }))));
  }

  Widget history() {
    List data = [];
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        //width: (size.width - 140),
        decoration: BoxDecoration(color: const Color(0xFFF4B860), boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A5859).withOpacity(0.15),
            spreadRadius: 10,
            blurRadius: 3,
            // changes position of shadow
          ),
        ]),
        child: const Padding(
          padding: EdgeInsets.only(top: 60, right: 20, left: 20, bottom: 25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "History",
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
      Expanded(
          // child: StreamBuilder(
          //     stream: FirebaseFirestore.instance
          //         .collection(FirebaseAuth.instance.currentUser!.uid)
          //         .doc("budgets")
          //         .collection("inactive")
          //         .orderBy('End Date', descending: true)
          //         .snapshots(),
          //     builder: (BuildContext context,
          //         AsyncSnapshot<QuerySnapshot> snapshot) {
          //       if (!snapshot.hasData) {
          //         return Center(
          //           child: historyShimmer(),
          //         );
          //       } else {
          child: data.isEmpty
              ? const Center(
                  child: Text('No Inactive Budgets',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontStyle: FontStyle.italic)))
              : Scrollbar(
                  interactive: true,
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(
                        //snapshot.data!.docs.length,
                        20, (index) {
                      var percentage = 30;
                      // snapshot.data!.docs[index]
                      //             ['Current Amount'] <=
                      //         snapshot.data!.docs[index]['Limit']
                      //     ? 1 -
                      //         (snapshot.data!.docs[index]
                      //                 ['Current Amount'] /
                      //             snapshot.data!.docs[index]
                      //                 ['Limit'])
                      //     : 1;
                      bool isExceeded = false;
                      // snapshot.data!.docs[index]
                      //         ['Current Amount'] >
                      //     snapshot.data!.docs[index]['Limit'];
                      return GestureDetector(
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: const Color(0xFF4A5859)
                                        .withOpacity(0.8),
                                    title: const Text('Delete Budget'),
                                    content: const Text(
                                        'Are you sure you want to delete this budget?',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16))),
                                      TextButton(
                                          onPressed: () {
                                            // FirebaseFirestore
                                            //     .instance
                                            //     .collection(
                                            //         FirebaseAuth
                                            //             .instance
                                            //             .currentUser!
                                            //             .uid)
                                            //     .doc("budgets")
                                            //     .collection(
                                            //         "inactive")
                                            //     .doc(snapshot.data!
                                            //         .docs[index].id)
                                            //     .get()
                                            //     .then((budget) {
                                            //   FirebaseFirestore
                                            //       .instance
                                            //       .collection(
                                            //           FirebaseAuth
                                            //               .instance
                                            //               .currentUser!
                                            //               .uid)
                                            //       .doc("budgets")
                                            //       .get()
                                            //       .then(
                                            //           (value) => {
                                            //                 value.data()?[
                                            //                     'score'] = value
                                            //                         .data()?['score'] -
                                            //                     budget['score']
                                            //               });
                                            //   FirebaseFirestore
                                            //       .instance
                                            //       .collection(
                                            //           FirebaseAuth
                                            //               .instance
                                            //               .currentUser!
                                            //               .uid)
                                            //       .doc("budgets")
                                            //       .collection(
                                            //           "inactive")
                                            //       .doc(snapshot
                                            //           .data!
                                            //           .docs[index]
                                            //           .id)
                                            //       .delete();
                                            // });
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 16),
                                          )),
                                    ],
                                  );
                                });
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF4A5859).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25, top: 20, bottom: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Center(
                                        child: RotatedBox(
                                          quarterTurns: -4,
                                          child: CircularPercentIndicator(
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.3),
                                            radius: 35,
                                            lineWidth: 4,
                                            percent: percentage.toDouble(),
                                            progressColor: isExceeded
                                                ? Colors.red
                                                : Colors.green,
                                            center: const CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: 30,
                                              // backgroundImage:
                                              //     AssetImage(
                                              //         'assets/images/${snapshot.data!.docs[index]['Category']}.png'),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Title",
                                        // snapshot.data!.docs[index]
                                        //     ['Title'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "50",
                                        //"₵${snapshot.data!.docs[index]['Limit'] - snapshot.data!.docs[index]['Current Amount']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: isExceeded
                                                ? Colors.red
                                                // : snapshot.data!.docs[
                                                //                 index]
                                                //             [
                                                //             'Limit'] ==
                                                //         snapshot.data!
                                                //                 .docs[index]
                                                //             [
                                                //             'Current Amount']
                                                //:
                                                // ? Colors.white
                                                : Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              )));
                    }),
                  ),
                ))
    ]));
  }
}

/*ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          width: 150,
                          height: 170,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
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
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.withOpacity(0.15)),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/${snapshot.data!.docs[index]['Category']}.png',
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.contain,
                                      ),
                                    )),
                                Text(
                                  snapshot.data!.docs[index]['Category'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                                Text(
                                  "\$${snapshot.data!.docs[index]['Limit']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),*/

/*Container(
                    width: 400,
                    height: 400,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(
                            width: 150,
                            height: 130,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.withOpacity(0.15)),
                                      child: Center(
                                        child: Image.asset(
                                          'assets/images/${snapshot.data!.docs[index]['Category']}.png',
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.contain,
                                        ),
                                      )),
                                  Text(
                                    snapshot.data!.docs[index]['Category'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "\$${snapshot.data!.docs[index]['Limit']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ));
              }
            },
          ),
        ],
      ),
    );*/
