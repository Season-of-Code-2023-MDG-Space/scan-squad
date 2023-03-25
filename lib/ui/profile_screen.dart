import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scansquad/api/firebase/fire_auth.dart';
import 'package:scansquad/asset/images.dart';
import 'package:scansquad/routes/common_functions.dart';
import 'package:scansquad/widgets/custom_widgets_class/customClipPath.dart';
import 'package:scansquad/widgets/styling_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/firebase/auth_validators.dart';
import '../api/google_services/google_drive.dart';
import '../routes/routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user});
  final User user;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _currentUser;
  bool isLogged = false;
  bool isEnabled = false;
  void checkIfLogin() async {
    if (await (await GoogleDriveServices().logInUser()).isSignedIn()) {
      setState(() {
        isLogged = true;
      });
    }
  }

  checkIsEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isEnabled = prefs.getBool("isLocEnabled") ?? false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkIfLogin();
    checkIsEnabled();
    _currentUser = widget.user;
    FireAuth.refreshUser(_currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(167, 234, 235, 1),
      body: Stack(alignment: Alignment.topCenter, children: [
        Positioned(
          top: 30,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textBaseline: TextBaseline.ideographic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Material(
                  elevation: 10,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    child: ClipOval(
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTANJ9zDmtYoNHsC_C0XG8rMtEvRyvu4XSCml5teioyBFr0wbvEqhF28zl3JfY50mDXIlI&usqp=CAU',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customText(_currentUser.displayName!, 24, FontWeight.w400,
                          Colors.black, EdgeInsets.zero),
                      SizedBox(
                        height: 5,
                      ),
                      customText(_currentUser.email!, 16, FontWeight.w300,
                          Colors.black, EdgeInsets.zero),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        ClipPath(
            clipper: CurveClipPath(),
            child: Container(
                color: Colors.white,
                child: Column(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.37,
                  ),
                  Container(
                    height: 45,
                    child: customListContainerIcon(
                        'Enable Location',
                        Colors.black,
                        [
                          Switch(
                            activeColor: Colors.white,
                            activeTrackColor: Colors.green,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Color.fromRGBO(41, 108, 123, 1),
                            splashRadius: 15.0,
                            value: isEnabled,
                            onChanged: ((val) async {
                              setState(() {
                                isEnabled = val;
                              });
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool("isLocEnabled", val);
                              if (isEnabled) {
                                await getUserLocation();
                              }
                            }),
                          ),
                        ],
                        true),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _currentUser.emailVerified
                      ? customListContainerIcon(
                          'Verify your mail',
                          Color.fromARGB(255, 128, 128, 128),
                          [
                            InkWell(
                              onTap: (() {
                                Fluttertoast.showToast(
                                    msg: 'Email is already verified.');
                              }),
                              child: Image.asset(
                                CommonIcons.forwardArrowDisabledIcon,
                                height: 16,
                              ),
                            )
                          ],
                          false)
                      : customListContainerIcon(
                          'Verify your mail',
                          Colors.black,
                          [
                            InkWell(
                              onTap: (() async {
                                await _currentUser.sendEmailVerification();
                                Fluttertoast.showToast(
                                    msg:
                                        'Verification email sent on your mail');
                              }),
                              child: Image.asset(
                                CommonIcons.forwardArrowIcon,
                                height: 16,
                              ),
                            )
                          ],
                          true),
                  SizedBox(
                    height: 10,
                  ),
                  isLogged
                      ? customListContainerIcon(
                          'Sign Out of Google',
                          Colors.black,
                          [
                            InkWell(
                              onTap: (() async {
                                await showDialog(
                                    context: context,
                                    builder: ((context) =>
                                        _warningLogoutPopUp(context)));
                              }),
                              child: Image.asset(
                                CommonIcons.forwardArrowIcon,
                                height: 16,
                              ),
                            ),
                          ],
                          true)
                      : customListContainerIcon(
                          'Sign Out of Google',
                          Color.fromARGB(255, 128, 128, 128),
                          [
                            InkWell(
                              onTap: (() {
                                Fluttertoast.showToast(
                                    msg: 'Not signed in with Google');
                              }),
                              child: Image.asset(
                                CommonIcons.forwardArrowDisabledIcon,
                                height: 16,
                              ),
                            ),
                          ],
                          false),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(),
                  SizedBox(
                    height: 5,
                  ),
                  customListContainerIcon(
                      'Delete profile',
                      Color.fromRGBO(255, 52, 52, 1),
                      [
                        InkWell(
                          onTap: (() async {
                            await showDialog(
                                context: context,
                                builder: ((context) => _warningDeletePopUp(
                                    context, _currentUser)));
                          }),
                          child: Image.asset(
                            CommonIcons.forwardArrowIcon,
                            height: 16,
                          ),
                        ),
                      ],
                      true),
                  SizedBox(
                    height: 10,
                  ),
                  customListContainerIcon(
                      'Change Password',
                      Colors.black,
                      [
                        InkWell(
                          onTap: (() async {
                            await FireAuth.resetPassword(
                                email: _currentUser.email);
                            Fluttertoast.showToast(
                                msg: 'Password reset mail sent on your mail');
                          }),
                          child: Image.asset(
                            CommonIcons.forwardArrowIcon,
                            height: 16,
                          ),
                        ),
                      ],
                      true)
                ]))),
      ]),
    );
  }
}

