import 'package:flutter/material.dart';

// minor update
//make a darker bg-color ; make a card view; after the pressed button rotate to navigate to other page(lighter)
class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: screenHeight * 0.8,
                width: screenWidth * 0.9,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            isDarkMode(context) ? Colors.white : Colors.black54,
                        width: 0.5),
                    color: !isDarkMode(context)
                        ? Color.fromARGB(185, 255, 255, 255)
                        : const Color.fromARGB(30, 255, 255, 255),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome To CogniQuiz!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.075,
                            color: isDarkMode(context)
                                ? Colors.white
                                : Colors.black87),
                      ),
                      SizedBox(
                        height: 200,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                              width: screenWidth * 0.9,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: isDarkMode(context)
                                          ? Colors.white
                                          : Colors.black54,
                                      width: 0.5),
                                  color: !isDarkMode(context)
                                      ? Color.fromARGB(94, 184, 188, 249)
                                      //Color.fromARGB(255, 100, 109, 227)
                                      : Color.fromARGB(255, 72, 80, 197),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Text('Sign In',
                                    style: TextStyle(
                                        color: isDarkMode(context)
                                            ? Colors.white
                                            : Colors.black54,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                              width: screenWidth * 0.9,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: isDarkMode(context)
                                          ? Colors.white
                                          : Colors.black54,
                                      width: 0.5),
                                  color: !isDarkMode(context)
                                      ? Color.fromARGB(94, 184, 188, 249)
                                      : Color.fromARGB(255, 72, 80, 197),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Text('Sign Up',
                                    style: TextStyle(
                                        color: isDarkMode(context)
                                            ? Colors.white
                                            : Colors.black54,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ),
                      ),
                    ]),
              ),
            ]),
          ],
        ),
      ),
      backgroundColor: isDarkMode(context)
          ? const Color.fromARGB(255, 7, 12, 59)
          : Color.fromARGB(255, 227, 230, 255),
    );
  }
}
