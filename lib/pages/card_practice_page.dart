import 'package:flashcards/folderssdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

class CardPracticePage extends StatefulWidget {
  const CardPracticePage({required this.selectedCardStack, super.key});
  final CardStack selectedCardStack;
  @override
  _CardPracticePageState createState() => _CardPracticePageState();
}

class _CardPracticePageState extends State<CardPracticePage> with WidgetsBindingObserver {
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
          title: Text('Flashcard Practice'),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Container(
            height: screenHeight * 0.85,
            width: screenWidth * 0.95,
            child: AppinioSwiper(
              padding: EdgeInsets.all(0),
              cardsCount: pageCardStack.cards.length,
              cardsBuilder: (BuildContext context, int index) {
                final card = pageCardStack.cards[index];
                if (card is QuizCard) {
                  return Container(
                      margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                      decoration: BoxDecoration(
                          border: Border.all(color: isDarkMode(context) ? Colors.white : Colors.black54, width: 1),
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
                                      color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
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
                                  border: Border(top: BorderSide(color: isDarkMode(context) ? Colors.white : Colors.black54, width: 1)),
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                  color: isDarkMode(context) ? Color.fromARGB(150, 7, 12, 59) : Color.fromARGB(173, 128, 141, 254)),
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
                                                  foldersData.nameQuizAnswer(pageCardStack, "", index, answerIndex);
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
                                            SizedBox(width: screenWidth * 0.02),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.015),
                                      ]),
                                    );
                                  })),
                        )
                      ]));
                } else {
                  return Container();
                }
              },
            ),
          )),
        ),
      ),
    );
  }
}