import 'package:flashcards/folderssdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scaled_list/scaled_list.dart';

class CardPracticePage extends StatefulWidget {
  const CardPracticePage({required this.selectedCardStack, super.key});
  final CardStack selectedCardStack;
  @override
  _CardPracticePageState createState() => _CardPracticePageState();
}

class _CardPracticePageState extends State<CardPracticePage>
    with WidgetsBindingObserver {
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
        body: Center(
            child: ScaledList(
                itemBuilder: itemBuilder,
                itemCount: itemCount,
                itemColor: itemColor)),
      ),
    );
  }
}
