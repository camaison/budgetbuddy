import 'package:budgetbuddy/functions/crudFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SortData {
  final AsyncSnapshot<DocumentSnapshot> snapshot;
  static Map allData = {};
  static List recentData = [];
  static int index = 0;
  static bool loading = true;
  static bool isDisplayIncome = false;
  static bool isDisplayExpense = false;
  static List yearData = [];
  static List monthData = [];
  static List dayData = [];
  static List yearMenu = [];
  static String currentYear = "";
  static int currentMonthIndex = 0;
  static int currentDay = 0;
  static String dayHint = 'Day';
  static String monthHint = 'Month';
  static String yearHint = 'Year';
  static bool isYear = false;
  static List dayKeys = [];

  SortData(this.snapshot) {
    if ((snapshot.data?['recent']).length == 0) {
      loading = false;
    }
    List years = snapshot.data!['years'];
    if (allData.isEmpty || recentData.isEmpty) {
      recentData = snapshot.data!['recent'];
      for (String year in years) {
        snapshot.data!.reference.collection(year).get().then((value) {
          Map tempData = {};
          for (DocumentSnapshot doc in value.docs) {
            tempData.addAll({doc.id: doc.data()});
          }
          allData.addAll({year: tempData});
          //menuData.addAll({year: tempData.keys.toList()});
        });
      }
    }
    years.sort((a, b) => b.compareTo(a));
    if (allData.isNotEmpty) {
      loading = false;
    }
    yearMenu = ["Year", ...years];

    print({
      "Current Year: $currentYear, Current Month: $currentMonthIndex, Current Day: $currentDay"
    });
  }
  static RecentTransactions() {
    List recent = [];
    List recentIncome = [];
    List recentExpense = [];

    for (Map element in recentData) {
      recent.add([element.keys.first, element.values.first]);
      if (element.values.first['isIncome']) {
        recentIncome.add([element.keys.first, element.values.first]);
      } else {
        recentExpense.add([element.keys.first, element.values.first]);
      }
    }
    if (isDisplayIncome) {
      return recentIncome;
    } else if (isDisplayExpense) {
      return recentExpense;
    } else {
      return recent;
    }
  }

  static allTransactionsList() {
    List allTransactions = [];
    List allTransactionsIncome = [];
    List allTransactionsExpense = [];
    allData.forEach((key, year) {
      year.forEach((key, month) {
        month.forEach((key, day) {
          day.forEach((key, value) {
            allTransactions.add([key, value]);
            if (value['isIncome']) {
              allTransactionsIncome.add([key, value]);
            } else {
              allTransactionsExpense.add([key, value]);
            }
          });
        });
      });
    });
    allTransactions.sort((a, b) {
      return b[1]['Date'].compareTo(a[1]['Date']);
    });
    allTransactionsIncome.sort((a, b) {
      return b[1]['Date'].compareTo(a[1]['Date']);
    });
    allTransactionsExpense.sort((a, b) {
      return b[1]['Date'].compareTo(a[1]['Date']);
    });

    if (isYear) {
      allTransactions = allTransactions;
    }
    if (isDisplayIncome) {
      return allTransactionsIncome;
    } else if (isDisplayExpense) {
      return allTransactionsExpense;
    } else {
      return allTransactions;
    }
  }

  static sortDay() {
    List val;
    int index = currentDay;
    String month;
    String day;
    List dayTransactions = [];
    List dayTransactionsIncome = [];
    List dayTransactionsExpense = [];
    index == 0
        ? val = []
        : {
            month = allData[currentYear].keys.toList()[currentMonthIndex - 1],
            day = dayKeys[index - 1],
            if (allData[currentYear][month][day] == null)
              {
                dayData = [],
              }
            else
              {
                allData[currentYear][month][day].forEach((key, value) {
                  dayTransactions.add([key, value]);
                  if (value['isIncome']) {
                    dayTransactionsIncome.add([key, value]);
                  } else {
                    dayTransactionsExpense.add([key, value]);
                  }
                }),
                if (isDisplayIncome)
                  {
                    dayData = dayTransactionsIncome,
                  }
                else if (isDisplayExpense)
                  {
                    dayData = dayTransactionsExpense,
                  }
                else
                  {
                    dayData = dayTransactions,
                  },
                dayData.sort((a, b) {
                  return b[1]['Date'].compareTo(a[1]['Date']);
                }),
              },
            val = [dayData, []],
          };
    return val;
  }

  static List sortMonth() {
    List val;
    int index = currentMonthIndex;
    List monthTransactions = [];
    List monthTransactionsIncome = [];
    List monthTransactionsExpense = [];
    String month;
    List days = [];
    index == 0
        ? val = []
        : {
            month =
                allData[currentYear].keys.toList()[sortYear()[1][index][1] - 1],
            dayKeys = allData[currentYear][month].keys.toList(),
            dayKeys.sort((a, b) => a.compareTo(b)),
            for (int i = 0; i < dayKeys.length; i++)
              {
                days.add([dayKeys[i], i + 1]),
              },
            if (allData[currentYear][month] == null)
              {
                monthData = [],
              }
            else
              {
                allData[currentYear][month].forEach((key, value) {
                  value.forEach((key, value) {
                    monthTransactions.add([key, value]);
                    if (value['isIncome']) {
                      monthTransactionsIncome.add([key, value]);
                    } else {
                      monthTransactionsExpense.add([key, value]);
                    }
                  });
                }),
                if (isDisplayIncome)
                  {
                    monthData = monthTransactionsIncome,
                  }
                else if (isDisplayExpense)
                  {
                    monthData = monthTransactionsExpense,
                  }
                else
                  {
                    monthData = monthTransactions,
                  },
                monthData.sort((a, b) {
                  return b[1]['Date'].compareTo(a[1]['Date']);
                }),
              },
            days.sort((a, b) {
              return a[0].compareTo(b[0]);
            }),
            val = [
              monthData,
              [
                ["Day", 0],
                ...days
              ]
            ],
          };
    return val;
  }

  static List sortYear() {
    List val;
    String year = currentYear;
    List yearTransactions = [];
    List yearTransactionsIncome = [];
    List yearTransactionsExpense = [];
    List monthWords = [];
    List months = [];
    currentYear == ''
        ? val = []
        : {
            months = allData[year].keys.toList(),
            months.sort((a, b) => a.compareTo(b)),
            for (int i = 0; i < months.length; i++)
              {
                monthWords.add([
                  ConvertDateTime.convertMonth(int.parse(months[i])),
                  i + 1
                ]),
              },
            if (allData[year] == null)
              {
                yearData = [],
              }
            else
              {
                allData[year].forEach((key, value) {
                  value.forEach((key, value) {
                    value.forEach((key, value) {
                      yearTransactions.add([key, value]);
                      if (value['isIncome']) {
                        yearTransactionsIncome.add([key, value]);
                      } else {
                        yearTransactionsExpense.add([key, value]);
                      }
                    });
                  });
                }),
                if (isDisplayIncome)
                  {
                    yearData = yearTransactionsIncome,
                  }
                else if (isDisplayExpense)
                  {
                    yearData = yearTransactionsExpense,
                  }
                else
                  {
                    yearData = yearTransactions,
                  },
                yearData.sort((a, b) {
                  return b[1]['Date'].compareTo(a[1]['Date']);
                }),
              },
            isYear = true,
            val = [
              yearData,
              [
                ["Month", 0],
                ...monthWords
              ]
            ],
          };
    return val;
  }
}
