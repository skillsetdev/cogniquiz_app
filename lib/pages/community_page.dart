import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('cardStacks').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot<Map<String, dynamic>> ds = snapshot.data!.docs[index];
                  return Container(
                    height: 100,
                    width: 100,
                    color: Colors.red,
                    child: Card(
                      child: ListTile(
                        title: Text(ds['cardStackId']),
                        subtitle: Text(ds['name']),
                      ),
                    ),
                  );
                });
          }),
    ));
  }
}
