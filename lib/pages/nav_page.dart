import 'dart:ui';

import 'package:flashcards/pages/calendar_page.dart';
import 'package:flashcards/pages/folder_page.dart';
import 'package:flashcards/pages/home_page.dart';
import 'package:flashcards/pages/social_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _pageIndex = 0;
  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  final List<Widget> _pages = [
    const HomePage(),
    const CardReview(),
    const SocialPage(),
    const CalendarPage(),
  ];
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      body: _pages[_pageIndex],
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: !isDarkMode(context) ? Color.fromARGB(100, 7, 12, 59) : Color.fromARGB(100, 227, 230, 255),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: GNav(
                  tabBackgroundGradient: RadialGradient(
                      colors: isDarkMode(context)
                          ? [Color.fromARGB(255, 128, 141, 254), Color.fromARGB(255, 72, 80, 197)]
                          : [Color.fromARGB(255, 161, 166, 241), Color.fromARGB(255, 128, 141, 254)],
                      center: Alignment(-0.5, 0.0)),
                  color: Colors.white,
                  gap: 8,
                  tabBorderRadius: 100,
                  tabBorder: Border.all(color: Colors.white54, width: 1.2),
                  padding: EdgeInsets.all(16),
                  tabMargin: EdgeInsets.only(bottom: 5),
                  curve: Curves.easeOutExpo,
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                      onPressed: () {
                        setState(() {
                          _pageIndex = 0;
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.copy,
                      text: 'Cards',
                      onPressed: () {
                        setState(() {
                          _pageIndex = 1;
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.school_rounded,
                      text: 'Courses',
                      onPressed: () {
                        setState(() {
                          _pageIndex = 2;
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.calendar_month_outlined,
                      text: 'Plans',
                      onPressed: () {
                        setState(() {
                          _pageIndex = 3;
                        });
                      },
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
