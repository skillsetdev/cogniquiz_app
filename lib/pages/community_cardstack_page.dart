import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards/app_data.dart';
import 'package:flashcards/pages/card_practice_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class CommunityCardStackPage extends StatefulWidget {
  const CommunityCardStackPage({required this.communityId, required this.communityCardStackId, super.key});
  final String communityId;
  final String communityCardStackId;
  @override
  State<CommunityCardStackPage> createState() => _CommunityCardStackPageState();
}

class _CommunityCardStackPageState extends State<CommunityCardStackPage> with WidgetsBindingObserver, TickerProviderStateMixin {
  bool reordering = false;
  String newAnswerName = "";
  String checkAnswerName = "o";
  CardStack pageCardStack = CardStack("error", "error", [], [], Folder('error', [], [], '', false), false);
  late AppData appData;

  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    appData = Provider.of<AppData>(context);
    String communityId = widget.communityId;
    String csId = widget.communityCardStackId;
    Map<String, dynamic>? querySnapshot = await FirebaseFirestore.instance
        .collection('institutions')
        .doc(appData.myInstitutionId)
        .collection('communities')
        .doc(communityId)
        .collection('cardstacks')
        .doc(csId)
        .get()
        .then((value) => value.data() as Map<String, dynamic>?);
    CardStack getPageCardStack() {
      if (querySnapshot != null) {
        List<SuperCard> cards = (querySnapshot['cards'] as List).map((cardData) {
          var cardMap = cardData as Map<String, dynamic>;
          // Determine the type of the card and instantiate the specific class
          if (cardMap['cardType'] == 'QuizCard') {
            return QuizCard.fromMap(cardMap);
          } else if (cardMap['cardType'] == 'FlippyCard') {
            return FlippyCard.fromMap(cardMap);
          } else {
            throw Exception('Unknown card type');
          }
        }).toList();
        List<SuperCard> cardsInPractice = (querySnapshot['cardsInPractice'] as List).map((cardData) {
          var cardMap = cardData as Map<String, dynamic>;
          if (cardMap['cardType'] == 'QuizCard') {
            return QuizCard.fromMap(cardMap);
          } else if (cardMap['cardType'] == 'FlippyCard') {
            return FlippyCard.fromMap(cardMap);
          } else {
            throw Exception('Unknown card type');
          }
        }).toList();
        return CardStack(querySnapshot['name'], querySnapshot['cardStackId'], cards, cardsInPractice, appData.rootFolders, false);
      }
      return CardStack("error", "error", [], [], appData.rootFolders, false);
    }

    setState(() {
      pageCardStack = getPageCardStack();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      onPopInvoked: (bool didPop) {},
      child: Consumer(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: isDarkMode(context) ? Color.fromARGB(255, 3, 5, 27) : Color.fromARGB(255, 227, 230, 255),
            title: Text(pageCardStack.name),
            actions: [],
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
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: pageCardStack.cards.length,
                        itemBuilder: (context, index) {
                          if (pageCardStack.cards[index] is QuizCard) {
                            //QuizCard
                            return Container(
                              key: Key('$index'),
                              margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                                  color: !isDarkMode(context) ? Color.fromARGB(173, 128, 141, 254) : Color.fromARGB(172, 36, 42, 124),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                                Visibility(
                                  visible: (pageCardStack.cards[index] as QuizCard).renamingQuestion,
                                  child: Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.04),
                                      Text('${index + 1}.',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                      SizedBox(width: screenWidth * 0.02),
                                      Expanded(
                                          child: TextField(
                                        controller: (pageCardStack.cards[index] as QuizCard).questionTextController,
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
                                            appData.nameQuizQuestion(pageCardStack, value.trim(), index);
                                          });
                                        },
                                      )),
                                      SizedBox(
                                        width: screenWidth * 0.05,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if ((pageCardStack.cards[index] as QuizCard).questionText != "") {
                                            appData.finishNamingQuizQuestion(pageCardStack, index);
                                          }
                                        },
                                        icon: Icon(Icons.done,
                                            color: (pageCardStack.cards[index] as QuizCard).questionText != "" ? Colors.green : Colors.grey),
                                      ),
                                      SizedBox(width: screenWidth * 0.08),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: !(pageCardStack.cards[index] as QuizCard).renamingQuestion,
                                  child: Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.04),
                                      Text('${index + 1}.',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                      SizedBox(width: screenWidth * 0.02),
                                      Expanded(
                                        child: Text((pageCardStack.cards[index] as QuizCard).questionText,
                                            maxLines: 5,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: !isDarkMode(context)
                                                    ? const Color.fromARGB(255, 7, 12, 59)
                                                    : Color.fromARGB(255, 227, 230, 255))),
                                      ),
                                      SizedBox(width: screenWidth * 0.04),
                                    ],
                                  ),
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
                                                          maxLines: 5,
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
                          } else if (pageCardStack.cards[index] is FlippyCard) {
                            //FlippyCard

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
                                Visibility(
                                  visible: (pageCardStack.cards[index] as FlippyCard).renamingQuestion,
                                  child: Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.04),
                                      Text('${index + 1}.',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
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
                                          if ((pageCardStack.cards[index] as FlippyCard).frontText != "") {
                                            appData.finishNamingFlipQuestion(pageCardStack, index);
                                          }
                                        },
                                        icon: Icon(Icons.done,
                                            color: (pageCardStack.cards[index] as FlippyCard).frontText != "" ? Colors.green : Colors.grey),
                                      ),
                                      SizedBox(width: screenWidth * 0.08),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: !(pageCardStack.cards[index] as FlippyCard).renamingQuestion,
                                  child: Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.04),
                                      Text('${index + 1}.',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                      SizedBox(width: screenWidth * 0.02),
                                      Expanded(
                                        child: Text((pageCardStack.cards[index] as FlippyCard).frontText,
                                            maxLines: 5,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: !isDarkMode(context)
                                                    ? const Color.fromARGB(255, 7, 12, 59)
                                                    : Color.fromARGB(255, 227, 230, 255))),
                                      ),
                                      SizedBox(width: screenWidth * 0.04),
                                    ],
                                  ),
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
                                        child: Text((pageCardStack.cards[index] as FlippyCard).backText,
                                            maxLines: 5,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: !isDarkMode(context)
                                                    ? const Color.fromARGB(255, 7, 12, 59)
                                                    : Color.fromARGB(255, 227, 230, 255))),
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
                                            if ((pageCardStack.cards[index] as FlippyCard).backText != "") {
                                              appData.finishNamingFlipAnswer(pageCardStack, index);
                                            }
                                          },
                                          icon: Icon(Icons.done,
                                              color: (pageCardStack.cards[index] as FlippyCard).backText != ""
                                                  ? Color.fromARGB(255, 4, 228, 86)
                                                  : Colors.grey),
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
                            return Container();
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
