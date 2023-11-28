import 'dart:math';
import 'package:flashcards/folderssdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

//
//Next Task: fix the flashing the answers (isAnswered = true) in the card after swipe

class CardPracticePage extends StatefulWidget {
  const CardPracticePage({required this.selectedCardStack, super.key});
  final CardStack selectedCardStack;
  @override
  _CardPracticePageState createState() => _CardPracticePageState();
}

class _CardPracticePageState extends State<CardPracticePage> with WidgetsBindingObserver {
  AppinioSwiperController swiperController = AppinioSwiperController();
  int indexOfCurrentCard = 0;
  late FoldersData foldersData;
  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  List<bool> isAnswered = [];

  @override
  void initState() {
    super.initState();
    isAnswered = List.filled(widget.selectedCardStack.cardsInPractice.length, false);
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
          title: Text('${pageCardStack.name}'),
          backgroundColor: isDarkMode(context) ? Color.fromARGB(255, 3, 5, 27) : Color.fromARGB(255, 227, 230, 255),
        ),
        backgroundColor: isDarkMode(context) ? Color.fromARGB(255, 3, 5, 27) : Color.fromARGB(255, 227, 230, 255),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.05, 0, screenWidth * 0.05, screenHeight * 0.015),
                  height: 15,
                  child: Row(
                    children: [
                      for (int i = indexOfCurrentCard; i < min(pageCardStack.cardsInPractice.length, indexOfCurrentCard + 10); i++)
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.5),
                            decoration: BoxDecoration(
                                color: pageCardStack.cardsInPractice[i].lastPress == 1
                                    ? Colors.red
                                    : pageCardStack.cardsInPractice[i].lastPress == 2
                                        ? Colors.yellow
                                        : pageCardStack.cardsInPractice[i].lastPress == 3
                                            ? Colors.green
                                            : isDarkMode(context)
                                                ? Color.fromARGB(230, 7, 12, 59)
                                                : Color.fromARGB(173, 128, 141, 254),
                                border: Border.all(
                                    color: i == indexOfCurrentCard
                                        ? Color.fromARGB(255, 128, 141, 254)
                                        : isDarkMode(context)
                                            ? Colors.white70
                                            : Colors.black54,
                                    width: i == indexOfCurrentCard ? 3 : 1),
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                    ],
                  )),
              Expanded(
                child: Container(
                  width: screenWidth * 1,
                  child: AppinioSwiper(
                    loop: true,
                    controller: swiperController,
                    backgroundCardsCount: 2,
                    cardsSpacing: 30,
                    padding: EdgeInsets.all(0),
                    cardsCount: pageCardStack.cardsInPractice.length,
                    isDisabled: true,
                    onSwipe: (indexAfterSwipe, direction) {
                      if (indexAfterSwipe > 0 && indexAfterSwipe < pageCardStack.cardsInPractice.length) {
                        setState(() {
                          indexOfCurrentCard = indexAfterSwipe;
                          isAnswered[indexAfterSwipe] = false;
                        });
                        foldersData.moveCard(pageCardStack, indexAfterSwipe - 1);
                      } else if (indexAfterSwipe == 0) {
                        setState(() {
                          indexOfCurrentCard = indexAfterSwipe;
                          isAnswered[indexAfterSwipe] = false;
                        });
                        foldersData.putCardsBack(pageCardStack); //refresh the cards when the count starts over again
                        foldersData.zeroMovedCards(pageCardStack);
                      }
                    },
                    cardsBuilder: (BuildContext context, int index) {
                      final card = pageCardStack.cardsInPractice[index];
                      if (card is QuizCard) {
                        return GestureDetector(
                          onTap: () {
                            print("actual index:${index.toString()}");
                            print("estimated index:${indexOfCurrentCard.toString()}");
                            print("length of the stack:${pageCardStack.cardsInPractice.length}");
                          },
                          child: Container(
                              margin: EdgeInsets.fromLTRB(screenWidth * 0.05, 0, screenWidth * 0.05, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: isDarkMode(context) ? Colors.white70 : Colors.black54, width: 1),
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
                                    Container(
                                      width: screenWidth * 0.65,
                                      child: Text((card as QuizCard).questionText,
                                          maxLines: 3,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                    ),
                                    SizedBox(width: screenWidth * 0.06),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.025,
                                ),
                                Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(top: BorderSide(color: isDarkMode(context) ? Colors.white70 : Colors.black54, width: 1)),
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                          color: isDarkMode(context) ? Color.fromARGB(230, 7, 12, 59) : Color.fromARGB(173, 128, 141, 254)),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: (card as QuizCard).answers.length,
                                          itemBuilder: (context, answerIndex) {
                                            final answerText = (card as QuizCard).answers.keys.elementAt(answerIndex);
                                            bool answerValue = (card as QuizCard).answers.values.elementAt(answerIndex);
                                            return Container(
                                              key: Key('$answerIndex'),
                                              margin: EdgeInsets.fromLTRB(
                                                screenWidth * 0.03,
                                                screenHeight * 0.015,
                                                screenWidth * 0.03,
                                                answerIndex == ((pageCardStack.cardsInPractice[index] as QuizCard).answers.length - 1)
                                                    ? screenHeight * 0.015
                                                    : 0,
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: isAnswered[index]
                                                          ? answerValue
                                                              ? Colors.green
                                                              : Colors.red
                                                          : isDarkMode(context)
                                                              ? Colors.white70
                                                              : Colors.black54,
                                                      width: isAnswered[index] ? 2 : 1),
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
                                                    SizedBox(width: screenWidth * 0.02),
                                                  ],
                                                ),
                                                SizedBox(height: screenHeight * 0.015),
                                              ]),
                                            );
                                          })),
                                )
                              ])),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 15.0),
                child: Container(
                  height: screenHeight * 0.12,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: screenHeight * 0.12,
                          width: screenHeight * 0.05,
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: isDarkMode(context) ? Colors.white70 : Colors.black54, width: 1),
                                  bottom: BorderSide(color: isDarkMode(context) ? Colors.white70 : Colors.black54, width: 1),
                                  right: BorderSide(color: isDarkMode(context) ? Colors.white70 : Colors.black54, width: 1)),
                              color: isDarkMode(context) ? Color.fromARGB(230, 7, 12, 59) : Color.fromARGB(173, 128, 141, 254),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12))),
                          child: Center(
                              child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: isDarkMode(context) ? Colors.white : Colors.black54,
                            size: 20,
                            weight: 0.5,
                          )),
                        ),
                        Spacer(),
                        Visibility(
                            visible: isAnswered[indexOfCurrentCard],
                            child: Row(children: [
                              GestureDetector(
                                onTap: () {
                                  foldersData.badPress(pageCardStack, indexOfCurrentCard);
                                  swiperController.swipeLeft();
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                                  height: screenHeight * 0.12,
                                  width: screenHeight * 0.12,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.red, width: 1.5),
                                      color: Colors.red.withOpacity(0.4),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      )),
                                  child: Center(
                                      child: Icon(
                                    Icons.sentiment_dissatisfied_rounded,
                                    color: Colors.red,
                                    size: 50,
                                  )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  foldersData.okPress(pageCardStack, indexOfCurrentCard);
                                  swiperController.swipeUp();
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                                  height: screenHeight * 0.12,
                                  width: screenHeight * 0.12,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color.fromARGB(255, 211, 195, 49), width: 1.5),
                                      color: Colors.yellow.withOpacity(0.4),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      )),
                                  child: Center(
                                      child: Icon(
                                    Icons.sentiment_neutral_rounded,
                                    color: Colors.yellow,
                                    size: 50,
                                  )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  foldersData.goodPress(pageCardStack, indexOfCurrentCard);
                                  swiperController.swipeRight();
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                                  height: screenHeight * 0.12,
                                  width: screenHeight * 0.12,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.green, width: 1.5),
                                      color: Colors.green.withOpacity(0.4),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      )),
                                  child: Center(
                                      child: Icon(
                                    Icons.sentiment_satisfied_rounded,
                                    color: Colors.green,
                                    size: 50,
                                  )),
                                ),
                              ),
                            ])),
                        Visibility(
                          visible: !isAnswered[indexOfCurrentCard],
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isAnswered[indexOfCurrentCard] = true;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                              height: screenHeight * 0.12,
                              width: screenHeight * 0.12 * 3 + screenWidth * 0.02 * 2,
                              decoration: BoxDecoration(
                                  border: Border.all(color: isDarkMode(context) ? Colors.white70 : Colors.black54, width: 1),
                                  color: !isDarkMode(context) ? Color.fromARGB(255, 128, 141, 254) : Color.fromARGB(255, 72, 80, 197),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  )),
                              child: Center(
                                  child: Text(
                                "Show Answer",
                                style: TextStyle(
                                    color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              )),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: screenHeight * 0.12,
                          width: screenHeight * 0.05,
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: isDarkMode(context) ? Colors.white70 : Colors.black54, width: 1),
                                  bottom: BorderSide(color: isDarkMode(context) ? Colors.white70 : Colors.black54, width: 1),
                                  left: BorderSide(color: isDarkMode(context) ? Colors.white70 : Colors.black54, width: 1)),
                              color: isDarkMode(context) ? Color.fromARGB(230, 7, 12, 59) : Color.fromARGB(173, 128, 141, 254),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))),
                          child: Center(
                              child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: isDarkMode(context) ? Colors.white : Colors.black54,
                            size: 20,
                          )),
                        ),
                      ],
                    )
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
