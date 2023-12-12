import 'package:flashcards/app_data.dart';
import 'package:flashcards/pages/community_search_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// add community_page to open communities
// next task: ability to add tags to commmunity cardStacks

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> with SingleTickerProviderStateMixin {
  String newCommunityName = '';

  late AppData appData;
  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  double defaultValue = 0.0;
  bool optionsOpened = false;
  late AnimationController _slideDownController;
  late Animation<double> _slideDownAnimation;

  void reInitialiseAnimation() {
    _slideDownAnimation = Tween(begin: 0.0, end: defaultValue).animate(CurvedAnimation(parent: _slideDownController, curve: Curves.easeInOut));
  }

  @override
  void initState() {
    _slideDownController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _slideDownAnimation = Tween(begin: 0.0, end: defaultValue).animate(CurvedAnimation(parent: _slideDownController, curve: Curves.easeInOut));
    _slideDownController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appData = Provider.of<AppData>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer(
      builder: (context, value, child) => Scaffold(
          backgroundColor: isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
          appBar: AppBar(
            backgroundColor: isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
            title: Text('Community'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CommunitySearchPage();
                  }));
                },
                icon: Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                width: screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Visibility(
                          visible: optionsOpened,
                          child: Container(height: (screenHeight * 0.12) * 2 + screenHeight * 0.025 * 2),
                        ),
                        Transform.translate(
                          offset: Offset(0, _slideDownAnimation.value),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                            height: screenHeight * 0.12,
                            decoration: BoxDecoration(
                                border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                                color: !isDarkMode(context) ? Color.fromARGB(255, 128, 141, 254) : Color.fromARGB(255, 72, 80, 197),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Row(
                                children: [
                                  SizedBox(width: screenWidth * 0.08),
                                  Expanded(
                                    child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Community Name...',
                                          hintStyle: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            newCommunityName = value;
                                          });
                                        }),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      appData.createCommunity(newCommunityName);
                                    },
                                    icon: Icon(Icons.done,
                                        color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                  ),
                                  SizedBox(width: screenWidth * 0.08),
                                ],
                              )
                            ]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              defaultValue = screenHeight * 0.12 + screenHeight * 0.025;
                            });
                            reInitialiseAnimation();
                            if (!optionsOpened) {
                              _slideDownController.forward();
                              setState(() {
                                optionsOpened = true;
                              });
                            } else {
                              _slideDownController.reverse();
                              setState(() {
                                optionsOpened = false;
                              });
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                            height: screenHeight * 0.12,
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
                                  Text('Create Community',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                  Spacer(),
                                  Icon(Icons.add,
                                      color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                  SizedBox(width: screenWidth * 0.08),
                                ],
                              )
                            ]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.025,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.05),
                      child: Text("My Communities:",
                          style: TextStyle(
                            fontSize: 15.5,
                            color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                          )),
                    ),
                    Container(
                        height: screenHeight * 0.8,
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: appData.localCommunities.length,
                            itemBuilder: (context, index) {
                              return Container(
                                key: Key('$index'),
                                margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                                height: screenHeight * 0.12,
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
                                                color: !isDarkMode(context)
                                                    ? const Color.fromARGB(255, 7, 12, 59)
                                                    : Color.fromARGB(255, 227, 230, 255))),
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
                            }))
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
