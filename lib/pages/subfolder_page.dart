import 'package:flashcards/folderssdata.dart';
import 'package:flashcards/pages/cardstack_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class SubfolderPage extends StatefulWidget {
  const SubfolderPage({required this.selectedFolder, super.key});
  final Folder selectedFolder;
  @override
  State<SubfolderPage> createState() => _SubfolderPageState();
}

class _SubfolderPageState extends State<SubfolderPage>
    with WidgetsBindingObserver {
  String newCardStackName = "";
  String newFolderName = "";
  late FoldersData foldersData;

  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    foldersData = Provider.of<FoldersData>(context);
    Folder pageFolder = widget.selectedFolder;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode(context)
              ? const Color.fromARGB(255, 7, 12, 59)
              : Color.fromARGB(255, 227, 230, 255),
          title: Text(pageFolder.name),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
            )
          ],
        ),
        floatingActionButton: SpeedDial(
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
          switchLabelPosition: false,
          direction: SpeedDialDirection.up,
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
              child: Icon(Icons.quiz_outlined),
              backgroundColor: !isDarkMode(context)
                  ? Color.fromARGB(255, 128, 141, 254)
                  : Color.fromARGB(255, 72, 80, 197),
              foregroundColor: Colors.white,
              label: 'Add a Card Stack',
              labelStyle: TextStyle(fontSize: 18.0),
              labelBackgroundColor: !isDarkMode(context)
                  ? Color.fromARGB(255, 128, 141, 254)
                  : Color.fromARGB(255, 72, 80, 197),
              onTap: () => foldersData.addCardStack(pageFolder),
              onLongPress: () => print('SECOND CHILD LONG PRESS'),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        backgroundColor: isDarkMode(context)
            ? const Color.fromARGB(255, 7, 12, 59)
            : Color.fromARGB(255, 227, 230, 255),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
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

                Theme(
                  data: ThemeData(
                    canvasColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Container(
                    height:
                        (screenHeight * 0.175) * pageFolder.subfolders.length,
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
                        );
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pageFolder.subfolders.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final folder =
                              pageFolder.subfolders.removeAt(oldIndex);
                          pageFolder.subfolders.insert(newIndex, folder);
                        });
                      },
                      itemBuilder: (context, index) {
                        if (!pageFolder.subfolders[index].name.isEmpty) {
                          return Container(
                            key: Key('$index'),
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
                                      Icon(Icons.folder_outlined,
                                          color: !isDarkMode(context)
                                              ? const Color.fromARGB(
                                                  255, 7, 12, 59)
                                              : Color.fromARGB(
                                                  255, 227, 230, 255)),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          foldersData.nameFolder(
                                              pageFolder, "", index);
                                        },
                                        child: Text(
                                            pageFolder.subfolders[index].name,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: !isDarkMode(context)
                                                    ? const Color.fromARGB(
                                                        255, 7, 12, 59)
                                                    : Color.fromARGB(
                                                        255, 227, 230, 255))),
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
                                        icon: Icon(Icons.arrow_forward_ios,
                                            color: !isDarkMode(context)
                                                ? const Color.fromARGB(
                                                    255, 7, 12, 59)
                                                : Color.fromARGB(
                                                    255, 227, 230, 255)),
                                      ),
                                      SizedBox(width: screenWidth * 0.08),
                                    ],
                                  )
                                ]),
                          );
                        } else {
                          return Container(
                            key: Key('$index'),
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
                                      Icon(Icons.folder_outlined,
                                          color: !isDarkMode(context)
                                              ? const Color.fromARGB(
                                                  255, 7, 12, 59)
                                              : Color.fromARGB(
                                                  255, 227, 230, 255)),
                                      SizedBox(
                                        width: screenWidth * 0.05,
                                      ),
                                      Expanded(
                                          child: TextField(
                                        maxLength: 20,
                                        decoration: InputDecoration(
                                          counterStyle: TextStyle(
                                            fontSize: 0,
                                            color: !isDarkMode(context)
                                                ? const Color.fromARGB(
                                                    255, 7, 12, 59)
                                                : Color.fromARGB(
                                                    255, 227, 230, 255),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: !isDarkMode(context)
                                                      ? const Color.fromARGB(
                                                          255, 7, 12, 59)
                                                      : Color.fromARGB(
                                                          255, 227, 230, 255))),
                                        ),
                                        onChanged: (value) {
                                          newFolderName = value;
                                        },
                                      )),
                                      SizedBox(
                                        width: screenWidth * 0.05,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          foldersData.nameFolder(
                                              pageFolder, newFolderName, index);
                                        },
                                        icon: Icon(Icons.done,
                                            color: Color.fromARGB(
                                                255, 4, 228, 86)),
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
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Text("Cards:",
                      style: TextStyle(
                        fontSize: 15.5,
                        color: !isDarkMode(context)
                            ? const Color.fromARGB(255, 7, 12, 59)
                            : Color.fromARGB(255, 227, 230, 255),
                      )),
                ),
                Container(
                  height: (screenHeight * 0.175) * pageFolder.cardstacks.length,
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
                                      Icon(Icons.quiz_outlined),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          foldersData.nameCardStack(pageFolder,
                                              newCardStackName, index);
                                        },
                                        child: Text(
                                            pageFolder.cardstacks[index].name,
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
                        );
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pageFolder.cardstacks.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final cardstack =
                              pageFolder.cardstacks.removeAt(oldIndex);
                          pageFolder.cardstacks.insert(newIndex, cardstack);
                        });
                      },
                      itemBuilder: (context, index) {
                        if (!pageFolder.cardstacks[index].name.isEmpty) {
                          return Container(
                            key: Key('$index'),
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
                                      Icon(Icons.quiz_outlined,
                                          color: !isDarkMode(context)
                                              ? const Color.fromARGB(
                                                  255, 7, 12, 59)
                                              : Color.fromARGB(
                                                  255, 227, 230, 255)),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          foldersData.nameCardStack(
                                              pageFolder, "", index);
                                        },
                                        child: Text(
                                            pageFolder.cardstacks[index].name,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: !isDarkMode(context)
                                                    ? const Color.fromARGB(
                                                        255, 7, 12, 59)
                                                    : Color.fromARGB(
                                                        255, 227, 230, 255))),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CardStackPage(
                                                          selectedCardStack:
                                                              pageFolder
                                                                      .cardstacks[
                                                                  index])));
                                        },
                                        icon: Icon(Icons.arrow_forward_ios,
                                            color: !isDarkMode(context)
                                                ? const Color.fromARGB(
                                                    255, 7, 12, 59)
                                                : Color.fromARGB(
                                                    255, 227, 230, 255)),
                                      ),
                                      SizedBox(width: screenWidth * 0.08),
                                    ],
                                  )
                                ]),
                          );
                        } else {
                          return Container(
                            key: Key('$index'),
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
                                      Icon(Icons.quiz_outlined,
                                          color: !isDarkMode(context)
                                              ? const Color.fromARGB(
                                                  255, 7, 12, 59)
                                              : Color.fromARGB(
                                                  255, 227, 230, 255)),
                                      SizedBox(
                                        width: screenWidth * 0.05,
                                      ),
                                      Expanded(
                                          child: TextField(
                                        maxLength: 20,
                                        decoration: InputDecoration(
                                          counterStyle: TextStyle(
                                            fontSize: 0,
                                            color: !isDarkMode(context)
                                                ? const Color.fromARGB(
                                                    255, 7, 12, 59)
                                                : Color.fromARGB(
                                                    255, 227, 230, 255),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: !isDarkMode(context)
                                                      ? const Color.fromARGB(
                                                          255, 7, 12, 59)
                                                      : Color.fromARGB(
                                                          255, 227, 230, 255))),
                                        ),
                                        onChanged: (value) {
                                          newCardStackName = value.trim();
                                        },
                                      )),
                                      SizedBox(
                                        width: screenWidth * 0.05,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          foldersData.nameCardStack(pageFolder,
                                              newCardStackName, index);
                                        },
                                        icon: Icon(Icons.done,
                                            color: Color.fromARGB(
                                                255, 4, 228, 86)),
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
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
