import 'dart:math';

import 'package:flashcards/app_data.dart';
import 'package:flashcards/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// add community_page to open communities
// next task: ability to add tags to commmunity cardStacks

class CommunityPage extends StatefulWidget {
  const CommunityPage({required this.selectedCommunityData, super.key});
  final QueryDocumentSnapshot<Map<String, dynamic>> selectedCommunityData;
  @override
  State<CommunityPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<CommunityPage> with SingleTickerProviderStateMixin {
  String newCommunityName = '';

  late AppData appData;
  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? communityCardStacksSnapshot;
  double defaultValue = 0.0;
  bool optionsOpened = false;
  late AnimationController _slideDownController;
  late Animation<double> _slideDownAnimation;

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

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    appData = Provider.of<AppData>(context);
    if (appData.myInstitutionId != '') {
      communityCardStacksSnapshot = FirebaseFirestore.instance
          .collection('institutions')
          .doc(appData.myInstitutionId)
          .collection('communities')
          .doc(widget.selectedCommunityData.id)
          .collection('cardstacks')
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer(
      builder: (context, value, child) => Scaffold(
          backgroundColor: isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
          body: CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              backgroundColor: isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
              actions: appData.myInstitutionName == ''
                  ? []
                  : [Icon(Icons.groups_2_outlined), Text(": ${widget.selectedCommunityData['users']}"), SizedBox(width: screenWidth * 0.05)],
              expandedHeight: appData.myInstitutionName == '' ? 0 : screenWidth * 0.34,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.fromLTRB(screenWidth * 0.05, 0, screenWidth * 0.05, screenHeight * 0.025),
                centerTitle: false,
                expandedTitleScale: 1.5,
                title: Text(
                  widget.selectedCommunityData['name'] ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: !isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                  ),
                ),
                background: Visibility(
                  visible: appData.myInstitutionName != '',
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset('lib/images/modern-classroom-3 seminar training student.jpg', fit: BoxFit.cover),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: screenWidth * 0.2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
                                Colors.transparent
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                      width: screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.025,
                          ),
                          Container(
                            child: StreamBuilder(
                                stream: communityCardStacksSnapshot,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: min(snapshot.data!.docs.length, 5),
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
                                                Visibility(
                                                  visible: appData.myInstitutionId == '',
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      appData.addInstitutionToAppData(ds.id, ds['name']);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: !isDarkMode(context)
                                                          ? const Color.fromARGB(255, 7, 12, 59)
                                                          : Color.fromARGB(255, 227, 230, 255),
                                                      foregroundColor: !isDarkMode(context)
                                                          ? Color.fromARGB(255, 227, 230, 255)
                                                          : const Color.fromARGB(255, 7, 12, 59),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12.0),
                                                      ),
                                                    ),
                                                    child: Text('Join'),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: appData.myInstitutionId != '',
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.arrow_forward_ios,
                                                        color: !isDarkMode(context)
                                                            ? const Color.fromARGB(255, 7, 12, 59)
                                                            : Color.fromARGB(255, 227, 230, 255)),
                                                  ),
                                                ),
                                                SizedBox(width: screenWidth * 0.05),
                                              ],
                                            )
                                          ]),
                                        );
                                      });
                                }),
                          ),
                          SizedBox(
                            height: screenHeight * 0.025,
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ])),
    );
  }
}
