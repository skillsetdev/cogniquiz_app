import 'dart:math';

import 'package:flashcards/app_data.dart';
import 'package:flashcards/pages/card_practice_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

// Next Task:  create limit to the amount of cards(limit the add function)

class CardStackPage extends StatefulWidget {
  const CardStackPage({required this.selectedCardStack, super.key});
  final CardStack selectedCardStack;
  @override
  State<CardStackPage> createState() => _CardStackPageState();
}

class _CardStackPageState extends State<CardStackPage> with WidgetsBindingObserver, TickerProviderStateMixin {
  bool editing = false;
  bool reordering = false;
  String newQuestionName = "";
  String newAnswerName = "";
  String checkAnswerName = "o";

  late AppData appData;

  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  bool optionsOpened = false;
  late AnimationController _slideDownController;
  late Animation<double> _slideDownAnimation;
  late Animation<double> _buttonRotationAnimation;
  double defaultValue = 0.0;

  void reInitialiseAnimation() {
    _slideDownAnimation = Tween(begin: 0.0, end: defaultValue).animate(CurvedAnimation(parent: _slideDownController, curve: Curves.easeInOut));
  }

  @override
  void initState() {
    _slideDownController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _buttonRotationAnimation = Tween(begin: 0.0, end: 225 * pi / 180).animate(CurvedAnimation(parent: _slideDownController, curve: Curves.easeInOut));
    _slideDownAnimation = Tween(begin: 0.0, end: defaultValue).animate(CurvedAnimation(parent: _slideDownController, curve: Curves.easeInOut));
    _slideDownController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CardStack pageCardStack = widget.selectedCardStack;
    appData = Provider.of<AppData>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Consumer(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode(context) ? Color.fromARGB(255, 3, 5, 27) : Color.fromARGB(255, 227, 230, 255),
          title: Text(pageCardStack.name),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.file_upload_outlined),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    editing = !editing;
                  });
                },
                child: Text(
                  editing ? "Done" : "Edit",
                  style: TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black),
                ))
          ],
        ),
        backgroundColor: isDarkMode(context) ? Color.fromARGB(255, 3, 5, 27) : Color.fromARGB(255, 227, 230, 255),
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
                    if (pageCardStack.cards.isNotEmpty) {
                      //appData.shuffleCards(pageCardStack); //shuffle cards on the first open
                      appData.putCardsBack(pageCardStack); //put the moved from the end cards back to the beginning
                      appData.zeroMovedCards(pageCardStack); // set moved cards to 0
                      appData.addRecentCardStack(pageCardStack); //add to recent cardstacks
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return CardPracticePage(selectedCardStack: pageCardStack);
                      }));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                    height: screenHeight * 0.12,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: pageCardStack.cards.isNotEmpty
                                ? !isDarkMode(context)
                                    ? const Color.fromARGB(255, 7, 12, 59)
                                    : Colors.white24
                                : Colors.grey,
                            width: 1),
                        color: !isDarkMode(context)
                            ? Color.fromARGB(255, 128, 141, 254)
                            //Color.fromARGB(255, 100, 109, 227)
                            : Color.fromARGB(255, 72, 80, 197),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: screenWidth * 0.08),
                          GestureDetector(
                            child: Text("Practice Cards",
                                style: TextStyle(
                                    color: pageCardStack.cards.isNotEmpty
                                        ? !isDarkMode(context)
                                            ? const Color.fromARGB(255, 7, 12, 59)
                                            : Color.fromARGB(255, 227, 230, 255)
                                        : Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.style_outlined,
                              color: pageCardStack.cards.isNotEmpty
                                  ? !isDarkMode(context)
                                      ? const Color.fromARGB(255, 7, 12, 59)
                                      : Color.fromARGB(255, 227, 230, 255)
                                  : Colors.grey),
                          SizedBox(width: screenWidth * 0.08),
                        ],
                      )
                    ]),
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
                        color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                      )),
                ),
                Container(
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
                              shadowColor: Colors.transparent,
                              child: Container(
                                height: screenHeight * 0.15,
                                child: child,
                              ),
                            );
                          },
                          child: widget, // Pass the widget to the AnimatedBuilder.
                        );
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pageCardStack.cards.length,
                      onReorderStart: (someIndex) {
                        setState(() {
                          reordering = true;
                        });
                      },
                      onReorderEnd: (someIndex) {
                        setState(() {
                          reordering = false;
                        });
                      },
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final cardstack = pageCardStack.cards.removeAt(oldIndex);
                          pageCardStack.cards.insert(newIndex, cardstack);
                        });
                      },
                      itemBuilder: (context, index) {
                        if (reordering) {
                          return Container(
                            key: Key('$index'),
                            margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                            decoration: BoxDecoration(
                                border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                                color: !isDarkMode(context)
                                    ? Color.fromARGB(173, 128, 141, 254)
                                    //Color.fromARGB(255, 100, 109, 227)
                                    : Color.fromARGB(172, 36, 42, 124),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                              SizedBox(
                                height: screenHeight * 0.025,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: screenWidth * 0.04),
                                  Text('${index + 1}.',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                  SizedBox(width: screenWidth * 0.02),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                          (pageCardStack.cards[index] is QuizCard)
                                              ? (pageCardStack.cards[index] as QuizCard).questionText
                                              : (pageCardStack.cards[index] as FlippyCard).frontText,
                                          maxLines: 3,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.06),
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.025,
                              ),
                            ]),
                          );
                        } else if (pageCardStack.cards[index] is QuizCard) {
                          //QuizCard
                          if (editing) {
                            return Container(
                              key: Key('$index'),
                              margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                                  color: !isDarkMode(context)
                                      ? Color.fromARGB(173, 128, 141, 254)
                                      //Color.fromARGB(255, 100, 109, 227)
                                      : Color.fromARGB(172, 36, 42, 124),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: screenWidth * 0.04),
                                    Text('${index + 1}.',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                    SizedBox(width: screenWidth * 0.02),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          appData.nameQuizQuestion(pageCardStack, "", index);
                                        },
                                        child: Text((pageCardStack.cards[index] as QuizCard).questionText,
                                            maxLines: 3,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: !isDarkMode(context)
                                                    ? const Color.fromARGB(255, 7, 12, 59)
                                                    : Color.fromARGB(255, 227, 230, 255))),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.04),
                                    Padding(
                                      padding: EdgeInsets.only(right: screenWidth * 0.02),
                                      child: GestureDetector(
                                          onTap: () {
                                            appData.deleteCard(pageCardStack, index);
                                          },
                                          child: Icon(
                                            Icons.delete_outlined,
                                            size: 30,
                                            color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.symmetric(
                                          horizontal: BorderSide(
                                              color: isDarkMode(context) ? Colors.white24 : Colors.black54,
                                              width: (pageCardStack.cards[index] as QuizCard).answers.isNotEmpty ? 1 : 0.5)),
                                      color: isDarkMode(context) ? Color.fromARGB(150, 7, 12, 59) : Color.fromARGB(173, 128, 141, 254)),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: (pageCardStack.cards[index] as QuizCard).answers.length,
                                      itemBuilder: (context, answerIndex) {
                                        final answerText = (pageCardStack.cards[index] as QuizCard).answers.keys.elementAt(answerIndex);
                                        bool answerValue = (pageCardStack.cards[index] as QuizCard).answers.values.elementAt(answerIndex);
                                        if (answerText.isNotEmpty) {
                                          return Container(
                                            key: Key('$answerIndex'),
                                            margin: EdgeInsets.fromLTRB(
                                              screenWidth * 0.03,
                                              screenHeight * 0.015,
                                              screenWidth * 0.03,
                                              answerIndex == ((pageCardStack.cards[index] as QuizCard).answers.length - 1) ? screenHeight * 0.015 : 0,
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black, width: 1),
                                                color: !isDarkMode(context)
                                                    ? Color.fromARGB(255, 128, 141, 254)
                                                    //Color.fromARGB(255, 100, 109, 227)
                                                    : Color.fromARGB(255, 72, 80, 197),
                                                borderRadius: BorderRadius.circular(12)),
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              SizedBox(height: screenHeight * 0.015),
                                              Row(
                                                children: [
                                                  SizedBox(width: screenWidth * 0.04),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        appData.nameQuizAnswer(pageCardStack, "", index, answerIndex);
                                                      },
                                                      child: Text(answerText,
                                                          maxLines: 3,
                                                          softWrap: true,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              color: !isDarkMode(context)
                                                                  ? const Color.fromARGB(255, 7, 12, 59)
                                                                  : Color.fromARGB(255, 227, 230, 255),
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w600)),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      appData.deleteAnswer(pageCardStack, index, answerIndex);
                                                    },
                                                    icon: Icon(Icons.delete_outlined,
                                                        size: 30,
                                                        color: !isDarkMode(context)
                                                            ? const Color.fromARGB(255, 7, 12, 59)
                                                            : Color.fromARGB(255, 227, 230, 255)),
                                                  ),
                                                  SizedBox(width: screenWidth * 0.02),
                                                ],
                                              ),
                                              SizedBox(height: screenHeight * 0.015),
                                            ]),
                                          );
                                        } else {
                                          return Container(
                                            key: Key('$answerIndex'),
                                            margin: EdgeInsets.fromLTRB(
                                                screenWidth * 0.03,
                                                screenHeight * 0.015,
                                                screenWidth * 0.03,
                                                answerIndex == ((pageCardStack.cards[index] as QuizCard).answers.length - 1)
                                                    ? screenHeight * 0.015
                                                    : 0),
                                            height: screenHeight * 0.12,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: isDarkMode(context) ? Colors.white54 : Colors.black38, width: 2),
                                                color: !isDarkMode(context)
                                                    ? Color.fromARGB(255, 128, 141, 254)
                                                    //Color.fromARGB(255, 100, 109, 227)
                                                    : Color.fromARGB(255, 72, 80, 197),
                                                borderRadius: BorderRadius.circular(12)),
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              Container(
                                                height: screenHeight * 0.1,
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: screenWidth * 0.04),
                                                    Expanded(
                                                        child: TextField(
                                                      minLines: 2,
                                                      maxLines: 2,
                                                      decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.all(10),
                                                        border: OutlineInputBorder(),
                                                        counterStyle: TextStyle(
                                                          fontSize: 0,
                                                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Colors.white24,
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 1,
                                                                color: !isDarkMode(context)
                                                                    ? const Color.fromARGB(255, 7, 12, 59)
                                                                    : Color.fromARGB(255, 227, 230, 255))),
                                                      ),
                                                      onChanged: (value) {
                                                        newAnswerName = value.trim();
                                                      },
                                                    )),
                                                    IconButton(
                                                      onPressed: () {
                                                        if (newAnswerName != checkAnswerName) {
                                                          appData.nameQuizAnswer(pageCardStack, newAnswerName, index, answerIndex);
                                                          setState(() {
                                                            checkAnswerName = newAnswerName;
                                                          });
                                                        }
                                                      },
                                                      icon: Icon(Icons.done,
                                                          color: newAnswerName != checkAnswerName ? Color.fromARGB(255, 4, 228, 86) : Colors.grey),
                                                    ),
                                                    SizedBox(width: screenWidth * 0.02),
                                                  ],
                                                ),
                                              )
                                            ]),
                                          );
                                        }
                                      }),
                                ),
                                Visibility(
                                  visible: true,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                        screenWidth * 0.05,
                                        screenHeight * 0.025,
                                        screenWidth * 0.05,
                                        screenHeight * 0.025,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey, width: 1),
                                          color: !isDarkMode(context)
                                              ? Color.fromARGB(255, 128, 141, 254)
                                              //Color.fromARGB(255, 100, 109, 227)
                                              : Color.fromARGB(255, 72, 80, 197),
                                          borderRadius: BorderRadius.circular(12)),
                                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        SizedBox(height: screenHeight * 0.015),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(width: screenWidth * 0.08),
                                            Text("Add Answer", style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w700)),
                                            Icon(
                                              Icons.add,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: screenWidth * 0.08),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.015),
                                      ]),
                                    ),
                                  ),
                                ),
                              ]),
                            );
                          }
                          if ((pageCardStack.cards[index] as QuizCard).questionText.isNotEmpty) {
                            return Container(
                              key: Key('$index'),
                              margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                                  color: !isDarkMode(context)
                                      ? Color.fromARGB(173, 128, 141, 254)
                                      //Color.fromARGB(255, 100, 109, 227)
                                      : Color.fromARGB(172, 36, 42, 124),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: screenWidth * 0.04),
                                    Text('${index + 1}.',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                    SizedBox(width: screenWidth * 0.02),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          appData.nameQuizQuestion(pageCardStack, "", index);
                                        },
                                        child: Text((pageCardStack.cards[index] as QuizCard).questionText,
                                            maxLines: 3,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: !isDarkMode(context)
                                                    ? const Color.fromARGB(255, 7, 12, 59)
                                                    : Color.fromARGB(255, 227, 230, 255))),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.04),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.symmetric(
                                          horizontal: BorderSide(
                                              color: isDarkMode(context) ? Colors.white24 : Colors.black54,
                                              width: (pageCardStack.cards[index] as QuizCard).answers.isNotEmpty ? 1 : 0.5)),
                                      color: isDarkMode(context) ? Color.fromARGB(150, 7, 12, 59) : Color.fromARGB(173, 128, 141, 254)),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: (pageCardStack.cards[index] as QuizCard).answers.length,
                                      itemBuilder: (context, answerIndex) {
                                        final answerText = (pageCardStack.cards[index] as QuizCard).answers.keys.elementAt(answerIndex);
                                        bool answerValue = (pageCardStack.cards[index] as QuizCard).answers.values.elementAt(answerIndex);
                                        if (answerText.isNotEmpty) {
                                          return Container(
                                            key: Key('$answerIndex'),
                                            margin: EdgeInsets.fromLTRB(
                                              screenWidth * 0.03,
                                              screenHeight * 0.015,
                                              screenWidth * 0.03,
                                              answerIndex == ((pageCardStack.cards[index] as QuizCard).answers.length - 1) ? screenHeight * 0.015 : 0,
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: answerValue ? Colors.green : Colors.red, width: 2),
                                                color: !isDarkMode(context)
                                                    ? Color.fromARGB(255, 128, 141, 254)
                                                    //Color.fromARGB(255, 100, 109, 227)
                                                    : Color.fromARGB(255, 72, 80, 197),
                                                borderRadius: BorderRadius.circular(12)),
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              SizedBox(height: screenHeight * 0.015),
                                              Row(
                                                children: [
                                                  SizedBox(width: screenWidth * 0.04),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        appData.nameQuizAnswer(pageCardStack, "", index, answerIndex);
                                                      },
                                                      child: Text(answerText,
                                                          maxLines: 3,
                                                          softWrap: true,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              color: !isDarkMode(context)
                                                                  ? const Color.fromARGB(255, 7, 12, 59)
                                                                  : Color.fromARGB(255, 227, 230, 255),
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w600)),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      appData.switchAnswer(pageCardStack, index, answerIndex);
                                                    },
                                                    icon: Icon(answerValue ? Icons.check_circle_outline_rounded : Icons.unpublished_outlined,
                                                        size: 30,
                                                        color: !isDarkMode(context)
                                                            ? const Color.fromARGB(255, 7, 12, 59)
                                                            : Color.fromARGB(255, 227, 230, 255)),
                                                  ),
                                                  SizedBox(width: screenWidth * 0.02),
                                                ],
                                              ),
                                              SizedBox(height: screenHeight * 0.015),
                                            ]),
                                          );
                                        } else {
                                          return Container(
                                            key: Key('$answerIndex'),
                                            margin: EdgeInsets.fromLTRB(
                                                screenWidth * 0.03,
                                                screenHeight * 0.015,
                                                screenWidth * 0.03,
                                                answerIndex == ((pageCardStack.cards[index] as QuizCard).answers.length - 1)
                                                    ? screenHeight * 0.015
                                                    : 0),
                                            height: screenHeight * 0.12,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: isDarkMode(context) ? Colors.white54 : Colors.black38, width: 2),
                                                color: !isDarkMode(context)
                                                    ? Color.fromARGB(255, 128, 141, 254)
                                                    //Color.fromARGB(255, 100, 109, 227)
                                                    : Color.fromARGB(255, 72, 80, 197),
                                                borderRadius: BorderRadius.circular(12)),
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              Container(
                                                height: screenHeight * 0.1,
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: screenWidth * 0.04),
                                                    Expanded(
                                                        child: TextField(
                                                      minLines: 2,
                                                      maxLines: 2,
                                                      decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.all(10),
                                                        border: OutlineInputBorder(),
                                                        counterStyle: TextStyle(
                                                          fontSize: 0,
                                                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Colors.white54,
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 1,
                                                                color: !isDarkMode(context)
                                                                    ? const Color.fromARGB(255, 7, 12, 59)
                                                                    : Color.fromARGB(255, 227, 230, 255))),
                                                      ),
                                                      onChanged: (value) {
                                                        newAnswerName = value.trim();
                                                      },
                                                    )),
                                                    IconButton(
                                                      onPressed: () {
                                                        if (newAnswerName != checkAnswerName) {
                                                          appData.nameQuizAnswer(pageCardStack, newAnswerName, index, answerIndex);
                                                          setState(() {
                                                            checkAnswerName = newAnswerName;
                                                          });
                                                        }
                                                      },
                                                      icon: Icon(Icons.done,
                                                          color: newAnswerName != checkAnswerName ? Color.fromARGB(255, 4, 228, 86) : Colors.grey),
                                                    ),
                                                    SizedBox(width: screenWidth * 0.02),
                                                  ],
                                                ),
                                              )
                                            ]),
                                          );
                                        }
                                      }),
                                ),
                                Visibility(
                                  visible: true,
                                  /*(pageCardStack.cards[index]
                                                    as QuizCard)
                                                .answers
                                                .length <
                                            4,*/
                                  child: GestureDetector(
                                    onTap: () {
                                      if ((pageCardStack.cards[index] as QuizCard).answers.length < 6) {
                                        appData.addAnswer(pageCardStack, index);
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                        screenWidth * 0.05,
                                        screenHeight * 0.025,
                                        screenWidth * 0.05,
                                        screenHeight * 0.025,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                                          color: !isDarkMode(context)
                                              ? Color.fromARGB(255, 128, 141, 254)
                                              //Color.fromARGB(255, 100, 109, 227)
                                              : Color.fromARGB(255, 72, 80, 197),
                                          borderRadius: BorderRadius.circular(12)),
                                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        SizedBox(height: screenHeight * 0.015),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(width: screenWidth * 0.08),
                                            Text("Add Answer",
                                                style: TextStyle(
                                                    color: (pageCardStack.cards[index] as QuizCard).answers.length < 6
                                                        ? !isDarkMode(context)
                                                            ? const Color.fromARGB(255, 7, 12, 59)
                                                            : Color.fromARGB(255, 227, 230, 255)
                                                        : Colors.grey,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700)),
                                            Icon(
                                              Icons.add,
                                              color: (pageCardStack.cards[index] as QuizCard).answers.length < 6
                                                  ? !isDarkMode(context)
                                                      ? const Color.fromARGB(255, 7, 12, 59)
                                                      : Color.fromARGB(255, 227, 230, 255)
                                                  : Colors.grey,
                                            ),
                                            SizedBox(width: screenWidth * 0.08),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.015),
                                      ]),
                                    ),
                                  ),
                                ),
                              ]),
                            );
                          } else {
                            return Container(
                              key: Key('$index'),
                              margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                                  color: !isDarkMode(context)
                                      ? Color.fromARGB(173, 128, 141, 254)
                                      //Color.fromARGB(255, 100, 109, 227)
                                      : Color.fromARGB(172, 36, 42, 124),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: screenWidth * 0.04),
                                    Text('${index + 1}.',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                    SizedBox(width: screenWidth * 0.02),
                                    Expanded(
                                        child: TextField(
                                      style: TextStyle(
                                        color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                                      ),
                                      decoration: InputDecoration(
                                        counterStyle: TextStyle(
                                          fontSize: 0,
                                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: !isDarkMode(context)
                                                    ? const Color.fromARGB(255, 7, 12, 59)
                                                    : Color.fromARGB(255, 227, 230, 255))),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          newQuestionName = value.trim();
                                        });
                                      },
                                    )),
                                    SizedBox(
                                      width: screenWidth * 0.05,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        appData.nameQuizQuestion(pageCardStack, newQuestionName, index);
                                      },
                                      icon: Icon(Icons.done,
                                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                    ),
                                    SizedBox(width: screenWidth * 0.08),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                              ]),
                            );
                          }
                        } else if (pageCardStack.cards[index] is FlippyCard) {
                          //FlippyCard
                          if (editing) {
                            return Container(
                              key: Key('$index'),
                              margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                                  color: !isDarkMode(context)
                                      ? Color.fromARGB(173, 128, 141, 254)
                                      //Color.fromARGB(255, 100, 109, 227)
                                      : Color.fromARGB(172, 36, 42, 124),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: screenWidth * 0.04),
                                    Text('${index + 1}.',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                    SizedBox(width: screenWidth * 0.02),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          appData.nameQuizQuestion(pageCardStack, "", index);
                                        },
                                        child: Text((pageCardStack.cards[index] as FlippyCard).frontText,
                                            maxLines: 3,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: !isDarkMode(context)
                                                    ? const Color.fromARGB(255, 7, 12, 59)
                                                    : Color.fromARGB(255, 227, 230, 255))),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.04),
                                    Padding(
                                      padding: EdgeInsets.only(right: screenWidth * 0.02),
                                      child: GestureDetector(
                                          onTap: () {
                                            appData.deleteCard(pageCardStack, index);
                                          },
                                          child: Icon(
                                            Icons.delete_outlined,
                                            size: 30,
                                            color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.symmetric(
                                          horizontal: BorderSide(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 0.5)),
                                      color: isDarkMode(context) ? Color.fromARGB(150, 7, 12, 59) : Color.fromARGB(173, 128, 141, 254)),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: screenWidth * 0.04),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Text((pageCardStack.cards[index] as FlippyCard).backText,
                                            maxLines: 3,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: !isDarkMode(context)
                                                    ? const Color.fromARGB(255, 7, 12, 59)
                                                    : Color.fromARGB(255, 227, 230, 255))),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.04),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                              ]),
                            );
                          }
                          if ((pageCardStack.cards[index] as FlippyCard).renamingQuestion == false) {
                            return Container(
                              key: Key('$index'),
                              margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                                  color: !isDarkMode(context)
                                      ? Color.fromARGB(173, 128, 141, 254)
                                      //Color.fromARGB(255, 100, 109, 227)
                                      : Color.fromARGB(172, 36, 42, 124),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: screenWidth * 0.04),
                                    Text('${index + 1}.',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                    SizedBox(width: screenWidth * 0.02),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          appData.startNamingFlipQuestion(pageCardStack, index);
                                        },
                                        child: Text((pageCardStack.cards[index] as FlippyCard).frontText,
                                            maxLines: 3,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: !isDarkMode(context)
                                                    ? const Color.fromARGB(255, 7, 12, 59)
                                                    : Color.fromARGB(255, 227, 230, 255))),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.04),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.symmetric(
                                          horizontal: BorderSide(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 0.5)),
                                      color: isDarkMode(context) ? Color.fromARGB(150, 7, 12, 59) : Color.fromARGB(173, 128, 141, 254)),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                                Visibility(
                                  visible: !(pageCardStack.cards[index] as FlippyCard).renamingAnswer,
                                  child: Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.04),
                                      Expanded(
                                        child: GestureDetector(
                                            onTap: () {
                                              appData.startNamingFlipAnswer(pageCardStack, index);
                                            },
                                            child: Text((pageCardStack.cards[index] as FlippyCard).backText,
                                                maxLines: 3,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: !isDarkMode(context)
                                                        ? const Color.fromARGB(255, 7, 12, 59)
                                                        : Color.fromARGB(255, 227, 230, 255)))),
                                      ),
                                      SizedBox(width: screenWidth * 0.04),
                                    ],
                                  ),
                                ),
                                Visibility(
                                    visible: (pageCardStack.cards[index] as FlippyCard).renamingAnswer,
                                    child: Row(
                                      children: [
                                        SizedBox(width: screenWidth * 0.04),
                                        Expanded(
                                            child: TextField(
                                          style: TextStyle(
                                            color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Colors.white70,
                                          ),
                                          controller: (pageCardStack.cards[index] as FlippyCard).backTextController,
                                          minLines: 2,
                                          maxLines: 2,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(10),
                                            border: OutlineInputBorder(),
                                            counterStyle: TextStyle(
                                              fontSize: 0,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Colors.white24)),
                                          ),
                                          onChanged: (value) {
                                            appData.nameFlipAnswer(value.trim(), pageCardStack, index);
                                          },
                                        )),
                                        IconButton(
                                          onPressed: () {
                                            appData.finishNamingFlipAnswer(pageCardStack, index);
                                          },
                                          icon: Icon(Icons.done, color: Color.fromARGB(255, 4, 228, 86)),
                                        ),
                                        SizedBox(width: screenWidth * 0.04),
                                      ],
                                    )),
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                              ]),
                            );
                          } else {
                            return Container(
                              key: Key('$index'),
                              margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                                  color: !isDarkMode(context)
                                      ? Color.fromARGB(173, 128, 141, 254)
                                      //Color.fromARGB(255, 100, 109, 227)
                                      : Color.fromARGB(172, 36, 42, 124),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: screenWidth * 0.04),
                                    Text('${index + 1}.',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                    SizedBox(width: screenWidth * 0.02),
                                    Expanded(
                                        child: TextField(
                                      controller: (pageCardStack.cards[index] as FlippyCard).frontTextController,
                                      style: TextStyle(
                                        color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                                      ),
                                      decoration: InputDecoration(
                                        counterStyle: TextStyle(
                                          fontSize: 0,
                                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: !isDarkMode(context)
                                                    ? const Color.fromARGB(255, 7, 12, 59)
                                                    : Color.fromARGB(255, 227, 230, 255))),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          appData.nameFlipQuestion(pageCardStack, value.trim(), index);
                                        });
                                      },
                                    )),
                                    SizedBox(
                                      width: screenWidth * 0.05,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        appData.finishNamingFlipQuestion(pageCardStack, index);
                                      },
                                      icon: Icon(Icons.done, color: Colors.green),
                                    ),
                                    SizedBox(width: screenWidth * 0.08),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                              ]),
                            );
                          }
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Visibility(
                      visible: optionsOpened,
                      child: Container(height: (screenHeight * 0.12) * 3 + screenHeight * 0.025 * 3),
                    ),
                    Transform.translate(
                      offset: Offset(0, _slideDownAnimation.value * 2),
                      child: GestureDetector(
                        onTap: () {
                          if (!editing) {
                            appData.addFlippyCard(pageCardStack);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                          height: screenHeight * 0.12,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: !editing
                                      ? isDarkMode(context)
                                          ? Colors.white24
                                          : Colors.black54
                                      : Colors.grey,
                                  width: 1),
                              color: !isDarkMode(context)
                                  ? Color.fromARGB(255, 128, 141, 254)
                                  //Color.fromARGB(255, 100, 109, 227)
                                  : Color.fromARGB(255, 72, 80, 197),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: screenWidth * 0.08),
                                Text("Add Flip Card",
                                    style: TextStyle(
                                        color: !editing
                                            ? !isDarkMode(context)
                                                ? const Color.fromARGB(255, 7, 12, 59)
                                                : Color.fromARGB(255, 227, 230, 255)
                                            : Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700)),
                                Icon(Icons.flip,
                                    color: !editing
                                        ? !isDarkMode(context)
                                            ? const Color.fromARGB(255, 7, 12, 59)
                                            : Color.fromARGB(255, 227, 230, 255)
                                        : Colors.grey),
                                SizedBox(width: screenWidth * 0.08),
                              ],
                            )
                          ]),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, _slideDownAnimation.value),
                      child: GestureDetector(
                        onTap: () {
                          if (!editing) {
                            appData.addCard(pageCardStack);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                          height: screenHeight * 0.12,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: !editing
                                      ? isDarkMode(context)
                                          ? Colors.white24
                                          : Colors.black54
                                      : Colors.grey,
                                  width: 1),
                              color: !isDarkMode(context)
                                  ? Color.fromARGB(255, 128, 141, 254)
                                  //Color.fromARGB(255, 100, 109, 227)
                                  : Color.fromARGB(255, 72, 80, 197),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: screenWidth * 0.08),
                                Text("Add Quiz Card",
                                    style: TextStyle(
                                        color: !editing
                                            ? !isDarkMode(context)
                                                ? const Color.fromARGB(255, 7, 12, 59)
                                                : Color.fromARGB(255, 227, 230, 255)
                                            : Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700)),
                                Icon(Icons.psychology_alt_outlined,
                                    color: !editing
                                        ? !isDarkMode(context)
                                            ? const Color.fromARGB(255, 7, 12, 59)
                                            : Color.fromARGB(255, 227, 230, 255)
                                        : Colors.grey),
                                SizedBox(width: screenWidth * 0.08),
                              ],
                            )
                          ]),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          defaultValue = screenHeight * 0.12 + screenHeight * 0.025;
                        });
                        reInitialiseAnimation();
                        if (editing) {
                          return;
                        }
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
                            border: Border.all(
                                color: !editing
                                    ? isDarkMode(context)
                                        ? Colors.white24
                                        : Colors.black54
                                    : Colors.grey,
                                width: 1),
                            color: !isDarkMode(context)
                                ? Color.fromARGB(255, 128, 141, 254)
                                //Color.fromARGB(255, 100, 109, 227)
                                : optionsOpened
                                    ? Color.fromARGB(125, 72, 80, 197)
                                    : Color.fromARGB(255, 72, 80, 197),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: screenWidth * 0.08),
                              Text("Add Card",
                                  style: TextStyle(
                                      color: !editing
                                          ? !isDarkMode(context)
                                              ? const Color.fromARGB(255, 7, 12, 59)
                                              : Color.fromARGB(255, 227, 230, 255)
                                          : Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700)),
                              Transform.rotate(
                                angle: _buttonRotationAnimation.value,
                                child: Icon(Icons.add,
                                    color: !editing
                                        ? !isDarkMode(context)
                                            ? const Color.fromARGB(255, 7, 12, 59)
                                            : Color.fromARGB(255, 227, 230, 255)
                                        : Colors.grey),
                              ),
                              SizedBox(width: screenWidth * 0.08),
                            ],
                          )
                        ]),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
