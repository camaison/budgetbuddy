import 'package:budgetbuddy/Authentication/pages/login_page.dart';
import 'package:budgetbuddy/functions/crudFunctions.dart';
import 'package:budgetbuddy/functions/weekManager.dart';
import 'package:budgetbuddy/screens/bottomnavigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            const SnackBar(
              content: Text('User is logged in'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            );
            RefactorInactiveBudgets();
            WeekManager.checkWeek();
            return const Bottom();
          } else {
            const SnackBar(
              content: Text('User is currently logged out'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            );
            return const LoginPage();
          }
        },
      ),
    );
  }
}
