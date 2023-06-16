import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const BottomNavBar({
    Key key,
    this.selectedIndex = 0,
    this.onTabChanged,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // final GlobalKey _customNavBarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      // key: _customNavBarKey,
      // height: customNavigationBarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: GNav(
          rippleColor: Colors.grey[300],
          hoverColor: Colors.grey[100],
          gap: 8,
          haptic: true,
          activeColor: Colors.white,
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOutExpo,
          tabBackgroundColor: Colors.orange,
          color: Colors.grey,
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
              onPressed: () {
                widget.onTabChanged?.call(0);
              },
            ),
            GButton(
              icon: Icons.search,
              text: 'Search',
              onPressed: () {
                widget.onTabChanged?.call(1);
              },
            ),
            GButton(
              icon: Icons.favorite_border,
              text: 'Likes',
              onPressed: () {
                widget.onTabChanged?.call(2);
              },
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
              onPressed: () {
                widget.onTabChanged?.call(3);
              },
            ),
          ],
          selectedIndex: widget.selectedIndex,
        ),
      ),
    );
  }
}