Widget _warningLogoutPopUp(BuildContext context) {
  return AlertDialog(
    title: const Text('Are you sure you want to delink your Google Account?'),
    actions: [
      customTextButton(
        onPressed: (() async {
          await GoogleDriveServices().logOutGoogle();
          Fluttertoast.showToast(msg: 'Signed Out of Google');
          Navigator.pop(context);
        }),
        labelText: 'Yes',
      ),
      customTextButton(
        onPressed: (() async {
          Navigator.pop(context);
        }),
        labelText: 'No',
      )
    ],
  );
}

Widget _warningDeletePopUp(BuildContext context, User user) {
  return AlertDialog(
    title: const Text('Are you sure you want to delete profile?'),
    content: const Text(
        'You will never be able to restore your account in future. We suggest keeping a backup of your files and media before performing this action.'),
    actions: [
      customTextButton(
        labelText: 'Yes',
        onPressed: (() async {
          bool result = await showDialog(
              context: context,
              builder: ((context) => reauthenticateUser(context, user)));
          if (result) {
            await FireAuth.deleteAccount(user);
            await GoogleDriveServices().logOutGoogle();
            Fluttertoast.showToast(msg: 'Account deleted');
            goToLoginPage(context);
          } else {
            Fluttertoast.showToast(msg: "Account can't be deleted");
          }
          Navigator.pop(context);
        }),
      ),
      customTextButton(
        labelText: 'No',
        onPressed: (() async {
          Navigator.pop(context);
        }),
      )
    ],
  );
}

Widget reauthenticateUser(BuildContext context, User user) {
  bool isReAuthenticateSucessful = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  return GestureDetector(
    onTap: (() {
      _focusEmail.unfocus();
      _focusPassword.unfocus();
    }),
    child: AlertDialog(
      title: Text('Re-Authenticate Yourself'),
      content: Container(
        // height: MediaQuery.of(context).size.height * 0.4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                  'Before performing this action we need to verify you are the owner of this account!'),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: editText(
                        hintText: "Email",
                        focusNode: _focusEmail,
                        controller: _emailTextController,
                        validator: (value) =>
                            Validator.validateEmail(email: value!),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 40,
                      child: editText(
                        hintText: "Password",
                        focusNode: _focusPassword,
                        controller: _passwordTextController,
                        obscureText: true,
                        validator: (value) =>
                            Validator.validatePassword(password: value!),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        customTextButton(
            labelText: 'Submit Details',
            onPressed: (() async {
              _focusEmail.unfocus();
              _focusPassword.unfocus();
              if (_formKey.currentState!.validate()) {
                await user.reauthenticateWithCredential(
                    EmailAuthProvider.credential(
                        email: _emailTextController.text,
                        password: _passwordTextController.text));
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reauthentication sucessful')));
                isReAuthenticateSucessful = true;
              }
              Navigator.pop(context, isReAuthenticateSucessful);
            })),
        customTextButton(
            labelText: 'Cancel',
            onPressed: (() {
              Navigator.pop(context, isReAuthenticateSucessful);
            }))
      ],
    ),
  );
}
