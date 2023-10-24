import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

//make a darker bg-color ; make a card view; after the pressed button rotate to navigate to other page(lighter)
class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();
  bool signInChosen = true;
  late FlipCardController _controller;

  Future signUp() async {
    if (_signUpPasswordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _signUpEmailController.text.trim(),
          password: _signUpPasswordController.text.trim());
    } else if (_signUpPasswordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords don't match")),
      );
    }
  }

  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  void _flipTheCard() {
    _controller.toggleCard();
  }

  void _hintFlipCard() {
    _controller.hint(
      duration: Duration(microseconds: 300),
      total: Duration(seconds: 2),
    );
  }

  @override
  void initState() {
    _controller = FlipCardController();
    super.initState();
  }

  @override
  void dispose() {
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _confirmPasswordController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FlipCard(
                    controller: _controller,
                    flipOnTouch: false,
                    front: Container(
                      height: screenHeight * 0.8,
                      width: screenWidth * 0.9,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: isDarkMode(context)
                                  ? Colors.white
                                  : Colors.black54,
                              width: 0.5),
                          color: !isDarkMode(context)
                              ? Color.fromARGB(185, 255, 255, 255)
                              : const Color.fromARGB(30, 255, 255, 255),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.01),
                              child: Text(
                                "Welcome To CogniQuiz!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.075,
                                    color: isDarkMode(context)
                                        ? Colors.white
                                        : Colors.black87),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.3,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.01),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    signInChosen = true;
                                  });

                                  _flipTheCard();
                                },
                                child: Container(
                                    height: 65,
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
                                        borderRadius:
                                            BorderRadius.circular(12)),
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
                                onTap: () {
                                  setState(() {
                                    signInChosen = false;
                                  });
                                  _flipTheCard();
                                },
                                child: Container(
                                    height: 65,
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
                                        borderRadius:
                                            BorderRadius.circular(12)),
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
                    back: !signInChosen
                        ? Container(
                            height: screenHeight * 0.8,
                            width: screenWidth * 0.9,
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: isDarkMode(context)
                                        ? Colors.white
                                        : Colors.black54,
                                    width: 0.5),
                                color: !isDarkMode(context)
                                    ? Color.fromARGB(255, 128, 141, 254)
                                    : Color.fromARGB(135, 255, 255, 255),
                                // const Color.fromARGB(30, 255, 255, 255),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _flipTheCard();
                                    },
                                    icon: Icon(Icons.arrow_back),
                                    iconSize: screenWidth * 0.08,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.01),
                                    child: Text(
                                      "Create a New Account!",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.075,
                                        color: isDarkMode(context)
                                            ? const Color.fromARGB(
                                                255, 7, 12, 59)
                                            : Color.fromARGB(
                                                255, 227, 230, 255),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.08,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.01),
                                    child: GestureDetector(
                                      onTap: () {
                                        _flipTheCard();
                                      },
                                      child: Container(
                                        height: 65,
                                        width: screenWidth * 0.9,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: isDarkMode(context)
                                                    ? Colors.white
                                                    : Colors.black54,
                                                width: 0.5),
                                            color: !isDarkMode(context)
                                                ? Color.fromARGB(
                                                    94, 208, 211, 255)
                                                //Color.fromARGB(255, 100, 109, 227)
                                                : Color.fromARGB(
                                                    255, 72, 80, 197),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Center(
                                            child: TextField(
                                                controller:
                                                    _signUpEmailController,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Enter Your Email..",
                                                    hintStyle: TextStyle(
                                                      color: isDarkMode(context)
                                                          ? Colors.white60
                                                          : Colors.black54,
                                                    ),
                                                    border: InputBorder.none)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.01),
                                    child: GestureDetector(
                                      onTap: () {
                                        _flipTheCard();
                                      },
                                      child: Container(
                                        height: 65,
                                        width: screenWidth * 0.9,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: isDarkMode(context)
                                                    ? Colors.white
                                                    : Colors.black54,
                                                width: 0.5),
                                            color: !isDarkMode(context)
                                                ? Color.fromARGB(
                                                    94, 208, 211, 255)
                                                //Color.fromARGB(255, 100, 109, 227)
                                                : Color.fromARGB(
                                                    255, 72, 80, 197),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Center(
                                            child: TextField(
                                                controller:
                                                    _signUpPasswordController,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Create Password..",
                                                    hintStyle: TextStyle(
                                                      color: isDarkMode(context)
                                                          ? Colors.white60
                                                          : Colors.black54,
                                                    ),
                                                    border: InputBorder.none)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.01),
                                    child: GestureDetector(
                                      onTap: () {
                                        _flipTheCard();
                                      },
                                      child: Container(
                                        height: 65,
                                        width: screenWidth * 0.9,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: isDarkMode(context)
                                                    ? Colors.white
                                                    : Colors.black54,
                                                width: 0.5),
                                            color: !isDarkMode(context)
                                                ? Color.fromARGB(
                                                    94, 208, 211, 255)
                                                //Color.fromARGB(255, 100, 109, 227)
                                                : Color.fromARGB(
                                                    255, 72, 80, 197),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Center(
                                            child: TextField(
                                                controller:
                                                    _confirmPasswordController,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Confirm Password..",
                                                    hintStyle: TextStyle(
                                                      color: isDarkMode(context)
                                                          ? Colors.white60
                                                          : Colors.black54,
                                                    ),
                                                    border: InputBorder.none)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.01),
                                    child: GestureDetector(
                                      onTap: () {
                                        signUp();
                                      },
                                      child: Container(
                                          height: 65,
                                          width: screenWidth * 0.9,
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: isDarkMode(context)
                                                      ? Colors.white
                                                      : Colors.black54,
                                                  width: 0.5),
                                              color: !isDarkMode(context)
                                                  ? Color.fromARGB(
                                                      94, 208, 211, 255)
                                                  : Color.fromARGB(
                                                      255, 72, 80, 197),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Center(
                                            child: Text('Sign Up',
                                                style: TextStyle(
                                                    color: isDarkMode(context)
                                                        ? Colors.white
                                                        : Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )),
                                    ),
                                  ),
                                ]),
                          )
                        : Container(
                            height: screenHeight * 0.8,
                            width: screenWidth * 0.9,
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: isDarkMode(context)
                                        ? Colors.white
                                        : Colors.black54,
                                    width: 0.5),
                                color: !isDarkMode(context)
                                    ? Color.fromARGB(255, 128, 141, 254)
                                    : Color.fromARGB(135, 255, 255, 255),
                                // const Color.fromARGB(30, 255, 255, 255),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _flipTheCard();
                                    },
                                    icon: Icon(Icons.arrow_back),
                                    iconSize: screenWidth * 0.08,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.01),
                                    child: Text(
                                      "Enter Your Account!",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.075,
                                        color: isDarkMode(context)
                                            ? const Color.fromARGB(
                                                255, 7, 12, 59)
                                            : Color.fromARGB(
                                                255, 227, 230, 255),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.16,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.01),
                                    child: GestureDetector(
                                      onTap: () {
                                        _flipTheCard();
                                      },
                                      child: Container(
                                        height: 65,
                                        width: screenWidth * 0.9,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: isDarkMode(context)
                                                    ? Colors.white
                                                    : Colors.black54,
                                                width: 0.5),
                                            color: !isDarkMode(context)
                                                ? Color.fromARGB(
                                                    94, 208, 211, 255)
                                                //Color.fromARGB(255, 100, 109, 227)
                                                : Color.fromARGB(
                                                    255, 72, 80, 197),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Center(
                                            child: TextField(
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Enter Your Email..",
                                                    hintStyle: TextStyle(
                                                      color: isDarkMode(context)
                                                          ? Colors.white60
                                                          : Colors.black54,
                                                    ),
                                                    border: InputBorder.none)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.01),
                                    child: GestureDetector(
                                      onTap: () {
                                        _flipTheCard();
                                      },
                                      child: Container(
                                        height: 65,
                                        width: screenWidth * 0.9,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: isDarkMode(context)
                                                    ? Colors.white
                                                    : Colors.black54,
                                                width: 0.5),
                                            color: !isDarkMode(context)
                                                ? Color.fromARGB(
                                                    94, 208, 211, 255)
                                                //Color.fromARGB(255, 100, 109, 227)
                                                : Color.fromARGB(
                                                    255, 72, 80, 197),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Center(
                                            child: TextField(
                                                decoration: InputDecoration(
                                                    hintText:
                                                        "Enter Your Password..",
                                                    hintStyle: TextStyle(
                                                      color: isDarkMode(context)
                                                          ? Colors.white60
                                                          : Colors.black54,
                                                    ),
                                                    border: InputBorder.none)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.01),
                                    child: GestureDetector(
                                      onTap: () {
                                        _flipTheCard();
                                      },
                                      child: Container(
                                          height: 65,
                                          width: screenWidth * 0.9,
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: isDarkMode(context)
                                                      ? Colors.white
                                                      : Colors.black54,
                                                  width: 0.5),
                                              color: !isDarkMode(context)
                                                  ? Color.fromARGB(
                                                      94, 208, 211, 255)
                                                  : Color.fromARGB(
                                                      255, 72, 80, 197),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Center(
                                            child: Text('Sign Up',
                                                style: TextStyle(
                                                    color: isDarkMode(context)
                                                        ? Colors.white
                                                        : Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )),
                                    ),
                                  ),
                                ]),
                          ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: isDarkMode(context)
          ? const Color.fromARGB(255, 7, 12, 59)
          : Color.fromARGB(255, 227, 230, 255),
    );
  }
}
