import 'dart:ui';

import 'package:flashcards/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatGraph extends StatefulWidget {
  const StatGraph({super.key});

  @override
  State<StatGraph> createState() => _StatGraphState();
}

class _StatGraphState extends State<StatGraph> {
  late AppData appData;
  @override
  void didChangeDependencies() {
    appData = Provider.of<AppData>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: appData.cardsStatCount.length,
      itemBuilder: (context, index) {
        List<String> keys = appData.cardsStatCount.keys.toList();
        String key = keys[index];
        List<double> value = appData.cardsStatCount[key] ?? [];
        if (appData.cardsStatCount.length != 0) {
          return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: value[1] * 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: (value[2] + value[3]) * 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [
                        0.3,
                        0.6
                      ], colors: [
                        Colors.red,
                        Colors.yellow,
                      ]),
                    ),
                  ),
                ],
              ));
        } else {
          return Center(child: Text("No Data"));
        }
      },
    );
  }
}
