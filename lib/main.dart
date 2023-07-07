import 'package:CMDb/model/watch_list.dart';
import 'package:flutter/material.dart';
import 'package:CMDb/ui/home_screen.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.orange,
      accentColor: Colors.white,
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
        home: HomeScreen(),
      ),
    );
  }
}

