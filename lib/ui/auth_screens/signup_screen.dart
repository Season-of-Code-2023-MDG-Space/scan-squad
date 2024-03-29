import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../api/firebase/auth_validators.dart';
import '../../api/firebase/fire_auth.dart';
import '../../routes/routes.dart';
import '../../widgets/custom_widgets_class/customClipPath.dart';
import '../../widgets/styling_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _passwordVerifyTextController =
      TextEditingController();
  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusVerifyPassword = FocusNode();
  bool _showPassword = false;
  bool _isProcessing = false;
  @override
  void initState() {
    super.initState();
    _focusName.unfocus();
    _focusEmail.unfocus();
    _focusPassword.unfocus();
    _focusVerifyPassword.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
        _focusVerifyPassword.unfocus();
      }),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(69, 177, 200, 1),
        body: _isProcessing
            ? const SpinKitFadingCube(
                color: Color.fromARGB(255, 28, 70, 80),
                size: 40.0,
              )
            : SingleChildScrollView(
                child: Stack(children: [
                  Positioned(
                    child: Center(
                      child: bigText(
                          'Create an account',
                          Color.fromARGB(255, 57, 57, 57),
                          const EdgeInsets.symmetric(vertical: 70)),
                    ),
                  ),
                  SingleChildScrollView(
                    child: ClipPath(
                      clipper: CurveClipPath(),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.48,
                            ),
                            Form(
                              key: _formKey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Container(
                                  height: 300,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: editText(
                                          hintText: "Enter a username",
                                          focusNode: _focusName,
                                          controller: _userNameTextController,
                                          validator: (value) =>
                                              Validator.validateName(
                                                  name: _userNameTextController
                                                      .text),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Expanded(
                                        child: editText(
                                          hintText: "Enter your email address",
                                          focusNode: _focusEmail,
                                          controller: _emailTextController,
                                          validator: (value) =>
                                              Validator.validateEmail(
                                                  email: value!),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Expanded(
                                        child: editText(
                                          hintText: "Create a password",
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
                                                Icons.remove_red_eye),
                                          ),
                                          validator: (value) =>
                                              Validator.validatePassword(
                                                  password: value!),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Expanded(
                                        child: editText(
                                          hintText: "Verify your password",
                                          focusNode: _focusVerifyPassword,
                                          controller:
                                              _passwordVerifyTextController,
                                          obscureText:
                                              _showPassword ? false : true,
                                          requireSuffixIcon: IconButton(
                                            onPressed: (() {
                                              setState(() {
                                                _showPassword = !_showPassword;
                                              });
                                            }),
                                            icon: const Icon(
                                                Icons.remove_red_eye),
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
                            flexedTextButton(
                              "Sign In",
                              const EdgeInsets.only(
                                  left: 40, right: 40, top: 25),
                              (() async {
                                _focusName.unfocus();
                                _focusEmail.unfocus();
                                _focusPassword.unfocus();
                                if (_formKey.currentState!.validate() &&
                                    _passwordVerifyTextController.text ==
                                        _passwordTextController.text) {
                                  setState(() {
                                    _isProcessing = true;
                                  });
                                  User? user =
                                      await FireAuth.registerUsingEmailPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                    userName: _userNameTextController.text,
                                  );
                                  setState(() {
                                    _isProcessing = false;
                                  });
                                  if (user != null) {
                                    pushHomeScreen(context, user);
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Password fields should be same')));
                                }
                              }),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                customText(
                                    'Already having an account?',
                                    16,
                                    FontWeight.w400,
                                    const Color.fromRGBO(130, 130, 130, 1),
                                    const EdgeInsets.all(0)),
                                customTextButton(
                                    labelText: 'Login Now',
                                    onPressed: (() {
                                      goToLoginPage(context);
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
