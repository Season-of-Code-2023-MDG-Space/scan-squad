import 'package:flutter/material.dart';
import 'package:scansquad/ui/auth_screens/login_screen.dart';
import 'package:scansquad/ui/auth_screens/signup_screen.dart';
import 'package:scansquad/ui/home/home_screen.dart';

void pushHomeScreen(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
}

void goToRegisterPage(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const SignUpScreen()),
  );
}

void goToLoginPage(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}
