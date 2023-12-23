import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards/app_data.dart';
import 'package:flashcards/pages/cardstack_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppData appData;

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    appData = Provider.of<AppData>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          height: screenHeight * 2,
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Container(
                //current streak
                //completed cards 12/100
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                height: screenHeight * 0.2,
                decoration: BoxDecoration(
                    border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                    color: !isDarkMode(context)
                        ? Color.fromARGB(255, 128, 141, 254)
                        //Color.fromARGB(255, 100, 109, 227)
                        : Color.fromARGB(255, 72, 80, 197),
                    borderRadius: BorderRadius.circular(12)),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.05),
                child: Text("Communities:",
                    style: TextStyle(
                      fontSize: 15.5,
                      color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                    )),
              ),
              SizedBox(
                height: screenHeight * 0.025,
              ),
              Container(
                  height: screenHeight * 0.2,
                  width: screenWidth,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: appData.localCommunities.length,
                      itemBuilder: (context, index) {
                        return Container(
                          key: Key('$index'),
                          margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                          height: screenHeight * 0.12,
                          width: screenWidth * 0.8,
                          decoration: BoxDecoration(
                              border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                              color: !isDarkMode(context) ? Color.fromARGB(255, 128, 141, 254) : Color.fromARGB(255, 72, 80, 197),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Row(
                              children: [
                                SizedBox(width: screenWidth * 0.08),
                                Icon(Icons.folder_outlined,
                                    color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(appData.localCommunities[index].name,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.arrow_forward_ios,
                                      color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                ),
                                SizedBox(width: screenWidth * 0.08),
                              ],
                            )
                          ]),
                        );
                      })),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.05),
                child: Text("Recents:",
                    style: TextStyle(
                      fontSize: 15.5,
                      color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                    )),
              ),
              SizedBox(
                height: screenHeight * 0.025,
              ),
              Container(
                height: (screenHeight * 0.145) * min(appData.recentCardStacks.length, 5),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: min(appData.recentCardStacks.length, 5),
                  itemBuilder: (context, index) {
                    return Container(
                      key: Key('$index'),
                      margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                      height: screenHeight * 0.12,
                      decoration: BoxDecoration(
                          border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                          color: !isDarkMode(context)
                              ? Color.fromARGB(255, 128, 141, 254)
                              //Color.fromARGB(255, 100, 109, 227)
                              : Color.fromARGB(255, 72, 80, 197),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Row(
                          children: [
                            SizedBox(width: screenWidth * 0.08),
                            Icon(Icons.quiz_outlined,
                                color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                            Spacer(),
                            GestureDetector(
                              onTap: () {},
                              child: Text(appData.recentCardStacks[index].name,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => CardStackPage(selectedCardStack: appData.recentCardStacks[index])));
                              },
                              icon: Icon(Icons.arrow_forward_ios,
                                  color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                            ),
                            SizedBox(width: screenWidth * 0.08),
                          ],
                        )
                      ]),
                    );
                  },
                ),
              ),
              Spacer(),
              TextButton(onPressed: signOut, child: Text('Log Out'))
            ],
          ),
        )),
      ),
    );
  }
}
