import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _passwordVerifyTextController = TextEditingController();
  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusVerifyPassword = FocusNode();
  bool _showPassword = false;
  void initState() {
    // TODO: implement initState
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
        backgroundColor: Color.fromRGBO(38, 126, 157, 1),
        body: SingleChildScrollView(
          child: Stack(children: [
            Positioned(
              child: Center(
                child: bigText('Create an account', Colors.black,
                    const EdgeInsets.symmetric(vertical: 80)),
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
                        height: MediaQuery.of(context).size.height * 0.48,
                      ),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
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
                                            name: _userNameTextController.text),
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
                                        Validator.validateEmail(email: value!),
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
                                    obscureText: _showPassword ? false : true,
                                    requireSuffixIcon: IconButton(
                                      onPressed: (() {
                                        setState(() {
                                          _showPassword = !_showPassword;
                                        });
                                      }),
                                      icon: const Icon(Icons.remove_red_eye),
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
                                    controller: _passwordVerifyTextController,
                                    obscureText: _showPassword ? false : true,
                                    requireSuffixIcon: IconButton(
                                      onPressed: (() {
                                        setState(() {
                                          _showPassword = !_showPassword;
                                        });
                                      }),
                                      icon: const Icon(Icons.remove_red_eye),
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
                        const EdgeInsets.only(left: 40, right: 40, top: 25),
                        (() async {
                          _focusName.unfocus();
                          _focusEmail.unfocus();
                          _focusPassword.unfocus();
                          if (_formKey.currentState!.validate() ||
                              _passwordVerifyTextController.text ==
                                  _passwordTextController.text) {
                            User? user =
                                await FireAuth.registerUsingEmailPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text,
                              userName: _userNameTextController.text,
                            );
                            if (user != null) {
                              pushHomeScreen(context);
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
