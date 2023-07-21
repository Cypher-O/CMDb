import 'package:CMDb/model/watch_list.dart';
import 'package:CMDb/ui/auth_page.dart';
import 'package:CMDb/ui/login_screen.dart';
import 'package:CMDb/ui/on_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:CMDb/ui/home_screen.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


int isviewed;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final themeData = ThemeData(
    //   brightness: Brightness.dark,
    //   primarySwatch: Colors.orange,
    //   accentColor: Colors.orange,
    // );

    final themeData = ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
      ).copyWith(
        secondary: Colors.orange,
        // brightness: Brightness.dark,
      ),
    );

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: themeData.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness:
        themeData.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
    );

    return ChangeNotifierProvider(
      create: (context) => WatchlistModel(),
      child: MaterialApp(
        title: 'CMDb',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: isviewed != 0 ? OnBoardScreen() : AuthPage(),
      ),
    );
  }
}

