// Next Important Tasks
// 0. add communities to firestore and download them to the app
// DONE 1. add functions like 'startNamingFolder' and 'finishNamingFolder' and name controller to the Folder and CardStack classes like in FlippyCard
// DONE 2. make page exitable only when the back button is pressed
// 3. work on moving cardsInPractice in buildFoldersAndCardStacksOnLogin()
// 4. Boolean "wasUpdated" (initialised every time as false in the initState()) that is set to true every time a user edits something in the cardStack page; if true -> overwrite the whole cardstack in the database when 'back' button is pressed

//Later Task: moveCards() on page exit
// add moveCardOverTheStack() by adding them to a separate list if their index exceeds the maxIndex (otherwise last card stay last) and them adding them on the loor adfre the putCardsBack()
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// !!! user should choose their university when signing up and then be able to see the communities of their university, when they also create a community, it should be added to the list of communities of their university
class LocalCommunity {
  // int visits; tag; parentUniversity
  String communityId;
  String name;
  List<CardStack> cardstacks;
  LocalCommunity(this.communityId, this.name, this.cardstacks);
}

//Classes for the folders, cardstacks and cards

class Folder {
  String folderId;
  String name;
  List<Folder> subfolders;
  List<CardStack> cardstacks;
  //editing
  bool renamingFolder;
  TextEditingController folderTextController = TextEditingController();
  Folder(
    this.name,
    this.subfolders,
    this.cardstacks,
    this.folderId,
    this.renamingFolder,
  );
  Map<String, dynamic> toMap() {
    return {
      'folderId': folderId,
      'name': name,
    };
  }
}

class CardStack {
  bool isShuffled = false;
  int movedCards = 0;
  Folder parentFolder;
  String cardStackId;
  String name;
  List<SuperCard> cards;
  List<SuperCard> cardsInPractice;
  //editing
  bool renamingCardStack;
  TextEditingController cardStackTextController = TextEditingController();
  CardStack(this.name, this.cardStackId, this.cards, this.cardsInPractice, this.parentFolder, this.renamingCardStack);
  Map<String, dynamic> toMap() {
    return {
      'isShuffled': isShuffled, // take it as a parameter for creating a card stack in FB
      'movedCards': movedCards,
      'cardStackId': cardStackId,
      'name': name,
      'cards': cards.map((card) => card.toMap()).toList(),
      'cardsInPractice': cardsInPractice.map((card) => card.toMap()).toList(),
    };
  }
}

abstract class SuperCard {
  String cardId;
  int goodPresses = 0;
  int okPresses = 0;
  int badPresses = 0;
  int lastPress = 0;
  SuperCard(this.cardId);
  Map<String, dynamic> toMap() {
    return {
      'cardId': cardId,
      'goodPresses': goodPresses,
      'okPresses': okPresses,
      'badPresses': badPresses,
      'lastPress': lastPress,
    };
  }
}

class QuizCard extends SuperCard {
  String questionText;
  Map<String, bool> answers;

  //editing
  bool renamingQuestion;
  TextEditingController questionTextController = TextEditingController();
  QuizCard(this.questionText, this.renamingQuestion, this.answers, super.cardId) {
    questionTextController = TextEditingController(text: questionText);
  }
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'questionText': questionText,
      'answers': answers,
      'cardType': 'QuizCard',
    };
  }

  factory QuizCard.fromMap(Map<String, dynamic> map) {
    QuizCard quizCard = QuizCard(
      map['questionText'],
      false,
      Map<String, bool>.from(map['answers']),
      map['cardId'],
    );
    quizCard.goodPresses = map['goodPresses'];
    quizCard.okPresses = map['okPresses'];
    quizCard.badPresses = map['badPresses'];
    quizCard.lastPress = map['lastPress'];
    return quizCard;
  }
}

class FlippyCard extends SuperCard {
  String frontText;
  String backText;

