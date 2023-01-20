import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeekManager {
  static DocumentReference stats = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.uid.toString())
      .doc('statistics');
  Map monthDayNumber = {
    '1': 31,
    '2': 28,
    '3': 31,
    '4': 30,
    '5': 31,
    '6': 30,
    '7': 31,
    '8': 31,
    '9': 30,
    '10': 31,
    '11': 30,
    '12': 31,
  };

  static DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  static getWeekInfo(DateTime date) {
    List weeks = [];
    Map wk1 = {};
    Map wk5 = {};
    DateTime holder = DateTime(date.year, date.month, 1);
    while (holder.month == date.month ||
        (holder.month == date.month + 1 && holder.day < 7)) {
      List<DateTime> extremes = getWeek(holder);

      if (extremes[0].month == holder.month &&
          extremes[1].month == holder.month) {
        weeks.add(extremes);
      } else if (extremes[0].month ==
              (holder.month == 1 ? 12 : holder.month - 1) &&
          extremes[1].day <= 4) {
        wk5 = {
          5: [extremes, extremes[0].month, extremes[0].year]
        };
      } else {
        wk1 = {
          1: [extremes, extremes[1].month, extremes[1].year]
        };
      }
      holder = holder.add(Duration(days: 7));
    }
    for (var week in weeks) {
      if ((date.isAfter(week[0]) && date.isBefore(week[1])) ||
          (date.isAtSameMomentAs(week[0]) && date.isBefore(week[1]))) {
        return {
          weeks.indexOf(week) + 1: [week, date.month, date.year]
        };
      }
    }
    return date.day < 7 ? wk5 : wk1;
  }

  static getWeek(DateTime date) {
    DateTime endOfWeek = getDate(
        date.add(Duration(days: DateTime.daysPerWeek - date.weekday + 1)));
    DateTime startOfWeek =
        getDate(date.subtract(Duration(days: date.weekday - 1)));
    return [startOfWeek, endOfWeek];
  }

  static checkWeek() async {
    DateTime date = DateTime.now();
    DateTime endOfWeek = getDate(
        date.add(Duration(days: DateTime.daysPerWeek - date.weekday + 1)));
    DateTime startOfWeek =
        getDate(date.subtract(Duration(days: date.weekday - 1)));
    await stats.get().then((value) {
      value['start'] == null
          ? stats.set(
              {
                  'start': startOfWeek,
                },
              SetOptions(
                merge: true,
              ))
          : null;
      value['end'] == null
          ? stats.set(
              {
                  'end': endOfWeek,
                },
              SetOptions(
                merge: true,
              ))
          : null;

      DateTime start = value['start'].toDate();
      DateTime end = value['end'].toDate();
      if (DateTime.now().isAfter(end) ||
          DateTime.now().isAtSameMomentAs(end) ||
          DateTime.now().isBefore(start)) {
        print('Date: $date');
        print('Start of week: $startOfWeek');
        print('End of week: $endOfWeek');
        stats.set(
          {
            'start': startOfWeek,
            'end': endOfWeek,
            'thisWeek': {
              '1': {'income': '0', 'expense': '0'},
              '2': {'income': '0', 'expense': '0'},
              '3': {'income': '0', 'expense': '0'},
              '4': {'income': '0', 'expense': '0'},
              '5': {'income': '0', 'expense': '0'},
              '6': {'income': '0', 'expense': '0'},
              '7': {'income': '0', 'expense': '0'},
            },
          },
        );
      }
    });
  }
}
