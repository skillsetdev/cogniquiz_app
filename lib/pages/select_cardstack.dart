// ignore_for_file: prefer_const_constructors
import 'package:flashcards/app_data.dart';
import 'package:flashcards/pages/cardstack_page.dart';
import 'package:flashcards/pages/subfolder_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SelectCardStack extends StatefulWidget {
  const SelectCardStack({required this.communityId, super.key});
  final String communityId;

  @override
  State<SelectCardStack> createState() => _SelectCardStackState();
}

class _SelectCardStackState extends State<SelectCardStack> with WidgetsBindingObserver {
  String newFolderName = "";
  String checkFolderName = "o";
  String newCardStackName = "";
  String checkCardStackName = "o";
  List<CardStack> allCardStacksList = [];
  late AppData appData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appData = Provider.of<AppData>(context);
    setState(() {
      allCardStacksList = allCardStacks();
    });
  }

  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  List<CardStack> allCardStacks() {
    List<CardStack> _generatedList = [];
    _generatedList.insertAll(0, appData.rootFolders.cardstacks);
    for (var folder in appData.rootFolders.subfolders) {
      _generatedList.insertAll(0, folder.cardstacks);
    }
    return _generatedList;
  }

  @override
  Widget build(BuildContext context) {
    Folder pageFolder = appData.rootFolders;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
        ),
        backgroundColor: isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Visibility(
                  visible: pageFolder.cardstacks.isNotEmpty,
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.05),
                    child: Text("Card Stacks:",
                        style: TextStyle(
                          fontSize: 15.5,
                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                        )),
                  ),
                ),
                Container(
                  height: (screenHeight * 0.145) * pageFolder.cardstacks.length,
                  child: Theme(
                    data: ThemeData(
                      canvasColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: allCardStacksList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            appData.addCommunityCardStackToFirestore(allCardStacksList[index], widget.communityId);
                          },
                          child: Container(
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
                                  Icon(Icons.quiz_outlined,
                                      color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                  Spacer(),
                                  Text(allCardStacksList[index].name,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                  SizedBox(width: screenWidth * 0.08),
                                ],
                              )
                            ]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