  //editing
  FlipCardController flipController = FlipCardController();
  bool renamingQuestion;
  bool renamingAnswer;
  TextEditingController frontTextController = TextEditingController();
  TextEditingController backTextController = TextEditingController();
  FlippyCard(this.frontText, this.renamingQuestion, this.backText, this.renamingAnswer, super.cardId) {
    frontTextController = TextEditingController(text: frontText);
    backTextController = TextEditingController(text: backText);
  }
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'frontText': frontText,
      'backText': backText,
      'cardType': 'FlippyCard',
    };
  }

  factory FlippyCard.fromMap(Map<String, dynamic> map) {
    FlippyCard flippyCard = FlippyCard(
      map['frontText'],
      false,
      map['backText'],
      false,
      map['cardId'],
    );
    flippyCard.goodPresses = map['goodPresses'];
    flippyCard.okPresses = map['okPresses'];
    flippyCard.badPresses = map['badPresses'];
    flippyCard.lastPress = map['lastPress'];
    return flippyCard;
  }
}

class AppData extends ChangeNotifier {
// Functions for the folders /////////////////////////////////////////////////////////////////////////////////////////////////

  Folder rootFolders = Folder("Root", [], [], const Uuid().v4(), false);
  String myInstitutionId = '';
  String myInstitutionName = '';
  Map<String, dynamic>? myInstitutionData;
  List<LocalCommunity> localCommunities = [];

  void addFolder(Folder parentFolder) {
    String folderId = Uuid().v4();
    final newFolder = Folder("", [], [], folderId, true);
    parentFolder.subfolders.insert(0, newFolder);
    notifyListeners();
  }

  void startNamingFolder(Folder parentFolder, int indexToRename) {
    parentFolder.subfolders[indexToRename].renamingFolder = true;
    notifyListeners();
  }

  void nameFolder(Folder parentFolder, String newFolderName, int indexToRename) {
    parentFolder.subfolders[indexToRename].name = newFolderName;
    notifyListeners();
  }

  void finishNamingFolder(Folder parentFolder, int indexToRename) {
    parentFolder.subfolders[indexToRename].renamingFolder = false;
    notifyListeners();
  }

  void deleteFolder(Folder parentFolder, int indexToDelete) {
    parentFolder.subfolders.removeAt(indexToDelete);
    notifyListeners();
  }

// Functions for the cardstacks /////////////////////////////////////////////////////////////////////////////////////////////////

  void addCardStack(Folder parentFolder) {
    String newCardStackId = Uuid().v4();
    final newCardStack = CardStack("", newCardStackId, [], [], parentFolder, true);
    parentFolder.cardstacks.insert(0, newCardStack);
    notifyListeners();
  }

  void startNamingCardStack(Folder parentFolder, int indexToRename) {
    parentFolder.cardstacks[indexToRename].renamingCardStack = true;
    notifyListeners();
  }

  void nameCardStack(Folder parentFolder, String newCardStackName, int indexToRename) {
    parentFolder.cardstacks[indexToRename].name = newCardStackName;
    notifyListeners();
  }

  void finishNamingCardStack(Folder parentFolder, int indexToRename) {
    parentFolder.cardstacks[indexToRename].renamingCardStack = false;
    notifyListeners();
  }

  void deleteCardStack(Folder parentFolder, int indexToDelete) {
    parentFolder.cardstacks.removeAt(indexToDelete);
    notifyListeners();
  }

  List<CardStack> recentCardStacks = [];

