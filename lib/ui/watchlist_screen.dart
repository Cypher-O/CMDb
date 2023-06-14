import 'package:flutter/material.dart';

class WatchListScreen extends StatelessWidget {
  const WatchListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.account_circle_outlined),
        title: Text("Favorites"),
      ),
      body: (Center(child: Text("Welcome"),)),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}
