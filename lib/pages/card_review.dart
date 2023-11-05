// ignore_for_file: prefer_const_constructors

import 'package:flashcards/cardsdata.dart';
import 'package:flashcards/pages/subfolder_page.dart';
import 'package:flutter/gestures.dart';
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
  late FoldersData foldersData;

  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    foldersData = Provider.of<FoldersData>(context);
    Folder pageFolder = foldersData.rootFolders;
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
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                    color: isDarkMode(context) ? Colors.white : Colors.black54,
                    width: 1)),
            child: Icon(Icons.add,
                color: isDarkMode(context) ? Colors.white : Colors.black54,
                size: 35),
          ),
          switchLabelPosition: true,
          direction: SpeedDialDirection.down,
          activeIcon: Icons.close, //icon when menu is expanded on button
          backgroundColor: !isDarkMode(context)
              ? Color.fromARGB(255, 128, 141, 254)
              //Color.fromARGB(255, 100, 109, 227)
              : Color.fromARGB(255, 72, 80, 197), //background color of button
          foregroundColor: Colors.white, //font color, icon color in button
          activeBackgroundColor:
              Colors.red, //background color when menu is expanded
          activeForegroundColor: Colors.white,
          useRotationAnimation: true,
          visible: true,
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: !isDarkMode(context) ? Colors.black : Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'), // action when menu opens
          onClose: () => print('DIAL CLOSED'), //action when menu closes

          elevation: 8.0, //shadow elevation of button
          shape: CircleBorder(), //shape of button

          children: [
            SpeedDialChild(
              child: Icon(Icons.create_new_folder_outlined),
              backgroundColor: !isDarkMode(context)
                  ? Color.fromARGB(255, 128, 141, 254)
                  : Color.fromARGB(255, 72, 80, 197),
              foregroundColor: Colors.white,
              label: 'Add a Folder',
              labelStyle: TextStyle(fontSize: 18.0),
              labelBackgroundColor: !isDarkMode(context)
                  ? Color.fromARGB(255, 128, 141, 254)
                  : Color.fromARGB(255, 72, 80, 197),
              onTap: () {
                foldersData.addFolder(pageFolder);
              },
              onLongPress: () => print('FIRST CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child: Icon(Icons.copy),
              backgroundColor: !isDarkMode(context)
                  ? Color.fromARGB(255, 128, 141, 254)
                  : Color.fromARGB(255, 72, 80, 197),
              foregroundColor: Colors.white,
              label: 'Add a Card Stack',
              labelStyle: TextStyle(fontSize: 18.0),
              labelBackgroundColor: !isDarkMode(context)
                  ? Color.fromARGB(255, 128, 141, 254)
                  : Color.fromARGB(255, 72, 80, 197),
              onTap: () => print('SECOND CHILD'),
              onLongPress: () => print('SECOND CHILD LONG PRESS'),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        backgroundColor: isDarkMode(context)
            ? const Color.fromARGB(255, 7, 12, 59)
            : Color.fromARGB(255, 227, 230, 255),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            height: screenHeight * 2,
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
                              color: !isDarkMode(context)
                                  ? Color.fromARGB(255, 128, 141, 254)
                                  : Color.fromARGB(255, 72, 80, 197),
                              fontSize: 20)),
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
                      border: Border.all(
                          color: isDarkMode(context)
                              ? Colors.white
                              : Colors.black54,
                          width: 1),
                      color: !isDarkMode(context)
                          ? Color.fromARGB(255, 128, 141, 254)
                          : Color.fromARGB(255, 72, 80, 197),
                      borderRadius: BorderRadius.circular(12)),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Text("Folders:",
                      style: TextStyle(
                        fontSize: 15.5,
                        color: !isDarkMode(context)
                            ? const Color.fromARGB(255, 7, 12, 59)
                            : Color.fromARGB(255, 227, 230, 255),
                      )),
                ),
                /*Container(
                  margin: EdgeInsets.fromLTRB(
                      screenWidth * 0.05, 0, screenWidth * 0.05, 0),
                  height: screenHeight * 0.15,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color:
                              isDarkMode(context) ? Colors.white : Colors.black54,
                          width: 1),
                      color: !isDarkMode(context)
                          ? Color.fromARGB(255, 128, 141, 254)
                          //Color.fromARGB(255, 100, 109, 227)
                          : Color.fromARGB(255, 72, 80, 197),
                      borderRadius: BorderRadius.circular(12)),
                ),*/
                Expanded(
                    child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pageFolder.subfolders.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: screenHeight * 0.025),
                  itemBuilder: (context, index) {
                    if (pageFolder.subfolders[index].name != "") {
                      return LongPressDraggable(
                          data: index,
                          //ignore: sort_child_properties_last
                          child: Container(
                            margin: EdgeInsets.fromLTRB(screenWidth * 0.05,
                                screenHeight * 0.025, screenWidth * 0.05, 0),
                            height: screenHeight * 0.15,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: isDarkMode(context)
                                        ? Colors.white
                                        : Colors.black54,
                                    width: 1),
                                color: !isDarkMode(context)
                                    ? Color.fromARGB(255, 128, 141, 254)
                                    //Color.fromARGB(255, 100, 109, 227)
                                    : Color.fromARGB(255, 72, 80, 197),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.08),
                                      Icon(Icons.folder_outlined),
                                      Spacer(),
                                      GestureDetector(
                                        onLongPress: () {
                                          foldersData.nameFolder(
                                              pageFolder, "", index);
                                        },
                                        child: Text(
                                            pageFolder.subfolders[index].name,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubfolderPage(
                                                          selectedFolder:
                                                              pageFolder
                                                                      .subfolders[
                                                                  index])));
                                        },
                                        icon: Icon(Icons.arrow_forward_ios),
                                      ),
                                      SizedBox(width: screenWidth * 0.08),
                                    ],
                                  )
                                ]),
                          ),
                          feedback: Container(
                            margin: EdgeInsets.fromLTRB(screenWidth * 0.05,
                                screenHeight * 0.025, screenWidth * 0.05, 0),
                            height: screenHeight * 0.15,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: isDarkMode(context)
                                        ? Colors.white
                                        : Colors.black54,
                                    width: 1),
                                color: !isDarkMode(context)
                                    ? Color.fromARGB(255, 128, 141, 254)
                                    //Color.fromARGB(255, 100, 109, 227)
                                    : Color.fromARGB(255, 72, 80, 197),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.08),
                                      Icon(Icons.folder_outlined),
                                      Spacer(),
                                      GestureDetector(
                                        onLongPress: () {
                                          foldersData.nameFolder(
                                              pageFolder, "", index);
                                        },
                                        child: Text(
                                            pageFolder.subfolders[index].name,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubfolderPage(
                                                          selectedFolder:
                                                              pageFolder
                                                                      .subfolders[
                                                                  index])));
                                        },
                                        icon: Icon(Icons.arrow_forward_ios),
                                      ),
                                      SizedBox(width: screenWidth * 0.08),
                                    ],
                                  )
                                ]),
                          ),
                          childWhenDragging: Container(
                            margin: EdgeInsets.fromLTRB(screenWidth * 0.05,
                                screenHeight * 0.025, screenWidth * 0.05, 0),
                            height: screenHeight * 0.15,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: isDarkMode(context)
                                        ? Colors.white
                                        : Colors.black54,
                                    width: 1),
                                color: !isDarkMode(context)
                                    ? Color.fromARGB(255, 128, 141, 254)
                                    //Color.fromARGB(255, 100, 109, 227)
                                    : Color.fromARGB(255, 72, 80, 197),
                                borderRadius: BorderRadius.circular(12)),
                          ));
                    } else {
                      return Container(
                        margin: EdgeInsets.fromLTRB(screenWidth * 0.05,
                            screenHeight * 0.025, screenWidth * 0.05, 0),
                        height: screenHeight * 0.15,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: isDarkMode(context)
                                    ? Colors.white
                                    : Colors.black54,
                                width: 1),
                            color: !isDarkMode(context)
                                ? Color.fromARGB(255, 128, 141, 254)
                                //Color.fromARGB(255, 100, 109, 227)
                                : Color.fromARGB(255, 72, 80, 197),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: screenWidth * 0.08),
                                  Icon(Icons.folder_outlined),
                                  SizedBox(
                                    width: screenWidth * 0.1,
                                  ),
                                  Expanded(child: TextField(
                                    onChanged: (value) {
                                      newFolderName = value;
                                    },
                                  )),
                                  SizedBox(
                                    width: screenWidth * 0.1,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      foldersData.nameFolder(
                                          pageFolder, newFolderName, index);
                                    },
                                    icon: Icon(Icons.done),
                                  ),
                                  SizedBox(width: screenWidth * 0.08),
                                ],
                              )
                            ]),
                      );
                    }
                  },
                )),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
