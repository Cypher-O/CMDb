import 'package:CMDb/model/onboard.dart';
import 'package:CMDb/service/constants.dart';
import 'package:CMDb/ui/auth_page.dart';
import 'package:CMDb/ui/home_screen.dart';
import 'package:CMDb/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  int currentIndex = 0;
  PageController _pageController;
  List<OnBoard> screens = <OnBoard>[
    OnBoard(
      img: 'assets/images/oppenheimer.jpg',
      text: "Looking for the latest movies or show?",
      desc: "We have all what you are looking for, all genres and lots more...",
      button: Color(0xFF4756DF),
    ),
    OnBoard(
      img: 'assets/images/wednesday.jpg',
      text: "Explore and search for known movies or shows",
      desc: "Search for whatever you are intrigued by, no limit to regions or language...",
      button: Colors.white,
    ),
    OnBoard(
      img: 'assets/images/luffy_vs_kaido.jpg',
      text: "Anime only for you",
      desc: "Check all information about a movie, show or anime before you watch, view users reviews to know more about them",
      button: Color(0xFF4756DF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.top]);
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     systemNavigationBarColor: Colors.transparent,
    //     systemNavigationBarIconBrightness: Brightness.light,
    //   ),
    // );

    final themeData = ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
      )
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
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  _storeOnboardInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        // systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
            child: TextButton(
              onPressed: () {
                _storeOnboardInfo();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => AuthPage()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  currentIndex == 0 || currentIndex == 2 ? kblue.withOpacity(0.8) : kwhite.withOpacity(0.4),
                ),
              ),
              child: Text(
                "Skip",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      body: PageView.builder(
        itemCount: screens.length,
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (_, index) {
          return Stack(
            children: [
              Image.asset(
                screens[index].img,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).padding.top + 20.0),
                      Text(
                        screens[index].text,
                        style: TextStyle(
                          fontSize: 27.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'mulish',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        padding: EdgeInsets.all(10.0),

                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.transparent.withOpacity(0.1),),
                        child: Text(
                          screens[index].desc,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'mulish',
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 10.0,
                            child: ListView.builder(
                              itemCount: screens.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 3.0),
                                        width: currentIndex == index ? 25 : 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: currentIndex == index
                                              ? kindicatorgrey
                                              : kwhite,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ]);
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (index == screens.length - 1) {
                                _storeOnboardInfo();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => AuthPage()),
                                );
                              }
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.bounceIn,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                              decoration: BoxDecoration(
                                color: index % 2 == 0 ? kblue : kwhite,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    index == 2 ? "Done" : "Next",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: index % 2 == 0 ? kwhite : kblue,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Icon(
                                    index == 2 ? Icons.check : Icons.arrow_forward_sharp,
                                    color: index % 2 == 0 ? kwhite : kblue,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 40.0),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


