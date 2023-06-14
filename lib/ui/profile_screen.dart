import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.account_circle_outlined),
        title: Text("Profile"),
      ),
      // body: (Center(child: Text("Welcome"),)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage('https://example.com/avatar.jpg'), // Replace with user's avatar image URL
          ),
          SizedBox(height: 10),
          Text(
            'John Doe', // Replace with user's name
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Movie Enthusiast', // Replace with user's role or description
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorite Movies'),
            onTap: () {
              // Handle favorite movies action
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.watch_later),
            title: Text('Watchlist'),
            onTap: () {
              // Handle watchlist action
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Handle settings action
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}
