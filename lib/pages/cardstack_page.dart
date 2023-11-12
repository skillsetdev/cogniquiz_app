import 'package:flashcards/folderssdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Next Task: create card view with question and answers; ; create an empty card view that will be displayed as soon as previous one was named
class CardStackPage extends StatefulWidget {
  const CardStackPage({required this.selectedCardStack, super.key});
  final CardStack selectedCardStack;
  @override
  State<CardStackPage> createState() => _CardStackPageState();
}

class _CardStackPageState extends State<CardStackPage>
    with WidgetsBindingObserver {
  String newQuestionName = "";
  String newAnswerName = "";

  late FoldersData foldersData;

  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    CardStack pageCardStack = widget.selectedCardStack;
    foldersData = Provider.of<FoldersData>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Consumer(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode(context)
              ? const Color.fromARGB(255, 7, 12, 59)
              : Color.fromARGB(255, 227, 230, 255),
          title: Text(pageCardStack.name),
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
                SizedBox(
                  height: screenHeight * 0.025,
                ),
                GestureDetector(
                  onTap: () {
                    foldersData.addCard(pageCardStack);
                  },
                  child: GestureDetector(
                    onTap: () {
                      foldersData.addCard(pageCardStack);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.05),
                      child: Text("Cards:",
                          style: TextStyle(
                            fontSize: 15.5,
                            color: !isDarkMode(context)
                                ? const Color.fromARGB(255, 7, 12, 59)
                                : Color.fromARGB(255, 227, 230, 255),
                          )),
                    ),
                  ),
                ),
                Container(
                  height: (screenHeight) * pageCardStack.cards.length,
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
                                      Icon(Icons.copy),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          foldersData.nameQuestion(
                                              pageCardStack,
                                              newQuestionName,
                                              index);
                                        },
                                        child: Text(
                                            pageCardStack
                                                .cards[index].questionText,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600)),
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
                      itemCount: pageCardStack.cards.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final cardstack =
                              pageCardStack.cards.removeAt(oldIndex);
                          pageCardStack.cards.insert(newIndex, cardstack);
                        });
                      },
                      itemBuilder: (context, index) {
                        if (pageCardStack
                            .cards[index].questionText.isNotEmpty) {
                          return Container(
                            key: Key('$index'),
                            margin: EdgeInsets.fromLTRB(screenWidth * 0.05,
                                screenHeight * 0.025, screenWidth * 0.05, 0),
                            height: screenHeight * 0.7,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: screenHeight * 0.025,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.08),
                                      Icon(Icons.rectangle_outlined,
                                          color: !isDarkMode(context)
                                              ? const Color.fromARGB(
                                                  255, 7, 12, 59)
                                              : Color.fromARGB(
                                                  255, 227, 230, 255)),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          foldersData.nameQuestion(
                                              pageCardStack, "", index);
                                        },
                                        child: Text(
                                            pageCardStack
                                                .cards[index].questionText,
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
                                        onPressed: () {},
                                        icon: Icon(Icons.arrow_forward_ios,
                                            color: !isDarkMode(context)
                                                ? const Color.fromARGB(
                                                    255, 7, 12, 59)
                                                : Color.fromARGB(
                                                    255, 227, 230, 255)),
                                      ),
                                      SizedBox(width: screenWidth * 0.08),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.025,
                                  ),
                                  Container(
                                    height: (screenHeight * 0.165) *
                                        pageCardStack
                                            .cards[index].answers.length,
                                    child: ListView.builder(
                                        itemCount: pageCardStack
                                            .cards[index].answers.length,
                                        itemBuilder: (context, answerIndex) {
                                          final answerText = pageCardStack
                                              .cards[index].answers.keys
                                              .elementAt(answerIndex);
                                          final answerValue = pageCardStack
                                              .cards[index].answers.values
                                              .elementAt(answerIndex);
                                          if (answerText.isNotEmpty) {
                                            return Container(
                                              key: Key('$answerIndex'),
                                              margin: EdgeInsets.fromLTRB(
                                                  screenWidth * 0.05,
                                                  screenHeight * 0.025,
                                                  screenWidth * 0.05,
                                                  0),
                                              height: screenHeight * 0.14,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: isDarkMode(context)
                                                          ? Colors.white
                                                          : Colors.black54,
                                                      width: 1),
                                                  color: !isDarkMode(context)
                                                      ? Color.fromARGB(
                                                          255, 128, 141, 254)
                                                      //Color.fromARGB(255, 100, 109, 227)
                                                      : Color.fromARGB(
                                                          255, 72, 80, 197),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                            width: screenWidth *
                                                                0.08),
                                                        Spacer(),
                                                        GestureDetector(
                                                          onTap: () {
                                                            foldersData.nameAnswer(
                                                                pageCardStack,
                                                                "",
                                                                index,
                                                                answerIndex);

                                                            // add editAnswerView and "add answer" container which disappears when lenght>=4
                                                          },
                                                          child: Text(answerText,
                                                              style: TextStyle(
                                                                  color: !isDarkMode(
                                                                          context)
                                                                      ? const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          7,
                                                                          12,
                                                                          59)
                                                                      : Color.fromARGB(
                                                                          255,
                                                                          227,
                                                                          230,
                                                                          255),
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                        ),
                                                        Spacer(),
                                                        IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(Icons.edit,
                                                              color: !isDarkMode(
                                                                      context)
                                                                  ? const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      7,
                                                                      12,
                                                                      59)
                                                                  : Color
                                                                      .fromARGB(
                                                                          255,
                                                                          227,
                                                                          230,
                                                                          255)),
                                                        ),
                                                        SizedBox(
                                                            width: screenWidth *
                                                                0.08),
                                                      ],
                                                    )
                                                  ]),
                                            );
                                          } else {
                                            return Container(
                                              key: Key('$answerIndex'),
                                              margin: EdgeInsets.fromLTRB(
                                                  screenWidth * 0.05,
                                                  screenHeight * 0.025,
                                                  screenWidth * 0.05,
                                                  0),
                                              height: screenHeight * 0.14,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: isDarkMode(context)
                                                          ? Colors.white
                                                          : Colors.black54,
                                                      width: 1),
                                                  color: !isDarkMode(context)
                                                      ? Color.fromARGB(
                                                          255, 128, 141, 254)
                                                      //Color.fromARGB(255, 100, 109, 227)
                                                      : Color.fromARGB(
                                                          255, 72, 80, 197),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                            width: screenWidth *
                                                                0.08),
                                                        Spacer(),
                                                        Expanded(
                                                            child: TextField(
                                                          maxLength: 20,
                                                          decoration:
                                                              InputDecoration(
                                                            counterStyle:
                                                                TextStyle(
                                                              fontSize: 0,
                                                              color: !isDarkMode(
                                                                      context)
                                                                  ? const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      7,
                                                                      12,
                                                                      59)
                                                                  : Color
                                                                      .fromARGB(
                                                                          255,
                                                                          227,
                                                                          230,
                                                                          255),
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1,
                                                                    color: !isDarkMode(
                                                                            context)
                                                                        ? const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            7,
                                                                            12,
                                                                            59)
                                                                        : Color.fromARGB(
                                                                            255,
                                                                            227,
                                                                            230,
                                                                            255))),
                                                          ),
                                                          onChanged: (value) {
                                                            newAnswerName =
                                                                value;
                                                          },
                                                        )),
                                                        Spacer(),
                                                        IconButton(
                                                          onPressed: () {
                                                            foldersData.nameAnswer(
                                                                pageCardStack,
                                                                newAnswerName,
                                                                index,
                                                                answerIndex);
                                                          },
                                                          icon: Icon(Icons.edit,
                                                              color: !isDarkMode(
                                                                      context)
                                                                  ? const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      7,
                                                                      12,
                                                                      59)
                                                                  : Color
                                                                      .fromARGB(
                                                                          255,
                                                                          227,
                                                                          230,
                                                                          255)),
                                                        ),
                                                        SizedBox(
                                                            width: screenWidth *
                                                                0.08),
                                                      ],
                                                    )
                                                  ]),
                                            );
                                          }
                                        }),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      foldersData.addAnswer(
                                          pageCardStack, index);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          screenWidth * 0.05,
                                          screenHeight * 0.025,
                                          screenWidth * 0.05,
                                          0),
                                      height: screenHeight * 0.14,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: isDarkMode(context)
                                                  ? Colors.white
                                                  : Colors.black54,
                                              width: 1),
                                          color: !isDarkMode(context)
                                              ? Color.fromARGB(
                                                  255, 128, 141, 254)
                                              //Color.fromARGB(255, 100, 109, 227)
                                              : Color.fromARGB(
                                                  255, 72, 80, 197),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    width: screenWidth * 0.08),
                                                GestureDetector(
                                                  child: Text("Add Answer",
                                                      style: TextStyle(
                                                          color: !isDarkMode(
                                                                  context)
                                                              ? const Color
                                                                  .fromARGB(255,
                                                                  7, 12, 59)
                                                              : Color.fromARGB(
                                                                  255,
                                                                  227,
                                                                  230,
                                                                  255),
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.add,
                                                      color:
                                                          !isDarkMode(context)
                                                              ? const Color
                                                                  .fromARGB(255,
                                                                  7, 12, 59)
                                                              : Color.fromARGB(
                                                                  255,
                                                                  227,
                                                                  230,
                                                                  255)),
                                                ),
                                                SizedBox(
                                                    width: screenWidth * 0.08),
                                              ],
                                            )
                                          ]),
                                    ),
                                  ),
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
                                      Icon(Icons.copy,
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
                                          newQuestionName = value.trim();
                                        },
                                      )),
                                      SizedBox(
                                        width: screenWidth * 0.05,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          foldersData.nameQuestion(
                                              pageCardStack,
                                              newQuestionName,
                                              index);
                                        },
                                        icon: Icon(Icons.done,
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
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  color: Colors.red,
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
