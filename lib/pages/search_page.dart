import 'package:flashcards/app_data.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

//search results: your universitys communities; global communities
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  late AppData appData;
  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  TextEditingController searchController = TextEditingController();
  Stream<QuerySnapshot<Map<String, dynamic>>>? searchResults;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appData = Provider.of<AppData>(context);
    searchController.addListener(searchCommunities);
    if (appData.myInstitutionId != '') {
      setState(() {
        searchResults = FirebaseFirestore.instance.collection('institutions').doc(appData.myInstitutionId).collection('communities').snapshots();
      });
    } else {
      setState(() {
        searchResults = FirebaseFirestore.instance.collection('institutions').snapshots();
      });
    }
  }

  @override
  void dispose() {
    searchController.removeListener(searchCommunities);
    searchController.dispose();
    super.dispose();
  }

  void searchCommunities() {
    if (appData.myInstitutionId != '') {
      if (searchController.text.isEmpty) {
        setState(() {
          searchResults = FirebaseFirestore.instance.collection('institutions').doc(appData.myInstitutionId).collection('communities').snapshots();
        });
      } else {
        List<String> searchControllerTexts = searchController.text.toLowerCase().split(' ');
        setState(() {
          searchResults = FirebaseFirestore.instance
              .collection('institutions')
              .doc(appData.myInstitutionId)
              .collection('communities')
              .where('searchTags', arrayContainsAny: searchControllerTexts)
              .snapshots();
        });
      }
    } else {
      if (searchController.text.isEmpty) {
        setState(() {
          searchResults = FirebaseFirestore.instance.collection('institutions').snapshots();
        });
      } else {
        List<String> searchControllerTexts = searchController.text.toLowerCase().split(' ');
        setState(() {
          searchResults =
              FirebaseFirestore.instance.collection('institutions').where('searchTags', arrayContainsAny: searchControllerTexts).snapshots();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    appData = Provider.of<AppData>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer(
      builder: (context, value, child) => Scaffold(
          backgroundColor: isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
          appBar: AppBar(
            backgroundColor: isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
            title: Text('Search Communities'),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                width: screenWidth,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    Container(
                      margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                      height: screenHeight * 0.12,
                      decoration: BoxDecoration(
                          border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                          color: !isDarkMode(context) ? Color.fromARGB(255, 128, 141, 254) : Color.fromARGB(177, 72, 80, 197),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Row(
                          children: [
                            SizedBox(width: screenWidth * 0.08),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onChanged: (query) {},
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.search,
                                  color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                            ),
                            SizedBox(width: screenWidth * 0.08),
                          ],
                        )
                      ]),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Container(
                      child: StreamBuilder(
                          stream: searchResults,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  QueryDocumentSnapshot<Map<String, dynamic>> ds = snapshot.data!.docs[index];
                                  return Container(
                                    key: Key(ds.id),
                                    margin: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.025, screenWidth * 0.05, 0),
                                    height: screenHeight * 0.12,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                                        color: !isDarkMode(context) ? Color.fromARGB(255, 128, 141, 254) : Color.fromARGB(255, 72, 80, 197),
                                        borderRadius: BorderRadius.circular(12)),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Row(
                                        children: [
                                          SizedBox(width: screenWidth * 0.08),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Text(ds['name'],
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                      color: !isDarkMode(context)
                                                          ? const Color.fromARGB(255, 7, 12, 59)
                                                          : Color.fromARGB(255, 227, 230, 255))),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.arrow_forward_ios,
                                                color:
                                                    !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                          ),
                                          SizedBox(width: screenWidth * 0.08),
                                        ],
                                      )
                                    ]),
                                  );
                                });
                          }),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
