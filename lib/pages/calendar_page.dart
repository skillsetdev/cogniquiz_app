import 'package:flashcards/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

// Next Task: Add stats to days (graph)
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  late AppData appData;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  @override
  Widget build(BuildContext context) {
    appData = Provider.of<AppData>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer(
        builder: (context, value, child) => Scaffold(
            backgroundColor: isDarkMode(context) ? const Color.fromARGB(255, 7, 12, 59) : Color.fromARGB(255, 227, 230, 255),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      TableCalendar(
                        rowHeight: 50,
                        calendarFormat: _calendarFormat,
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(_focusedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_focusedDay, selectedDay)) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          }
                        },
                        calendarStyle: CalendarStyle(
                          defaultTextStyle: TextStyle(color: Colors.white),
                          outsideDaysVisible: true,
                          weekendTextStyle: TextStyle(color: Colors.white),
                          outsideTextStyle: TextStyle(color: Colors.grey),
                        ),
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        firstDay: DateTime.utc(2021, 1, 1),
                        lastDay: DateTime.utc(2024, 12, 31),
                        focusedDay: _focusedDay,
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, date, focusedDay) {
                            return Container(
                              margin: EdgeInsets.all(1),
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: appData.daysProgress[date.toString()] ?? (isDarkMode(context) ? Colors.white24 : Colors.black54),
                                      width: appData.daysProgress.containsKey(date.toString()) ? 3 : 1),
                                  color: //appData.daysProgress.containsKey(date.toString()) ? appData.daysProgress[date.toString()]:
                                      !isDarkMode(context) ? Color.fromARGB(255, 128, 141, 254) : Color.fromARGB(255, 72, 80, 197),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black54),
                                ),
                              ),
                            );
                          },
                          todayBuilder: (context, date, focusedDay) {
                            return Container(
                              margin: EdgeInsets.all(1),
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: appData.daysProgress[date.toString()] ?? (isDarkMode(context) ? Colors.white24 : Colors.black54),
                                      width: appData.daysProgress.containsKey(date.toString()) ? 3 : 1),
                                  color: !isDarkMode(context) ? Color.fromARGB(255, 128, 141, 254) : Color.fromARGB(255, 72, 80, 197),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          },
                          selectedBuilder: (context, date, focusedDay) {
                            return GestureDetector(
                              onTap: () {
                                print(date.toString());
                              },
                              child: Container(
                                margin: EdgeInsets.all(1),
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                    border: Border.all(color: isDarkMode(context) ? Colors.white54 : Colors.black54, width: 3),
                                    color: !isDarkMode(context)
                                        ? Color.fromARGB(255, 128, 141, 254)
                                        //Color.fromARGB(255, 100, 109, 227)
                                        : Color.fromARGB(255, 72, 80, 197),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Center(
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black54, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Slider(
                        value: appData.sliderValue,
                        max: 100,
                        divisions: 100,
                        label: appData.sliderValue.round().toString(),
                        onChanged: (double value) {
                          appData.changeSliderValue(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
