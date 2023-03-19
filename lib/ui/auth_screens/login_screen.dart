import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scansquad/api/firebase/auth_validators.dart';
import 'package:scansquad/routes/routes.dart';
import 'package:scansquad/widgets/custom_widgets_class/customClipPath.dart';
import 'package:scansquad/widgets/styling_widgets.dart';
import '../../api/firebase/fire_auth.dart';
import '../../asset/images.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _showPassword = false;
  bool _isProcessing = false;
  @override
  void initState() {
    super.initState();
    _focusEmail.unfocus();
    _focusPassword.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      }),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(69, 177, 200, 1),
        body: _isProcessing
            ? const SpinKitFadingCube(
                color: const Color.fromRGBO(69, 177, 200, 1),
                size: 40.0,
              )
            : SingleChildScrollView(
                child: Stack(children: [
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            CommonIcons.logoIcon,
                            height: 65,
                            width: 65,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              titleName('Scrypt', 28, FontWeight.w800,
                                  Colors.white, 'SedanSC', 1.0),
                              Text(
                                'Tagline',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: ClipPath(
                      clipper: CurveClipPath(),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                            ),
                            bigText('Login', Color.fromARGB(255, 57, 57, 57),
                                const EdgeInsets.symmetric(vertical: 30)),
                            Form(
                              key: _formKey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Container(
                                  height: 150,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: editText(
                                          hintText: "Email",
                                          focusNode: _focusEmail,
                                          controller: _emailTextController,
                                          validator: (value) =>
                                              Validator.validateEmail(
                                                  email: value!),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: editText(
                                          hintText: "Password",
                                          focusNode: _focusPassword,
                                          controller: _passwordTextController,
                                          obscureText:
                                              _showPassword ? false : true,
                                          requireSuffixIcon: IconButton(
                                            onPressed: (() {
                                              setState(() {
                                                _showPassword = !_showPassword;
                                              });
                                            }),
                                            icon: const Icon(
                                                Icons.remove_red_eye_sharp),
                                          ),
                                          validator: (value) =>
                                              Validator.validatePassword(
                                                  password: value!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  customTextButton(
                                    onPressed: (() async {
                                      if (_emailTextController
                                          .text.isNotEmpty) {
                                        await FireAuth.resetPassword(
                                            email: _emailTextController.text);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Reset email sent to the registered email address')));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Email field can't be empty")));
                                      }
                                    }),
                                    labelText: "Forgot Password?",
                                  ),
                                ],
                              ),
                            ),
                            flexedTextButton(
                              "Log In",
                              const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              (() async {
                                _focusEmail.unfocus();
                                _focusPassword.unfocus();
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });
                                  User? user =
                                      await FireAuth.signInUsingEmailPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                  );
                                  setState(() {
                                    _isProcessing = false;
                                  });
                                  if (user != null) {
                                    pushHomeScreen(context, user);
                                  }
                                }
                              }),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                customText(
                                    'Don’t have account?',
                                    16,
                                    FontWeight.w400,
                                    const Color.fromRGBO(130, 130, 130, 1),
                                    const EdgeInsets.all(0)),
                                customTextButton(
                                    labelText: 'Create Now',
                                    onPressed: (() {
                                      goToRegisterPage(context);
                                    }))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
      ),
    );
  }
}
