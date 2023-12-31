import 'package:flashcards/app_data.dart';
import 'package:flashcards/pages/community_page.dart';
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
  String newCommunityOrInstitutionName = ''; // reset it after...

  late AppData appData;
  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  double defaultValue = 0.0;
  bool optionsOpened = false;
  late AnimationController _slideDownController;
  late Animation<double> _slideDownAnimation;
  bool wasInitialised = false;

  void reInitialiseAnimation() {
    _slideDownAnimation = Tween(begin: 0.0, end: defaultValue).animate(CurvedAnimation(parent: _slideDownController, curve: Curves.easeInOut));
  }

  @override
  void initState() {
    _slideDownController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _slideDownAnimation = Tween(begin: 0.0, end: defaultValue).animate(CurvedAnimation(parent: _slideDownController, curve: Curves.easeInOut));
    _slideDownController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  TextEditingController searchController = TextEditingController();
  Stream<QuerySnapshot<Map<String, dynamic>>>? searchResults;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!wasInitialised) {
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
      setState(() {
        wasInitialised = true;
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
                              onPressed: () {
                                FocusScopeNode currentFocus = FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
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
                                  return GestureDetector(
                                    onTap: () {
                                      if (appData.myInstitutionId != '') {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityPage(selectedCommunityData: ds)));
                                      }
                                    },
                                    child: Container(
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
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(ds['name'],
                                                      softWrap: true,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w600,
                                                          color: !isDarkMode(context)
                                                              ? const Color.fromARGB(255, 7, 12, 59)
                                                              : Color.fromARGB(255, 227, 230, 255))),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.person_rounded,
                                                        size: 20,
                                                      ),
                                                      Text(
                                                        ": ${ds['users count']}   ",
                                                        style: TextStyle(fontSize: 15),
                                                      ),
                                                      Visibility(
                                                        visible: appData.myInstitutionId == '',
                                                        child: Icon(
                                                          Icons.diversity_3_rounded,
                                                          size: 20,
                                                        ),
                                                      ),
                                                      Visibility(
                                                          visible: appData.myInstitutionId != '',
                                                          child: Icon(
                                                            Icons.style_outlined,
                                                            size: 20,
                                                          )),
                                                      Text(
                                                        ": ${ds['count']}",
                                                        style: TextStyle(fontSize: 15),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                if (appData.myInstitutionId == '') {
                                                  appData.addInstitutionToAppData(ds.id, ds['name']);
                                                  setState(() {
                                                    wasInitialised = false;
                                                  });
                                                } else {
                                                  if (appData.localCommunities.any((community) => community.communityId == ds.id)) {
                                                    return;
                                                  }
                                                  appData.addCommunityToAppData(ds.id, ds['name']);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: appData.localCommunities.any((community) => community.communityId == ds.id) ? 0 : 2,
                                                backgroundColor: appData.localCommunities.any((community) => community.communityId == ds.id)
                                                    ? !isDarkMode(context)
                                                        ? Color.fromARGB(255, 227, 230, 255)
                                                        : const Color.fromARGB(255, 7, 12, 59)
                                                    : !isDarkMode(context)
                                                        ? const Color.fromARGB(255, 7, 12, 59)
                                                        : Color.fromARGB(255, 227, 230, 255),
                                                foregroundColor: appData.localCommunities.any((community) => community.communityId == ds.id)
                                                    ? !isDarkMode(context)
                                                        ? const Color.fromARGB(255, 7, 12, 59)
                                                        : Color.fromARGB(255, 227, 230, 255)
                                                    : !isDarkMode(context)
                                                        ? Color.fromARGB(255, 227, 230, 255)
                                                        : const Color.fromARGB(255, 7, 12, 59),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12.0),
                                                ),
                                              ),
                                              child: Text(
                                                appData.localCommunities.any((community) => community.communityId == ds.id)
                                                    ? 'Joined'
                                                    : 'Join', // The any method checks if at least one element of the list satisfies the provided condition.
                                              ),
                                            ),
                                            SizedBox(width: screenWidth * 0.05),
                                          ],
                                        )
                                      ]),
                                    ),
                                  );
                                });
                          }),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Stack(
                      children: [
                        Visibility(
                          visible: optionsOpened,
                          child: Container(height: (screenHeight * 0.12) * 2 + screenHeight * 0.025 * 2),
                        ),
                        Transform.translate(
                          offset: Offset(0, _slideDownAnimation.value),
                          child: Container(
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
                                    child: TextField(
                                        decoration: InputDecoration(
                                          hintText: appData.myInstitutionId == '' ? 'University or School Name...' : 'Community Name...',
                                          hintStyle: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            newCommunityOrInstitutionName = value;
                                          });
                                        }),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      appData.myInstitutionId == ''
                                          ? appData.createInstitution(newCommunityOrInstitutionName, '', '')
                                          : appData.createCommunity(newCommunityOrInstitutionName, appData.myInstitutionId);
                                    },
                                    icon: Icon(Icons.done,
                                        color: newCommunityOrInstitutionName == ''
                                            ? !isDarkMode(context)
                                                ? const Color.fromARGB(255, 7, 12, 59)
                                                : Color.fromARGB(255, 227, 230, 255)
                                            : Colors.green),
                                  ),
                                  SizedBox(width: screenWidth * 0.08),
                                ],
                              )
                            ]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              defaultValue = screenHeight * 0.12 + screenHeight * 0.025;
                            });
                            reInitialiseAnimation();
                            if (!optionsOpened) {
                              _slideDownController.forward();
                              setState(() {
                                optionsOpened = true;
                              });
                            } else {
                              _slideDownController.reverse();
                              setState(() {
                                optionsOpened = false;
                              });
                            }
                          },
                          child: Container(
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
                                  Spacer(),
                                  Text(appData.myInstitutionId == '' ? 'Create Your Institution Page' : 'Create Community',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255))),
                                  Spacer(),
                                  Icon(Icons.add,
                                      color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255)),
                                  SizedBox(width: screenWidth * 0.08),
                                ],
                              )
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
