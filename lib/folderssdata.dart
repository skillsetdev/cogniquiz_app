import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

//Classes for the folders, cardstacks and cards

class Folder {
  String folderId = Uuid().v4();
  String name;
  List<Folder> subfolders;
  List<CardStack> cardstacks;
  Folder(
    this.name,
    this.subfolders,
    this.cardstacks,
  );
}

abstract class SuperCard {
  String cardId = Uuid().v4();
}

class QuizCard extends SuperCard {
  String questionText;
  Map<String, bool> answers;
  QuizCard(this.questionText, this.answers);
}

class CardStack {
  String cardStackId = Uuid().v4();
  String name;
  List<SuperCard> cards;
  List<SuperCard> cardsInPractice;
  CardStack(this.name, this.cards, this.cardsInPractice);
}

class FoldersData extends ChangeNotifier {
// Functions for the folders

  Folder rootFolders = Folder("Root", [], []);

  void addFolder(Folder parentFolder) {
    final newFolder = Folder("", [], []);
    parentFolder.subfolders.insert(0, newFolder);
    notifyListeners();
  }

  void nameFolder(Folder parentFolder, String newFolderName, int indexToRename) {
    parentFolder.subfolders[indexToRename].name = newFolderName;
    notifyListeners();
  }

  void deleteFolder(Folder parentFolder, int indexToDelete) {
    parentFolder.subfolders.removeAt(indexToDelete);
    notifyListeners();
  }

// Functions for the cardstacks

  void addCardStack(Folder parentFolder) {
    final newCardStack = CardStack("", [], []);
    parentFolder.cardstacks.insert(0, newCardStack);
    notifyListeners();
  }

  void nameCardStack(Folder parentFolder, String newCardStackName, int indexToRename) {
    parentFolder.cardstacks[indexToRename].name = newCardStackName;
    notifyListeners();
  }

  void deleteCardStack(Folder parentFolder, int indexToDelete) {
    parentFolder.cardstacks.removeAt(indexToDelete);
    notifyListeners();
  }

  // Functions for the cards

  void shuffleCards(CardStack parentCardStack) {
    parentCardStack.cardsInPractice.shuffle();
    notifyListeners();
  }

  void addCard(CardStack parentCardStack) {
    final QuizCard newCard = QuizCard("", {});
    parentCardStack.cards.add(newCard);
    parentCardStack.cardsInPractice.add(newCard);
    notifyListeners();
  }

  void deleteCard(CardStack parentCardStack, int indexToDelete) {
    // String idToDelete = parentCardStack.cards[indexToDelete].cardId;
    parentCardStack.cards.removeAt(indexToDelete);
    // parentCardStack.cardsInPractice.removeWhere((card) => card.cardId == idToDelete);
    notifyListeners();
  }

  void nameQuizQuestion(CardStack parentCardStack, String newQuestion, int indexToRename) {
    String idToRename = parentCardStack.cards[indexToRename].cardId;
    if (parentCardStack.cards[indexToRename] is QuizCard) {
      (parentCardStack.cards[indexToRename] as QuizCard).questionText = newQuestion;
      (parentCardStack.cardsInPractice.firstWhere((card) => card.cardId == idToRename) as QuizCard).questionText = newQuestion;
      notifyListeners();
    }
  }

/*  void resetPracticeStack(CardStack initialCardStack, CardStack cardStackToUpdate) {
    cardStackToUpdate.cards.clear();
    cardStackToUpdate.cards.addAll(initialCardStack.cards);
    notifyListeners();
  }*/

// Functions for the answers

  void addAnswer(CardStack parentCardStack, int indexOfCard) {
    if (parentCardStack.cards[indexOfCard] is QuizCard) {
      // String idOfCard = parentCardStack.cards[indexOfCard].cardId;
      (parentCardStack.cards[indexOfCard] as QuizCard).answers.addEntries([
        MapEntry("", false),
      ]);
      // (parentCardStack.cardsInPractice.firstWhere((card) => card.cardId == idOfCard) as QuizCard).answers.addEntries([   MapEntry("", false),  ]);
      notifyListeners();
    }
  }

  void nameQuizAnswer(CardStack parentCardStack, String newAnswerText, int indexOfCard, int indexToRename) {
    String keyToRename = (parentCardStack.cards[indexOfCard] as QuizCard).answers.keys.elementAt(indexToRename);
    bool? valueToCopy = (parentCardStack.cards[indexOfCard] as QuizCard).answers[keyToRename];
    // String idOfCard = parentCardStack.cards[indexOfCard].cardId;
    if (parentCardStack.cards[indexOfCard] is QuizCard) {
      Map<String, bool> newAnswers = {};
      (parentCardStack.cards[indexOfCard] as QuizCard).answers.forEach((key, value) {
        if (key == keyToRename) {
          newAnswers[newAnswerText] = valueToCopy ?? false;
        } else {
          newAnswers[key] = value;
        }
/*for each key-value pair in the 'answers' map creates an aquivalent key-value pair in the newAnswers map, 
except for the key-value pair that is being renamed, key of which is replaced with a new key(so the new name)*/
      });
      (parentCardStack.cards[indexOfCard] as QuizCard).answers = newAnswers;
      // (parentCardStack.cardsInPractice.firstWhere((card) => card.cardId == idOfCard) as QuizCard).answers = newAnswers;
      //replaces the answers map with the newAnswers map

      notifyListeners();
/*the whole process is done to avoid the reordering of the key-value pairs
by deleting and adding a new pair (such process was previously used as a way to "change" the key string)*/
    }
  }

  void switchAnswer(CardStack parentCardStack, int indexOfCard, int indexToSwitch) {
    String keyToSwitchValue = (parentCardStack.cards[indexOfCard] as QuizCard).answers.keys.elementAt(indexToSwitch);
    bool? valueToSwitch = (parentCardStack.cards[indexOfCard] as QuizCard).answers[keyToSwitchValue];
    //  String idOfCard = parentCardStack.cards[indexOfCard].cardId;
    if (parentCardStack.cards[indexOfCard] is QuizCard) {
/* "valueToSwitch = !valueToSwitch" wasn't working because 
In Dart, when you get a value from a map, you're getting a copy of that value, 
not a reference to the value in the map. So that code was only changing the copy.
*/

      Map<String, bool> newAnswers = {};

      (parentCardStack.cards[indexOfCard] as QuizCard).answers.forEach((key, value) {
        if (key == keyToSwitchValue) {
          newAnswers[key] = !(valueToSwitch ?? false);
        } else {
          newAnswers[key] = value;
        }
      });
// this new code, however, creates a new map
      (parentCardStack.cards[indexOfCard] as QuizCard).answers = newAnswers;
      //  (parentCardStack.cardsInPractice.firstWhere((card) => card.cardId == idOfCard) as QuizCard).answers = newAnswers;
      notifyListeners();
    }
  }

  void deleteAnswer(CardStack parentCardStack, int indexOfCard, int indexToDelete) {
    String idOfCard = parentCardStack.cards[indexOfCard].cardId;
    if (parentCardStack.cards[indexOfCard] is QuizCard) {
      String oldKey = (parentCardStack.cards[indexOfCard] as QuizCard).answers.keys.elementAt(indexToDelete);

      (parentCardStack.cards[indexOfCard] as QuizCard).answers.remove(oldKey); // Remove old key-value pair
      (parentCardStack.cardsInPractice.firstWhere((card) => card.cardId == idOfCard) as QuizCard).answers.remove(oldKey);
      notifyListeners();
    }
  }
}
