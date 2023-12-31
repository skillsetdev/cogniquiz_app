// ignore_for_file: prefer_const_constructors
import 'package:flashcards/app_data.dart';
import 'package:flashcards/pages/cardstack_page.dart';
import 'package:flashcards/pages/subfolder_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CardReview extends StatefulWidget {
  const CardReview({super.key});

  @override
  State<CardReview> createState() => _CardReviewState();
}

class _CardReviewState extends State<CardReview> with WidgetsBindingObserver {
  String newFolderName = "";
  String checkFolderName = "o";
  String newCardStackName = "";
  String checkCardStackName = "o";
  late AppData appData;

  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    appData = Provider.of<AppData>(context);
    Folder pageFolder = appData.rootFolders;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: SpeedDial(
          // ignore: sort_child_properties_last
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100), border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1)),
            child: Icon(Icons.add, color: isDarkMode(context) ? Colors.white : Colors.black54, size: 35),
          ),
          switchLabelPosition: true,
          direction: SpeedDialDirection.down,
          activeIcon: Icons.close,
          backgroundColor: !isDarkMode(context)
              ? Color.fromARGB(255, 128, 141, 254)
              //Color.fromARGB(255, 100, 109, 227)
              : Color.fromARGB(255, 72, 80, 197), //background color of button
          foregroundColor: Colors.white, //font color, icon color in button
          activeBackgroundColor: Colors.red,
          activeForegroundColor: Colors.white,
          useRotationAnimation: true,
          visible: true,
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: !isDarkMode(context) ? Colors.black : Colors.black,
          overlayOpacity: 0.5,
          onOpen: () {},
          onClose: () {},
          elevation: 8.0,
          shape: CircleBorder(), //shape of button

          children: [
            SpeedDialChild(
              child: Icon(Icons.create_new_folder_outlined),
              backgroundColor: !isDarkMode(context) ? Color.fromARGB(255, 128, 141, 254) : Color.fromARGB(255, 72, 80, 197),
              foregroundColor: Colors.white,
              label: 'Add a Folder',
              labelStyle: TextStyle(fontSize: 18.0),
              labelBackgroundColor: !isDarkMode(context) ? Color.fromARGB(255, 128, 141, 254) : Color.fromARGB(255, 72, 80, 197),
              onTap: () {
                appData.addFolder(pageFolder);
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.quiz_outlined),
              backgroundColor: !isDarkMode(context) ? Color.fromARGB(255, 128, 141, 254) : Color.fromARGB(255, 72, 80, 197),
              foregroundColor: Colors.white,
              label: 'Add a Card Stack',
              labelStyle: TextStyle(fontSize: 18.0),
              labelBackgroundColor: !isDarkMode(context) ? Color.fromARGB(255, 128, 141, 254) : Color.fromARGB(255, 72, 80, 197),
              onTap: () {
                appData.addCardStack(pageFolder);
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        backgroundColor: isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text("Edit",
                          style: TextStyle(
                              color: !isDarkMode(context) ? Color.fromARGB(255, 128, 141, 254) : Color.fromARGB(255, 72, 80, 197), fontSize: 20)),
                    )
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  height: screenHeight * 0.2,
                  decoration: BoxDecoration(
                      border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                      color: !isDarkMode(context) ? Color.fromARGB(255, 128, 141, 254) : Color.fromARGB(255, 72, 80, 197),
                      borderRadius: BorderRadius.circular(12)),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Visibility(
                  visible: pageFolder.subfolders.isNotEmpty,
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.05),
                    child: Text("Folders:",
                        style: TextStyle(
                          fontSize: 15.5,
                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                        )),
                  ),
                ),
                Container(
                  height: (screenHeight * 0.145) * pageFolder.subfolders.length,
                  child: Theme(
                    data: ThemeData(
                      canvasColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: ReorderableListView.builder(
                      proxyDecorator: (widget, index, animation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (BuildContext context, Widget? child) {
                            const double elevation = 0.0;
                            return Material(
                              elevation: elevation,
                              shadowColor: Colors.black.withOpacity(0.5),
                              child: child,
                            );
                          },
                          child: Container(
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
                                  Icon(Icons.folder_outlined),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      appData.nameFolder(pageFolder, "", index);
                                    },
                                    child: Text(pageFolder.subfolders[index].name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.arrow_forward_ios),
                                  ),
                                  SizedBox(width: screenWidth * 0.08),
                                ],
                              )
                            ]),
                          ),
                        );
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pageFolder.subfolders.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final folder = pageFolder.subfolders.removeAt(oldIndex);
                          pageFolder.subfolders.insert(newIndex, folder);
                        });
                      },
                      itemBuilder: (context, index) {
                        if (pageFolder.subfolders[index].renamingFolder == false) {
                          return Dismissible(
                            key: Key(appData.rootFolders.subfolders[index].folderId.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              appData.deleteFolder(pageFolder, index);
                            },
                            background: Container(
                              margin: EdgeInsets.fromLTRB(0, screenHeight * 0.025, screenWidth * 0.05, 0),
                              height: screenHeight * 0.12,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Icon(Icons.delete, color: Colors.white),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text('Delete', style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
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
                                    Visibility(
                                      visible: pageFolder.subfolders[index].cardstacks.isNotEmpty,
                                      child: Icon(Icons.folder,
                                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                    ),
                                    Visibility(
                                      visible: pageFolder.subfolders[index].cardstacks.isEmpty,
                                      child: Icon(Icons.folder_outlined,
                                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        appData.startNamingFolder(pageFolder, index);
                                      },
                                      child: Text(pageFolder.subfolders[index].name,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => SubfolderPage(selectedFolder: pageFolder.subfolders[index])));
                                      },
                                      icon: Icon(Icons.arrow_forward_ios,
                                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                    ),
                                    SizedBox(width: screenWidth * 0.08),
                                  ],
                                )
                              ]),
                            ),
                          );
                        } else {
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
                                  Visibility(
                                    visible: pageFolder.subfolders[index].cardstacks.isNotEmpty,
                                    child: Icon(Icons.folder,
                                        color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                  ),
                                  Visibility(
                                    visible: pageFolder.subfolders[index].cardstacks.isEmpty,
                                    child: Icon(Icons.folder_outlined,
                                        color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.0,
                                  ),
                                  Expanded(
                                      child: TextField(
                                    controller: pageFolder.subfolders[index].folderTextController,
                                    maxLength: 20,
                                    decoration: InputDecoration(
                                      counterStyle: TextStyle(
                                        fontSize: 0,
                                        color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color:
                                                  !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        appData.nameFolder(pageFolder, value.trim(), index);
                                      });
                                    },
                                  )),
                                  SizedBox(
                                    width: screenWidth * 0.05,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (pageFolder.subfolders[index].name != "") {
                                        appData.finishNamingFolder(pageFolder, index);
                                      }
                                    },
                                    icon: Icon(Icons.done,
                                        color: pageFolder.subfolders[index].name != "" ? Color.fromARGB(255, 4, 228, 86) : Colors.grey),
                                  ),
                                  SizedBox(width: screenWidth * 0.08),
                                ],
                              )
                            ]),
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
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
                    child: ReorderableListView.builder(
                      proxyDecorator: (widget, index, animation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (BuildContext context, Widget? child) {
                            const double elevation = 0.0;
                            return Material(
                              elevation: elevation,
                              shadowColor: Colors.black.withOpacity(0.5),
                              child: child,
                            );
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
                                  Icon(Icons.quiz_outlined),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      appData.nameCardStack(pageFolder, newCardStackName, index);
                                    },
                                    child: Text(pageFolder.cardstacks[index].name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.arrow_forward_ios),
                                  ),
                                  SizedBox(width: screenWidth * 0.08),
                                ],
                              )
                            ]),
                          ),
                        );
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pageFolder.cardstacks.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final cardstack = pageFolder.cardstacks.removeAt(oldIndex);
                          pageFolder.cardstacks.insert(newIndex, cardstack);
                        });
                      },
                      itemBuilder: (context, index) {
                        if (pageFolder.cardstacks[index].renamingCardStack == false) {
                          return Dismissible(
                            key: Key(appData.rootFolders.cardstacks[index].cardStackId.toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              appData.deleteCardStack(pageFolder, index);
                            },
                            background: Container(
                              margin: EdgeInsets.fromLTRB(0, screenHeight * 0.025, screenWidth * 0.05, 0),
                              height: screenHeight * 0.12,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Icon(Icons.delete, color: Colors.white),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text('Delete', style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                            child: Container(
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
                                      onTap: () {
                                        appData.startNamingCardStack(pageFolder, index);
                                      },
                                      child: Text(pageFolder.cardstacks[index].name,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => CardStackPage(
                                                      selectedCardStack: pageFolder.cardstacks[index],
                                                    )));
                                      },
                                      icon: Icon(Icons.arrow_forward_ios,
                                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                    ),
                                    SizedBox(width: screenWidth * 0.08),
                                  ],
                                )
                              ]),
                            ),
                          );
                        } else {
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
                                  SizedBox(
                                    width: screenWidth * 0.05,
                                  ),
                                  Expanded(
                                      child: TextField(
                                    controller: pageFolder.cardstacks[index].cardStackTextController,
                                    maxLength: 20,
                                    decoration: InputDecoration(
                                      counterStyle: TextStyle(
                                        fontSize: 0,
                                        color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color:
                                                  !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        appData.nameCardStack(pageFolder, value.trim(), index);
                                      });
                                    },
                                  )),
                                  SizedBox(
                                    width: screenWidth * 0.05,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (pageFolder.cardstacks[index].name != "") {
                                        appData.finishNamingCardStack(pageFolder, index);
                                      }
                                    },
                                    icon: Icon(Icons.done,
                                        color: pageFolder.cardstacks[index].name != "" ? Color.fromARGB(255, 4, 228, 86) : Colors.grey),
                                  ),
                                  SizedBox(width: screenWidth * 0.08),
                                ],
                              )
                            ]),
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                Visibility(
                  visible: appData.downloadsFolder.cardstacks.isNotEmpty,
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.05),
                    child: Text("Downloads:",
                        style: TextStyle(
                          fontSize: 15.5,
                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                        )),
                  ),
                ),
                Container(
                  height: (screenHeight * 0.145) * appData.downloadsFolder.cardstacks.length,
                  child: Theme(
                    data: ThemeData(
                      canvasColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: ReorderableListView.builder(
                      proxyDecorator: (widget, index, animation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: (BuildContext context, Widget? child) {
                            const double elevation = 0.0;
                            return Material(
                              elevation: elevation,
                              shadowColor: Colors.black.withOpacity(0.5),
                              child: child,
                            );
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
                                  Icon(Icons.quiz_outlined),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(appData.downloadsFolder.cardstacks[index].name,
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.arrow_forward_ios),
                                  ),
                                  SizedBox(width: screenWidth * 0.08),
                                ],
                              )
                            ]),
                          ),
                        );
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: appData.downloadsFolder.cardstacks.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final cardstack = appData.downloadsFolder.cardstacks.removeAt(oldIndex);
                          appData.downloadsFolder.cardstacks.insert(newIndex, cardstack);
                        });
                      },
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(appData.downloadsFolder.cardstacks[index].cardStackId.toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            appData.deleteCardStack(appData.downloadsFolder, index);
                          },
                          background: Container(
                            margin: EdgeInsets.fromLTRB(0, screenHeight * 0.025, screenWidth * 0.05, 0),
                            height: screenHeight * 0.12,
                            decoration: BoxDecoration(
                                color: Colors.red, borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12))),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Icon(Icons.delete, color: Colors.white),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text('Delete', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          child: Container(
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
                                    child: Text(appData.downloadsFolder.cardstacks[index].name,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CardStackPage(
                                                    selectedCardStack: appData.downloadsFolder.cardstacks[index],
                                                  )));
                                    },
                                    icon: Icon(Icons.arrow_forward_ios,
                                        color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                  ),
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