  void addRecentCardStack(CardStack cardStack) {
    if (recentCardStacks.contains(cardStack)) {
      recentCardStacks.remove(cardStack);
    }
    recentCardStacks.insert(0, cardStack);
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

  void addQuizCard(CardStack parentCardStack) {
    String quizCardId = Uuid().v4();
    final QuizCard newCard = QuizCard("", true, {}, quizCardId);
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

///////////Quiz Questions

  void startNamingQuizQuestion(CardStack parentCardStack, int indexToRename) {
    if (parentCardStack.cards[indexToRename] is QuizCard) {
      (parentCardStack.cards[indexToRename] as QuizCard).renamingQuestion = true;
      notifyListeners();
    }
  }

  void nameQuizQuestion(CardStack parentCardStack, String newQuestion, int indexToRename) {
    if (parentCardStack.cards[indexToRename] is QuizCard) {
      (parentCardStack.cards[indexToRename] as QuizCard).questionText = newQuestion;
      notifyListeners();
    }
  }

  void finishNamingQuizQuestion(CardStack parentCardStack, int indexToRename) {
    if (parentCardStack.cards[indexToRename] is QuizCard) {
      (parentCardStack.cards[indexToRename] as QuizCard).renamingQuestion = false;
      notifyListeners();
    }
  }

///////////Flippy Questions
  void addFlippyCard(CardStack parentCardStack) {
    String flippyCardId = Uuid().v4();
    final FlippyCard newCard = FlippyCard("", true, "", true, flippyCardId);
    parentCardStack.cards.add(newCard);
    parentCardStack.cardsInPractice.add(newCard);
    notifyListeners();
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
  ///////////////////// Quiz Card Answers
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

  //////////////// Flip Card Answers
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

  void flipTheCard(int indexOfFlippyCard, CardStack parentCardStack) {
    FlippyCard _card = (parentCardStack.cardsInPractice[indexOfFlippyCard] as FlippyCard);

    _card.flipController.toggleCard();

    notifyListeners();
  }

// Calendar ////////////////////////////////////////////////////////////////////////////////////////////////////
  Map<String, Color> daysProgress = {};
  double sliderValue = 20.0;
  double completedCards = 0;

  void changeSliderValue(double newValue) {
    sliderValue = newValue;
    notifyListeners();
  }

  void addDaysProgress(DateTime day) {
    DateTime dayAtMidnightUtc = DateTime.utc(day.year, day.month, day.day);
    String formattedDate = dayAtMidnightUtc.toString();
    if (completedCards >= sliderValue) {
      daysProgress[formattedDate] = Colors.green;
      notifyListeners();
    } else {
      daysProgress[formattedDate] = Colors.yellow;
      notifyListeners();
    }
    print(daysProgress.toString());
  }

  void addCompletedCard() {
    completedCards++;
    notifyListeners();
    print(completedCards);
  }

  void resetCompletedCards() {
    completedCards = 0;
    notifyListeners();
  }

// DB connection ////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////// private ////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> addUserInfoToFirestore(User user) {
    String userId = getUserId();
    return FirebaseFirestore.instance.collection('users').doc(userId).set({
      'email': user.email,
    });
  }

  String getUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not signed in');
    }
    return user.uid;
  }

  Future<void> addOrOverwritePrivateFolderInFirestore(Folder folder) {
    String userId = getUserId();
    return FirebaseFirestore.instance.collection('users').doc(userId).collection('folders').doc(folder.folderId).set(folder.toMap());
  }

  Future<void> addOrOverwritePrivateCardStackInFirestore(CardStack cardStack) {
    String userId = getUserId();
    Folder cardStackParentFolder = cardStack.parentFolder;
    if (cardStackParentFolder == rootFolders) {
      return FirebaseFirestore.instance.collection('users').doc(userId).collection('cardStacks').doc(cardStack.cardStackId).set(cardStack.toMap());
    } else {
      // means that the card stack is inside some folder
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folders')
          .doc(cardStackParentFolder.folderId)
          .collection('subCardStacks')
          .doc(cardStack.cardStackId)
          .set(cardStack.toMap());
    }
  }

  Future<void> addOrOverwritePrivateCardsInPracticeInFireStore(CardStack cardStack) {
    String userId = getUserId();
    Folder cardStackParentFolder = cardStack.parentFolder;
    if (cardStackParentFolder == rootFolders) {
      return FirebaseFirestore.instance.collection('users').doc(userId).collection('cardStacks').doc(cardStack.cardStackId).set(cardStack.toMap());
    } else {
      // means that the card stack is inside some folder
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folders')
          .doc(cardStackParentFolder.folderId)
          .collection('subCardStacks')
          .doc(cardStack.cardStackId)
          .set(cardStack.toMap());
    }
  }

