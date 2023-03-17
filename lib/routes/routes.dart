import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scansquad/ui/auth_screens/login_screen.dart';
import 'package:scansquad/ui/auth_screens/signup_screen.dart';
import 'package:scansquad/ui/capture_screen.dart';
import 'package:scansquad/ui/home/saved_docs.dart';
import 'package:scansquad/ui/home_screen_controller.dart';
import '../ui/photo_view.dart';

void pushHomeScreen(BuildContext context, User? user) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
        builder: (context) => HomeScreenController(
              user: user!,
            )),
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

void goToCapturedImagesPage(
    BuildContext context, User? user, Uint8List uint8list) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => CapturedImagesScreen(
      user: user!,
      uint8list0: uint8list,
    ),
  ));
}

void goToPhotoViewPage(BuildContext context, Uint8List uint8list) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FullImageView(
            viewLargeImage: uint8list,
          )));
}

void goToMyDocsPage(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => SavedFiles()));
}
