import 'dart:ui';
import 'package:flashcards/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatGraph extends StatefulWidget {
  const StatGraph({required this.widgetHeight, super.key});
  final widgetHeight;

  @override
  State<StatGraph> createState() => _StatGraphState();
}

class _StatGraphState extends State<StatGraph> {
  late AppData appData;
  late double graphHeight;

  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  @override
  void didChangeDependencies() {
    appData = Provider.of<AppData>(context);
    graphHeight = widget.widgetHeight - 16 * 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Column(
            children: [
              Text('250'),
              Spacer(),
              Text('200'),
              Spacer(),
              Text('150'),
              Spacer(),
              Text('100'),
              Spacer(),
              Text('50'),
              Spacer(),
              Text('0'),
            ],
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: isDarkMode(context) ? Colors.white24 : Colors.black54, width: 1),
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: appData.cardsStatCount.length,
                  itemBuilder: (context, index) {
                    List<String> keys = appData.cardsStatCount.keys.toList();
                    String key = keys[index];
                    List<double> value = appData.cardsStatCount[key] ?? [];
                    if (appData.cardsStatCount.length != 0) {
                      return Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: value[1] * (graphHeight / 250),
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
                                height: (value[2] + value[3]) * (graphHeight / 250),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
