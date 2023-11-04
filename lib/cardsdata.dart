import 'package:flutter/material.dart';

class Folder {
  String name;
  List<Folder> subfolders;
  //final List<CardStack> cardstacks;
  Folder(
    this.name,
    this.subfolders,
  );
}

class FoldersData extends ChangeNotifier {
  Folder rootFolders = Folder("Root Folder", []);
  void addFolder(Folder parentFolder) {
    final newFolder = Folder("", []);
    parentFolder.subfolders.insert(0, newFolder);
    notifyListeners();
    rootFolders.subfolders.forEach((subfolder) {
      print(subfolder.name);
    });
  }

  void nameFolder(
      Folder parentFolder, String newFolderName, int indexToRename) {
    parentFolder.subfolders[indexToRename].name = newFolderName;
    notifyListeners();
    rootFolders.subfolders.forEach((subfolder) {
      print(subfolder.name);
    });
  }
}
/*class CardStack {
  final List<Card> cards;
}*/
