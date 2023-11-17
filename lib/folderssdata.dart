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

abstract class SuperCard {}

class QuizCard extends SuperCard {
  String questionText;
  Map<String, bool> answers;
  QuizCard(this.questionText, this.answers);
}

class CardStack {
  String name;
  List<SuperCard> cards;
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
    final QuizCard newCard = QuizCard("", {});
    parentCardStack.cards.add(newCard);
    notifyListeners();
  }

  void deleteCard(CardStack parentCardStack, int indexToDelete) {
    parentCardStack.cards.removeAt(indexToDelete);
    notifyListeners();
  }

  void nameQuizQuestion(
      CardStack parentCardStack, String newQuestion, int indexToRename) {
    if (parentCardStack.cards[indexToRename] is QuizCard) {
      (parentCardStack.cards[indexToRename] as QuizCard).questionText =
          newQuestion;
      notifyListeners();
    }
  }

  void addAnswer(CardStack parentCardStack, int indexOfCard) {
    if (parentCardStack.cards[indexOfCard] is QuizCard) {
      (parentCardStack.cards[indexOfCard] as QuizCard).answers.addEntries([
        MapEntry("", false),
      ]);
      notifyListeners();
    }
  }

  void nameQuizAnswer(CardStack parentCardStack, String newAnswerText,
      int indexOfCard, int indexToRename) {
    if (parentCardStack.cards[indexOfCard] is QuizCard) {
      String keyToRename = (parentCardStack.cards[indexOfCard] as QuizCard)
          .answers
          .keys
          .elementAt(indexToRename);
      bool? valueToCopy =
          (parentCardStack.cards[indexOfCard] as QuizCard).answers[keyToRename];

      Map<String, bool> newAnswers = {};
      (parentCardStack.cards[indexOfCard] as QuizCard)
          .answers
          .forEach((key, value) {
        if (key == keyToRename) {
          newAnswers[newAnswerText] = valueToCopy ?? false;
        } else {
          newAnswers[key] = value;
        }
/*for each key-value pair in the 'answers' map creates an aquivalent key-value pair in the newAnswers map, 
except for the key-value pair that is being renamed, key of which is replaced with a new key(so the new name)*/
      });

      (parentCardStack.cards[indexOfCard] as QuizCard).answers = newAnswers;
      //replaces the answers map with the newAnswers map

      notifyListeners();
/*the whole process is done to avoid the reordering of the key-value pairs
by deleting and adding a new pair (such process was previously used as a way to "change" the key string)*/
    }
  }

  void switchAnswer(
      CardStack parentCardStack, int indexOfCard, int indexToSwitch) {
    if (parentCardStack.cards[indexOfCard] is QuizCard) {
      String keyToSwitchValue = (parentCardStack.cards[indexOfCard] as QuizCard)
          .answers
          .keys
          .elementAt(indexToSwitch);
      bool? valueToSwitch = (parentCardStack.cards[indexOfCard] as QuizCard)
          .answers[keyToSwitchValue];

/* "valueToSwitch = !valueToSwitch" wasn't working because 
In Dart, when you get a value from a map, you're getting a copy of that value, 
not a reference to the value in the map. So that code was only changing the copy.
*/

      Map<String, bool> newAnswers = {};

      (parentCardStack.cards[indexOfCard] as QuizCard)
          .answers
          .forEach((key, value) {
        if (key == keyToSwitchValue) {
          newAnswers[key] = !(valueToSwitch ?? false);
        } else {
          newAnswers[key] = value;
        }
      });
// this new code, however, creates a new map
      (parentCardStack.cards[indexOfCard] as QuizCard).answers = newAnswers;
      notifyListeners();
    }
  }

  void deleteAnswer(
      CardStack parentCardStack, int indexOfCard, int indexToDelete) {
    if (parentCardStack.cards[indexOfCard] is QuizCard) {
      String oldKey = (parentCardStack.cards[indexOfCard] as QuizCard)
          .answers
          .keys
          .elementAt(indexToDelete);

      (parentCardStack.cards[indexOfCard] as QuizCard)
          .answers
          .remove(oldKey); // Remove old key-value pair
      notifyListeners();
    }
  }
}
