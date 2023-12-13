import 'package:budgetbuddy/screens/bottomnavigationbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'Montserrat',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme:
              const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
          snackBarTheme: const SnackBarThemeData(
              contentTextStyle: TextStyle(color: Colors.white)),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: const Color(0xFFFFC107), brightness: Brightness.dark)),
      darkTheme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'Montserrat',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme:
              const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
          snackBarTheme: const SnackBarThemeData(
              contentTextStyle: TextStyle(color: Colors.white)),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: const Color(0xFFFFC107), brightness: Brightness.dark)),
      debugShowCheckedModeBanner: false,
      title: 'Budget Buddy',
      home: const Bottom(),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
