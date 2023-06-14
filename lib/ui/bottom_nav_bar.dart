// import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
//
// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({Key key}) : super(key: key);
//
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//   int _selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: Container(
//         child: Padding(
//           padding:
//           const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
//           child: GNav(
//             rippleColor: Colors?.grey[300],
//             hoverColor: Colors?.grey[100],
//             gap: 8,
//             haptic: true,
//             activeColor: Colors.white,
//             iconSize: 24,
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             duration: Duration(milliseconds: 400),
//             curve: Curves.easeOutExpo,
//             tabBackgroundColor: Colors.orange,
//             color: Colors.grey,
//             tabs: [
//               GButton(
//                 icon: Icons.home,
//                 text: 'Home',
//                 onPressed: (){
//                   setState(() {
//                     _selectedIndex = 1;
//                   });
//                 },
//               ),
//               GButton(
//                 icon: Icons.search,
//                 text: 'Search',
//                 onPressed: (){
//                   setState(() {
//                     _selectedIndex = 2;
//                   });
//                 },
//               ),
//               GButton(
//                 icon: Icons.favorite_border,
//                 text: 'Likes',
//                 onPressed: (){
//                   setState(() {
//                     _selectedIndex = 3;
//                   });
//                 },
//               ),
//               GButton(
//                 icon: Icons.person,
//                 text: 'Profile',
//                 onPressed: (){
//                   setState(() {
//                     _selectedIndex = 4;
//                   });
//                 },
//               ),
//             ],
//             selectedIndex: _selectedIndex,
//             // onTabChange: (index) {
//             //   setState(() {
//             //     _selectedIndex = index;
//             //     // _pageController.jumpToPage(index);
//             //   });
//             // },
//             onTabChange: pagechange(),
//             // onTabChange: (index) {
//             //   setState(() {
//             //     _selectedIndex = index;
//             //   });
//             // },
//           ),
//         ),
//       ),
//     );
//   }
//   pagechange() {
//     if (_selectedIndex==1)
//     {
//       Navigator.pushNamed(context, 'home');
//     }
//     if (_selectedIndex==2)
//     {
//       Navigator.pushNamed(context, 'previous');
//     }
//     if (_selectedIndex==3)
//     {
//       Navigator.pushNamed(context, 'upcoming');
//     }
//     if (_selectedIndex==4)
//     {
//       Navigator.pushNamed(context, 'info');
//     }
//   }
// }


// import 'package:CMDb/ui/discover_screen.dart';
// import 'package:CMDb/ui/profile_screen.dart';
// import 'package:CMDb/ui/watchlist_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
//
// import 'home_screen.dart';
//
// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({Key key}) : super(key: key);
//
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//   int _selectedIndex = 0;
//
//   List<Widget> _pages = [
//     HomeScreen(), // Replace with your home screen widget
//     DiscoverScreen(), // Replace with your search screen widget
//     WatchListScreen(), // Replace with your likes screen widget
//     ProfileScreen(), // Replace with your profile screen widget
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: Container(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
//           child: GNav(
//             rippleColor: Colors.grey[300],
//             hoverColor: Colors.grey[100],
//             gap: 8,
//             haptic: true,
//             activeColor: Colors.white,
//             iconSize: 24,
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             duration: Duration(milliseconds: 400),
//             curve: Curves.easeOutExpo,
//             tabBackgroundColor: Colors.orange,
//             color: Colors.grey,
//             tabs: [
//               GButton(
//                 icon: Icons.home,
//                 text: 'Home',
//               ),
//               GButton(
//                 icon: Icons.search,
//                 text: 'Search',
//               ),
//               GButton(
//                 icon: Icons.favorite_border,
//                 text: 'Likes',
//               ),
//               GButton(
//                 icon: Icons.person,
//                 text: 'Profile',
//               ),
//             ],
//             selectedIndex: _selectedIndex,
//             onTabChange: (index) {
//               setState(() {
//                 _selectedIndex = index;
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }





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

