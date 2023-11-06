import 'package:flutter/material.dart';

class Folder {
  String name;
  List<Folder> subfolders;
  List<CardStack> cardstacks;
  Folder(
    this.name,
    this.subfolders,
    this.cardstacks,
  );
}

class Card {
  String questionText;
  Map<String, bool> answers;
  Card(this.questionText, this.answers);
}

class CardStack {
  String name;
  List<Card> cards;
  CardStack(this.name, this.cards);
}

class FoldersData extends ChangeNotifier {
  Folder rootFolders = Folder("Root", [], []);
  void addFolder(Folder parentFolder) {
    final newFolder = Folder("", [], []);
    parentFolder.subfolders.insert(0, newFolder);
    notifyListeners();
  }

  void nameFolder(
      Folder parentFolder, String newFolderName, int indexToRename) {
    parentFolder.subfolders[indexToRename].name = newFolderName;
    notifyListeners();
  }

  void deleteFolder(Folder parentFolder, int indexToDelete) {
    parentFolder.subfolders.removeAt(indexToDelete);
    notifyListeners();
  }

  void addCardStack(Folder parentFolder) {
    final newCardStack = CardStack("", []);
    parentFolder.cardstacks.insert(0, newCardStack);
    notifyListeners();
  }

  void nameCardStack(
      Folder parentFolder, String newCardStackName, int indexToRename) {
    parentFolder.cardstacks[indexToRename].name = newCardStackName;
    notifyListeners();
  }

  void deleteCardStack(Folder parentFolder, int indexToDelete) {
    parentFolder.cardstacks.removeAt(indexToDelete);
    notifyListeners();
  }

  void addCard(CardStack parentCardStack) {
    final Card newCard = Card("", {"": false});
    parentCardStack.cards.add(newCard);
  }

  void deleteCard(CardStack parentCardStack, int indexToDelete) {
    parentCardStack.cards.removeAt(indexToDelete);
    notifyListeners();
  }

  void nameQuestion(
      CardStack parentCardStack, String newQuestion, int indexToRename) {
    parentCardStack.cards[indexToRename].questionText = newQuestion;
  }

  void addAnswer(CardStack parentCardStack, int indexOfCard) {
    parentCardStack.cards[indexOfCard].answers[""] = false;
  }

  void nameAnswer(CardStack parentCardStack, String newAnswerText,
      int indexOfCard, int indexToRename) {
    String oldKey = parentCardStack.cards[indexOfCard].answers.keys
        .elementAt(indexToRename);

    parentCardStack.cards[indexOfCard].answers
        .remove(oldKey); // Remove old key-value pair
    parentCardStack.cards[indexOfCard].answers[newAnswerText] =
        false; // Add new key-value pair
  }

  void deleteAnswer(
      CardStack parentCardStack, int indexOfCard, int indexToDelete) {
    String oldKey = parentCardStack.cards[indexOfCard].answers.keys
        .elementAt(indexToDelete);

    parentCardStack.cards[indexOfCard].answers
        .remove(oldKey); // Remove old key-value pair
  }
}
