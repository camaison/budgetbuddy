import 'dart:ui';
import 'package:budgetbuddy/functions/sortData.dart';
import 'package:budgetbuddy/widgets/transaction_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions({super.key});

  @override
  State<AllTransactions> createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  bool isSelectedRecent = true;
  bool isSelectedAll = false;
  bool isSelectedIncome = false;
  bool isSelectedExpense = false;
  bool isYearSelected = false;
  bool isMonthSelected = false;
  List monthMenu = [];
  List dayMenu = [];
  List displayTransactions = [];
  List titles = ['Recent', 'All Transactions'];

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    await Future.delayed(const Duration(seconds: 2)).then((value) {
      if (SortData.allData.isEmpty) {
        return initData();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4B860),
        foregroundColor: Colors.white,
        title: Text(
          SortData.index > 1 ? titles[1] : titles[SortData.index],
          style: const TextStyle(color: Colors.white),
        ),
      ),
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
                child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(
                            (FirebaseAuth.instance.currentUser!.uid).toString())
                        .doc('transactions')
                        .get()
                        .asStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
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

                      if (snapshot.hasData) {
                        List allTransactions = [];
                        List transactionKeys = [];
                        SortData(snapshot);

                        List expenseTransactions = [];
                        List incomeTransactions = [];

                        for (int i = 0; i < allTransactions.length; i++) {
                          if (allTransactions[i]['isIncome'] == false) {
                            expenseTransactions
                                .add([transactionKeys[i], allTransactions[i]]);
                          } else {
                            incomeTransactions
                                .add([transactionKeys[i], allTransactions[i]]);
                          }
                        }
                        List options = [];
                        if (!SortData.loading) {
                          options = [
                            SortData.RecentTransactions(),
                            SortData.allTransactionsList(),
                            SortData.sortYear(),
                            SortData.sortMonth(),
                            SortData.sortDay(),
                          ];
                          displayTransactions = SortData.index < 2
                              ? options[SortData.index]
                              : options[SortData.index][0];
                        }

                        return SortData.loading
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: ShimmerLoading(),
                              )
                            : Column(
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FilterChip(
                                                selectedColor:
                                                    const Color(0xFFF4B860)
                                                        .withOpacity(0.6),
                                                label: const Text('Recent'),
                                                selected: isSelectedRecent,
                                                onSelected: (bool selected) {
                                                  setState(() {
                                                    isSelectedRecent = true;
                                                    isSelectedAll = false;
                                                    SortData.index = 0;
                                                  });
                                                },
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              FilterChip(
                                                selectedColor:
                                                    const Color(0xFFF4B860)
                                                        .withOpacity(0.6),
                                                label: const Text('All'),
                                                selected: isSelectedAll,
                                                onSelected: (bool selected) {
                                                  setState(() {
                                                    isYearSelected = false;
                                                    isMonthSelected = false;
                                                    SortData.isYear = false;
                                                    SortData.yearHint = 'Year';
                                                    SortData.monthHint =
                                                        'Month';
                                                    SortData.dayHint = 'Day';
                                                    isSelectedAll = true;
                                                    isSelectedRecent = false;
                                                    SortData.index = 1;
                                                    SortData.currentDay = 0;
                                                    SortData.currentMonthIndex =
                                                        0;
                                                    SortData.currentYear = '';
                                                  });
                                                },
                                              ),
                                            ]),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FilterChip(
                                                selectedColor: Colors
                                                    .greenAccent
                                                    .withOpacity(0.3),
                                                label: const Text('Income'),
                                                selected:
                                                    SortData.isDisplayIncome,
                                                onSelected: (bool selected) {
                                                  setState(() {
                                                    displayTransactions =
                                                        options[SortData.index];
                                                    SortData.isDisplayIncome =
                                                        !SortData
                                                            .isDisplayIncome;
                                                    SortData.isDisplayExpense =
                                                        false;
                                                  });
                                                },
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              FilterChip(
                                                selectedColor: Colors.redAccent
                                                    .withOpacity(0.3),
                                                label: const Text('Expense'),
                                                selected:
                                                    SortData.isDisplayExpense,
                                                onSelected: (bool selected) {
                                                  setState(() {
                                                    displayTransactions =
                                                        options[SortData.index];
                                                    SortData.isDisplayExpense =
                                                        !SortData
                                                            .isDisplayExpense;
                                                    SortData.isDisplayIncome =
                                                        false;
                                                  });
                                                },
                                              ),
                                            ]),
                                      ]),
                                  isSelectedAll
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                              DropdownButton(
                                                hint: Text(SortData.yearHint),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                dropdownColor:
                                                    const Color(0xFF4A5859)
                                                        .withOpacity(0.9),
                                                items: SortData.yearMenu
                                                    .map((element) {
                                                  return DropdownMenuItem(
                                                      value: SortData.yearMenu
                                                          .indexOf(element),
                                                      child: Text(element));
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    SortData.isYear = false;
                                                    SortData.yearHint = 'Year';
                                                    SortData.monthHint =
                                                        'Month';
                                                    SortData.dayHint = 'Day';
                                                    isSelectedAll = true;
                                                    isSelectedRecent = false;
                                                    SortData.index = 1;
                                                    SortData.currentDay = 0;
                                                    SortData.currentMonthIndex =
                                                        0;
                                                    SortData.currentYear = '';
                                                    isYearSelected = false;
                                                    isMonthSelected = false;
                                                    value == 0
                                                        ? {
                                                            SortData.index = 1,
                                                          }
                                                        : {
                                                            isYearSelected =
                                                                true,
                                                            setState(() {
                                                              SortData
                                                                  .yearHint = SortData
                                                                      .yearMenu[
                                                                  value as int];

                                                              SortData.currentYear =
                                                                  SortData.yearMenu[
                                                                      value];
                                                              SortData.index =
                                                                  2;
                                                              monthMenu = SortData
                                                                  .sortYear()[1];
                                                            }),
                                                          };
                                                  });
                                                },
                                              ),
                                              isYearSelected
                                                  ? DropdownButton(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      dropdownColor:
                                                          const Color(
                                                                  0xFF4A5859)
                                                              .withOpacity(0.9),
                                                      hint: Text(
                                                          SortData.monthHint),
                                                      items: monthMenu
                                                          .map((element) {
                                                        return DropdownMenuItem(
                                                            value: element[1],
                                                            child: Text(
                                                                element[0]));
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          SortData.currentDay =
                                                              0;
                                                          SortData.dayHint =
                                                              'Day';
                                                          SortData.monthHint =
                                                              monthMenu[value
                                                                  as int][0];
                                                          isMonthSelected =
                                                              false;
                                                          value == 0
                                                              ? SortData.index =
                                                                  2
                                                              : {
                                                                  isMonthSelected =
                                                                      true,
                                                                  setState(() {
                                                                    SortData.currentMonthIndex =
                                                                        value;
                                                                    SortData
                                                                        .index = 3;
                                                                    dayMenu =
                                                                        SortData
                                                                            .sortMonth()[1];
                                                                  }),
                                                                };
                                                        });
                                                      })
                                                  : Container(),
                                              isMonthSelected && isYearSelected
                                                  ? DropdownButton(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      dropdownColor:
                                                          const Color(
                                                                  0xFF4A5859)
                                                              .withOpacity(0.9),
                                                      hint: Text(
                                                          SortData.dayHint),
                                                      items: dayMenu
                                                          .map((element) {
                                                        return DropdownMenuItem(
                                                            value: element[1],
                                                            child: Text(
                                                                element[0]));
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          SortData.currentDay =
                                                              0;
                                                          SortData.dayHint =
                                                              'Day';
                                                          SortData.index = 3;
                                                          if (value as int >
                                                              0) {
                                                            setState(() {
                                                              SortData.dayHint =
                                                                  dayMenu[value]
                                                                      [0];
                                                              SortData.currentDay =
                                                                  value;
                                                              SortData.index =
                                                                  4;
                                                              SortData
                                                                  .sortDay();
                                                            });
                                                          }
                                                        });
                                                      },
                                                    )
                                                  : Container(),
                                            ])
                                      : Container(),
                                  displayTransactions.isEmpty
                                      ? const Expanded(
                                          child: Center(
                                            child: Text(
                                              'No Transactions',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        )
                                      : Expanded(
                                          //listview builder
                                          child: Scrollbar(
                                            interactive: true,
                                            thumbVisibility: true,
                                            child: ListView.builder(
                                                itemCount:
                                                    displayTransactions.length,
                                                itemBuilder: (context, index) {
                                                  return TransactionTile(
                                                    transactionName:
                                                        displayTransactions[
                                                            index][1]['Title'],
                                                    money: displayTransactions[
                                                        index][1]['Amount'],
                                                    dateTime: DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            displayTransactions[
                                                                        index]
                                                                    [1]['Date']
                                                                .millisecondsSinceEpoch),
                                                    isIncome:
                                                        displayTransactions[
                                                                index][1]
                                                            ['isIncome'],
                                                    transactionId:
                                                        displayTransactions[
                                                            index][0],
                                                    category:
                                                        displayTransactions[
                                                                index][1]
                                                            ['Category'],
                                                  );
                                                }),
                                          ),
                                        ),
                                ],
                              );
                      }
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ShimmerLoading(),
                      );
                    })))
      ]),
    );
  }

  Widget ShimmerLoading() {
    return Shimmer(
      enabled: true,
      direction: ShimmerDirection.ltr,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF4A5859).withOpacity(0.3),
          const Color(0xFFF4B860).withOpacity(0.2),
          Colors.grey.withOpacity(0.1),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
              ),
            ]),
          ]),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Container(
                    height: 80,
                    child: ListTile(
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
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
