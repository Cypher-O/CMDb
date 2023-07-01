import 'package:CMDb/ui/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Account Settings",
                style: TextStyle(fontSize: 16.0, color: Colors.white70),
              ),
              SizedBox(
                height: 20.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.account_circle_outlined),
                  title: Text('Profile'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Get.to(
                      () => ProfileScreen(),
                      transition: Transition.rightToLeftWithFade,
                      // duration: Duration(milliseconds: 500),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.my_library_books_outlined),
                  title: Text('Account Information'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle favorite movies action
                  },
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Contact Details",
                style: TextStyle(fontSize: 16.0, color: Colors.white70),
              ),
              SizedBox(
                height: 20.0,
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.mail_outline_rounded),
                  title: Text('Email Address'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle watchlist action
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.phone_outlined),
                  title: Text('Phone Number'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle settings action
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: Text("Residential Address"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle settings action
                  },
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Security Settings",
                style: TextStyle(fontSize: 16.0, color: Colors.white70),
              ),
              SizedBox(
                height: 20.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.password_outlined),
                  title: Text('Passwsord Reset'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle favorite movies action
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.lock_outline_rounded),
                  title: Text('Face ID and PIN'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle favorite movies action
                  },
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "App Settings",
                style: TextStyle(fontSize: 16.0, color: Colors.white70),
              ),
              SizedBox(
                height: 20.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.color_lens_outlined),
                  title: Text('Theme'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle favorite movies action
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.notifications_none_rounded),
                  title: Text('Notifications'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle favorite movies action
                  },
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "General",
                style: TextStyle(fontSize: 16.0, color: Colors.white70),
              ),
              SizedBox(
                height: 20.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.safety_check_outlined),
                  title: Text('Help and Feedback'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle favorite movies action
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.speaker_notes_outlined),
                  title: Text('Community Guidelines'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle favorite movies action
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(Icons.miscellaneous_services_outlined),
                  title: Text('Terms of Service'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle favorite movies action
                  },
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Log out',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w900),
                  ),
                  onTap: () {
                    // Handle favorite movies action
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
