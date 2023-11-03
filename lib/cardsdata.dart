import 'package:flutter/material.dart';

class Folder {
  final String name;
  final List<Folder> subfolders;
  //final List<CardStack> cardstacks;
  Folder(
    this.name,
    this.subfolders,
  );
}

class FoldersData extends ChangeNotifier {
  List<Folder> rootFolders = [];
  void addFolder(Folder parentFolder, String folderName) {
    final newFolder = Folder(folderName, []);
    parentFolder.subfolders.add(newFolder);
    notifyListeners();
  }
}
/*class CardStack {
  final List<Card> cards;
}*/
