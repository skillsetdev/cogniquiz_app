//Next Task: add moveCardOverTheStack() by adding them to a separate list if their index exceeds the maxIndex and them adding them on the loor adfre the putCardsBack()
//Next Task: add other types of cards
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
  int goodPresses = 0;
  int okPresses = 0;
  int badPresses = 0;
  int lastPress = 0;
}

class QuizCard extends SuperCard {
  String questionText;
  Map<String, bool> answers;
  QuizCard(this.questionText, this.answers);
}

class FlippyCard extends SuperCard {
  bool renamingQuestion = true;
  bool renamingAnswer = true;
  String frontText;
  String backText;
  TextEditingController frontTextController = TextEditingController();
  TextEditingController backTextController = TextEditingController();
  FlippyCard(this.frontText, this.backText) {
    frontTextController = TextEditingController(text: frontText);
    backTextController = TextEditingController(text: backText);
  }
}

class CardStack {
  bool isShuffled = false;
  int movedCards = 0;
  String cardStackId = Uuid().v4();
  String name;
  List<SuperCard> cards;
  List<SuperCard> cardsInPractice;
  CardStack(this.name, this.cards, this.cardsInPractice);
}

class FoldersData extends ChangeNotifier {
// Functions for the folders /////////////////////////////////////////////////////////////////////////////////////////////////

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

// Functions for the cardstacks /////////////////////////////////////////////////////////////////////////////////////////////////

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

  // Functions for the cards /////////////////////////////////////////////////////////////////////////////////////////////////

  void shuffleCards(CardStack parentCardStack) {
    if (!parentCardStack.isShuffled) {
      parentCardStack.cardsInPractice.shuffle();
      parentCardStack.isShuffled = true;
    }

    notifyListeners();
  }

  void addCard(CardStack parentCardStack) {
    final QuizCard newCard = QuizCard("", {});
    parentCardStack.cards.add(newCard);
    parentCardStack.cardsInPractice.add(newCard);
    notifyListeners();
  }

  void addFlippyCard(CardStack parentCardStack) {
    final FlippyCard newCard = FlippyCard("", "");
    parentCardStack.cards.add(newCard);
    parentCardStack.cardsInPractice.add(newCard);
    notifyListeners();
  }

  void deleteCard(CardStack parentCardStack, int indexToDelete) {
    String idToDelete = parentCardStack.cards[indexToDelete].cardId;
    parentCardStack.cards.removeAt(indexToDelete);
    parentCardStack.cardsInPractice.removeWhere((card) => card.cardId == idToDelete);
    notifyListeners();
  }

  void nameQuizQuestion(CardStack parentCardStack, String newQuestion, int indexToRename) {
    if (parentCardStack.cards[indexToRename] is QuizCard) {
      (parentCardStack.cards[indexToRename] as QuizCard).questionText = newQuestion;
      notifyListeners();
    }
  }

  void startNamingFlipQuestion(CardStack parentCardStack, int indexToRename) {
    if (parentCardStack.cards[indexToRename] is FlippyCard) {
      (parentCardStack.cards[indexToRename] as FlippyCard).renamingQuestion = true;
      notifyListeners();
    }
  }

  void nameFlipQuestion(CardStack parentCardStack, String newQuestion, int indexToRename) {
    if (parentCardStack.cards[indexToRename] is FlippyCard) {
      (parentCardStack.cards[indexToRename] as FlippyCard).frontText = newQuestion;
      notifyListeners();
    }
  }

  void finishNamingFlipQuestion(CardStack parentCardStack, int indexToRename) {
    if (parentCardStack.cards[indexToRename] is FlippyCard) {
      (parentCardStack.cards[indexToRename] as FlippyCard).renamingQuestion = false;
      notifyListeners();
    }
  }

// spaced repetition algorithm /////////////////////////////////////////////////////////////////////////////////
  void badPress(CardStack parentCardStack, int indexOfCardInPractice) {
    SuperCard card = parentCardStack.cardsInPractice[indexOfCardInPractice];
    card.badPresses++;
    card.lastPress = 1;
    notifyListeners();
  }

  void okPress(CardStack parentCardStack, int indexOfCardInPractice) {
    SuperCard card = parentCardStack.cardsInPractice[indexOfCardInPractice];
    card.okPresses++;
    card.lastPress = 2;
    notifyListeners();
  }

  void goodPress(CardStack parentCardStack, int indexOfCardInPractice) {
    SuperCard card = parentCardStack.cardsInPractice[indexOfCardInPractice];
    card.goodPresses++;
    card.lastPress = 3;
    notifyListeners();
  }

  //spaced repetition logic ////////////////////////////////////////////////////////////////////////////////////////////////////
  int calculateNewPositionIndex(int currentIndex, SuperCard card, int maxIndex) {
    int newPositionIndex = currentIndex + 3 + 3 * card.goodPresses - card.okPresses - 2 * card.badPresses;
    if (newPositionIndex < currentIndex + 3) {
      newPositionIndex = currentIndex + 3;
    }
    if (newPositionIndex > maxIndex) {
      newPositionIndex = maxIndex;
    }
    return newPositionIndex;
  }

