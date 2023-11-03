import 'package:flashcards/cardsdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardReview extends StatefulWidget {
  const CardReview({super.key});

  @override
  State<CardReview> createState() => _CardReviewState();
}

class _CardReviewState extends State<CardReview> with WidgetsBindingObserver {
  late FoldersData foldersData;

  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    foldersData = Provider.of<FoldersData>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer(
      builder: (context, value, child) => Scaffold(
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
                              color: Colors.deepPurple[200], fontSize: 20)),
                    )
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Container(
                  //current streak
                  //completed cards 12/100
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
                          //Color.fromARGB(255, 100, 109, 227)
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
                        color: !isDarkMode(context)
                            ? const Color.fromARGB(255, 7, 12, 59)
                            : Color.fromARGB(255, 227, 230, 255),
                      )),
                ),
                SizedBox(
                  height: screenHeight * 0.025,
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

                Spacer(),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
