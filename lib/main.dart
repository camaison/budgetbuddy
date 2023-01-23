import 'package:budgetbuddy/Authentication/checkAuthState.dart';
import 'package:budgetbuddy/functions/sortData.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(<DeviceOrientation>[
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print(SortData.allData);
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
            primarySwatch: Colors.red,
            fontFamily: 'Montserrat',
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.dark),
            snackBarTheme: const SnackBarThemeData(
                contentTextStyle: TextStyle(color: Colors.white)),
            colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: const Color(0xFF4549BC),
                brightness: Brightness.dark)),
        /*ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'Montserrat',
          brightness: Brightness.light,
          scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBarTheme:
              const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
          snackBarTheme: const SnackBarThemeData(
              contentTextStyle: TextStyle(color: Colors.white)),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: const Color(colorPrimary),
              brightness: Brightness.light),
        ),*/
        darkTheme: ThemeData(
            primarySwatch: Colors.red,
            fontFamily: 'Montserrat',
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.light),
            snackBarTheme: const SnackBarThemeData(
                contentTextStyle: TextStyle(color: Colors.white)),
            colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: const Color(0xFF4549BC),
                brightness: Brightness.dark)),
        debugShowCheckedModeBanner: false,
        color: const Color(0xFF4549BC),
        title: 'Budget Buddy',
        home: const CheckAuth());
  }

  @override
  void initState() {
    super.initState();
  }
}










/*import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loginuispeedcode/imported_lib/data/model/add_date.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'auth/login.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AdddataAdapter());
  await Hive.openBox<Add_data>('data');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      // darkTheme: ThemeData(
      //   toggleableActiveColor: Color.fromRGBO(247, 35, 66, 1),
      //   //visualDensity: VisualDensity.adaptivePlatformDensity,
      //   colorScheme: ColorScheme.dark(
      //     primary: Color.fromRGBO(247, 35, 66, 1),
      //   ),
      // ),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        fontFamily: 'Montserrat',
      ),
    );
  }
}
*/