  void moveCard(CardStack parentCardStack, int indexOfCardInPractice) {
    SuperCard card = parentCardStack.cardsInPractice[indexOfCardInPractice]; //assigning the value outside the loop makes it a final

    // Remove the card from its current position first
    parentCardStack.cardsInPractice.removeAt(indexOfCardInPractice);

    // Calculate the new position after the card has been removed
    int newPositionIndex = calculateNewPositionIndex(indexOfCardInPractice, card, parentCardStack.cardsInPractice.length);

    // Insert the card at its new position
    parentCardStack.cardsInPractice.insert(newPositionIndex, card);

    // Get the last card after removing and inserting the other cards
    SuperCard lastCard = parentCardStack.cardsInPractice.last;

    // Remove the last card
    parentCardStack.cardsInPractice.removeLast();

    // Insert the last card at the beginning
    parentCardStack.cardsInPractice.insert(0, lastCard);

    // this function first moves the card, then removes the last one, if the card is the same - the card will be put behind as the last card and then moved on putCardsBack wiht other lastCards, needs to be fixed with moveCardsOverTheStack, which is the next task
    parentCardStack.movedCards++;
    notifyListeners();
  }

  void putCardsBack(CardStack parentCardStack) {
    List<SuperCard> cardsToMove = parentCardStack.cardsInPractice.getRange(0, parentCardStack.movedCards).toList();
    parentCardStack.cardsInPractice.removeRange(0, parentCardStack.movedCards);
    parentCardStack.cardsInPractice.addAll(cardsToMove);
    notifyListeners();
  }

  void zeroMovedCards(CardStack parentCardStack) {
    parentCardStack.movedCards = 0;
    notifyListeners();
  }

  void resetPracticeStack(CardStack parentCardStack) {
    parentCardStack.cardsInPractice.clear();
    parentCardStack.cardsInPractice.addAll(parentCardStack.cards);
    notifyListeners();
  }

// Functions for the answers ////////////////////////////////////////////////////////////////////////////////////////////////////
  // Quiz Card Answers //////////////////////////////////////////////////////////////////////////////////////////////////////
  void addAnswer(CardStack parentCardStack, int indexOfCard) {
    if (parentCardStack.cards[indexOfCard] is QuizCard) {
      (parentCardStack.cards[indexOfCard] as QuizCard).answers.addEntries([
        MapEntry("", false),
      ]);
      notifyListeners();
    }
  }

  void nameQuizAnswer(CardStack parentCardStack, String newAnswerText, int indexOfCard, int indexToRename) {
    String keyToRename = (parentCardStack.cards[indexOfCard] as QuizCard).answers.keys.elementAt(indexToRename);
    bool? valueToCopy = (parentCardStack.cards[indexOfCard] as QuizCard).answers[keyToRename];
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
      //replaces the answers map with the newAnswers map

      notifyListeners();
      /*the whole process is done to avoid the reordering of the key-value pairs
        by deleting and adding a new pair (such process was previously used as a way to "change" the key string)*/
    }
  }

  void switchAnswer(CardStack parentCardStack, int indexOfCard, int indexToSwitch) {
    String keyToSwitchValue = (parentCardStack.cards[indexOfCard] as QuizCard).answers.keys.elementAt(indexToSwitch);
    bool? valueToSwitch = (parentCardStack.cards[indexOfCard] as QuizCard).answers[keyToSwitchValue];
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
      notifyListeners();
    }
  }

  void deleteAnswer(CardStack parentCardStack, int indexOfCard, int indexToDelete) {
    if (parentCardStack.cards[indexOfCard] is QuizCard) {
      String oldKey = (parentCardStack.cards[indexOfCard] as QuizCard).answers.keys.elementAt(indexToDelete);

      (parentCardStack.cards[indexOfCard] as QuizCard).answers.remove(oldKey); // Remove old key-value pair
      notifyListeners();
    }
  }

  // Flip Card Answers //////////////////////////////////////////////////////////////////////////////////////////////////////
  void startNamingFlipAnswer(CardStack parentCardStack, int indexOfCard) {
    if (parentCardStack.cards[indexOfCard] is FlippyCard) {
      (parentCardStack.cards[indexOfCard] as FlippyCard).renamingAnswer = true;
    }
    notifyListeners();
  }

  void nameFlipAnswer(String answerText, CardStack parentCardStack, int indexOfCard) {
    if (parentCardStack.cards[indexOfCard] is FlippyCard) {
      (parentCardStack.cards[indexOfCard] as FlippyCard).backText = answerText;
    }
    notifyListeners();
  }

  void finishNamingFlipAnswer(CardStack parentCardStack, int indexOfCard) {
    if (parentCardStack.cards[indexOfCard] is FlippyCard) {
      (parentCardStack.cards[indexOfCard] as FlippyCard).renamingAnswer = false;
    }
    notifyListeners();
  }
}