  Future<void> overwriteCardsInPracticeInFireStore(CardStack cardStack) {
    String userId = getUserId();
    Folder cardStackParentFolder = cardStack.parentFolder;
    if (cardStackParentFolder == rootFolders) {
      return FirebaseFirestore.instance.collection('users').doc(userId).collection('cardStacks').doc(cardStack.cardStackId).set(cardStack.toMap());
    } else {
      // means that the card stack is inside some folder
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folders')
          .doc(cardStackParentFolder.folderId)
          .collection('subCardStacks')
          .doc(cardStack.cardStackId)
          .update({'cardsInPractice': cardStack.cardsInPractice.map((card) => card.toMap()).toList()});
    }
  }

  Future<void> buildFoldersAndCardStacksOnLogin() async {
    String userId = getUserId();

    QuerySnapshot foldersSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('folders').get();
    //QuerySnapshot contains DocumentSnapshot objects representing the results of a query. The documents can be accessed as an array via the .docs property.
    QuerySnapshot rootCardStacksSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('cardStacks').get();
    //.get(): retrieves all documents within the 'cardstacks' sub-collection.

    for (var folderDoc in foldersSnapshot.docs) {
      var data = folderDoc.data() as Map<String, dynamic>?; //.data() contains all the data of this document snapshot
      if (data != null) {
        Folder generatedFolder = Folder(data['name'], [], [], folderDoc.id, false);

        QuerySnapshot cardStackSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('folders')
            .doc(generatedFolder.folderId)
            .collection('subCardStacks')
            .get();

        List<CardStack> subCardStacks = cardStackSnapshot.docs
            .map((subCardStackDoc) {
              var cardStackData = subCardStackDoc.data() as Map<String, dynamic>?;
              if (cardStackData != null) {
                List<SuperCard> cards = (cardStackData['cards'] as List).map((cardData) {
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
                List<SuperCard> cardsInPractice = (cardStackData['cardsInPractice'] as List).map((cardData) {
                  var cardMap = cardData as Map<String, dynamic>;
                  if (cardMap['cardType'] == 'QuizCard') {
                    return QuizCard.fromMap(cardMap);
                  } else if (cardMap['cardType'] == 'FlippyCard') {
                    return FlippyCard.fromMap(cardMap);
                  } else {
                    throw Exception('Unknown card type');
                  }
                }).toList();

                return CardStack(cardStackData['name'], cardStackData['cardStackId'], cards, cardsInPractice, generatedFolder, false);
              }
            })
            .whereType<CardStack>()
            .toList();

        generatedFolder.cardstacks = subCardStacks;
        rootFolders.subfolders.add(generatedFolder);
      }
    }
    List<CardStack> rootCardStacks = rootCardStacksSnapshot.docs
        .map<CardStack>((cardStackDoc) {
          var data = cardStackDoc.data() as Map<String, dynamic>?;
          if (data != null) {
            List<SuperCard> cards = (data['cards'] as List).map<SuperCard>((cardData) {
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
            List<SuperCard> cardsInPractice = (data['cardsInPractice'] as List).map((cardData) {
              var cardMap = cardData as Map<String, dynamic>;
              if (cardMap['cardType'] == 'QuizCard') {
                return QuizCard.fromMap(cardMap);
              } else if (cardMap['cardType'] == 'FlippyCard') {
                return FlippyCard.fromMap(cardMap);
              } else {
                throw Exception('Unknown card type');
              }
            }).toList();

            CardStack generatedCardStack = CardStack(data['name'], cardStackDoc.id, cards, cardsInPractice, rootFolders, false);
            return generatedCardStack;
          } else {
            throw Exception('Card stack data is null');
          }
        })
        .whereType<CardStack>()
        .toList();

    rootFolders.cardstacks.addAll(rootCardStacks);
    notifyListeners();
  }

/////////////// public ////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> createInstitution(String institutionName, String institutionCountry, String institutionCity) {
    String institutionId = const Uuid().v4();
    List<String> searchSubstrings =
        institutionName.toLowerCase().split(' ').expand((tag) => List<String>.generate(tag.length, (i) => tag.substring(0, i + 1))).toList();
    return FirebaseFirestore.instance.collection('institutions').doc(institutionId).set({
      'name': institutionName,
      'country': institutionCountry,
      'city': institutionCity,
      'users count': 0,
      'count': 0,
      'searchTags': searchSubstrings,
    });
  }

  void addInstitutionToAppData(String institutionId, String institutionName) async {
    myInstitutionId = institutionId;
    myInstitutionName = institutionName;
    myInstitutionData =
        await FirebaseFirestore.instance.collection('institutions').doc(institutionId).get().then((value) => value.data() as Map<String, dynamic>?);
    FirebaseFirestore.instance.collection('institutions').doc(institutionId).update({
      'users count': myInstitutionData!['users count'] + 1,
    });
    notifyListeners();
  }

  Future<void> createCommunity(String communityName, String institutionId) {
    String communityId = const Uuid().v4();
    List<String> searchSubstrings =
        communityName.toLowerCase().split(' ').expand((tag) => List<String>.generate(tag.length, (i) => tag.substring(0, i + 1))).toList();
    FirebaseFirestore.instance.collection('institutions').doc(institutionId).update({
      'count': myInstitutionData!['count'] + 1,
    });
    return FirebaseFirestore.instance.collection('institutions').doc(institutionId).collection('communities').doc(communityId).set({
      'name': communityName,
      'searchTags': searchSubstrings,
      'users count': 0,
      'count': 0,
    });
  }

  void addCommunityToAppData(String communityId, String communityName) async {
    Map<String, dynamic> communityData = await FirebaseFirestore.instance
        .collection('institutions')
        .doc(myInstitutionId)
        .collection('communities')
        .doc(communityId)
        .get()
        .then((value) => value.data() as Map<String, dynamic>);
    FirebaseFirestore.instance.collection('institutions').doc(myInstitutionId).collection('communities').doc(communityId).update({
      'users count': communityData['users count'] + 1,
    });
    LocalCommunity localCommunity = LocalCommunity(communityId, communityName, []); //downloaded CardStacks from the community will be added here
    localCommunities.insert(0, localCommunity);
    notifyListeners();
  }

  Future<void> addCommunityCardStackToFirestore(CardStack cardStack, String communityId) async {
    Map<String, dynamic> communityData = await FirebaseFirestore.instance
        .collection('institutions')
        .doc(myInstitutionId)
        .collection('communities')
        .doc(communityId)
        .get()
        .then((value) => value.data() as Map<String, dynamic>);
    FirebaseFirestore.instance.collection('institutions').doc(myInstitutionId).collection('communities').doc(communityId).update({
      'count': communityData['count'] + 1,
    });
    String cardStackId = const Uuid().v4();
    return FirebaseFirestore.instance
        .collection('institutions')
        .doc(myInstitutionId)
        .collection('communities')
        .doc(communityId)
        .collection('cardstacks')
        .doc(cardStackId)
        .set(cardStack.toMap());
  }
/* 
  Future<void> addCommunityCardStackFromDBToAppData(String cardStackId) async {
    DocumentSnapshot<Map<String, dynamic>> cardStackSnapshot =
        await FirebaseFirestore.instance.collection('communities').doc(cardStackId).collection('sharedCardStacks').doc(cardStackId).get();
    CardStack cardStack = CardStack(cardStackSnapshot['name'], cardStackSnapshot['cardStackId'], [], [], rootFolders);
    cardStackSnapshot['cards'].forEach((card) {
      if (card['cardType'] == 'QuizCard') {
        QuizCard quizCard = QuizCard(card['questionText'], {});
        card['answers'].forEach((key, value) {
          quizCard.answers[key] = value;
        });
        cardStack.cards.add(quizCard);
        cardStack.cardsInPractice.add(quizCard);
      } else if (card['cardType'] == 'FlippyCard') {
        FlippyCard flippyCard = FlippyCard(card['frontText'], card['backText']);
        cardStack.cards.add(flippyCard);
        cardStack.cardsInPractice.add(flippyCard);
      }
    });
    rootFolders.cardstacks.insert(0, cardStack);
    notifyListeners();
  }
  */
}
