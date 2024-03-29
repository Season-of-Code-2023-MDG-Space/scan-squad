import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scansquad/api/google_services/google_drive.dart';
import 'package:scansquad/api/modal/pdfToImage.dart';
import 'package:scansquad/api/modal/verify_data.dart';
import 'package:scansquad/asset/images.dart';
import 'package:scansquad/ui/profile_screen.dart';
import 'package:scansquad/widgets/styling_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/modal/pick_item.dart';
import '../routes/routes.dart';

class NavBar extends StatelessWidget {
  const NavBar(this.user, {super.key});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: const BoxDecoration(
                color: Color.fromRGBO(69, 177, 200, 1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(200),
                    bottomRight: Radius.circular(200))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
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
                SizedBox(
                  height: 10,
                ),
                Text(
                  user.displayName!,
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  user.email!,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(CommonIcons.scanIcon),
            title: Text('Verify PDF'),
            onTap: (() async {
              final result = await pickFiles();
              final qrWithVerificationDetails =
                  await PdfToImage().convertToImageAndScan(result!);
              await showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildVerifyPopupDialog(context, qrWithVerificationDetails),
              );
            }),
          ),
          ListTile(
            leading: Icon(Icons.folder_open_outlined),
            title: Text('My Docs'),
            onTap: () {
              goToMyDocsPage(context);
            },
          ),
          ListTile(
            leading: Image.asset(
              CommonIcons.syncIcon,
              height: 24,
              width: 24,
            ),
            title: Text('Sync Files'),
            onTap: () async {
              if (await GoogleDriveServices().uploadToDrive(
                  File((await pickFiles())!.files.first.path!))) {
                Fluttertoast.showToast(msg: 'Upload Sucessful');
              } else {
                Fluttertoast.showToast(msg: 'Issue uploading the file');
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Settings'),
            onTap: () => null,
          ),
          ListTile(
            leading: Image.asset(CommonIcons.policyIcon, height: 24, width: 24),
            title: Text('Policies'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.feedback_outlined),
            title: Text('Feedback'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app_sharp),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: ((context) => _warningLogoutPopUp(context)));
            },
          ),
        ],
      ),
    );
  }
}

Widget _warningLogoutPopUp(BuildContext context) {
  return AlertDialog(
    title: const Text('Are you sure you want to logout?'),
    actions: [
      customTextButton(
        onPressed: (() async {
          await FirebaseAuth.instance.signOut();
          await GoogleDriveServices().logOutGoogle();
          (await SharedPreferences.getInstance()).clear();
          goToLoginPage(context);
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

Widget _buildVerifyPopupDialog(
    BuildContext context, Map<String, dynamic> qrWithVerification) {
  var data = qrWithVerification.values;
  bool validityStat = data.elementAt(0);
  print('======$validityStat');
  return AlertDialog(
    actions: [
      IconButton(
          padding: EdgeInsets.only(right: 30, bottom: 10),
          onPressed: (() {
            Navigator.pop(context);
          }),
          icon: Icon(Icons.close_outlined))
    ],
    shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
    icon: validityStat
        ? Icon(
            Icons.verified_sharp,
            size: 64,
            color: Colors.green,
          )
        : Icon(
            Icons.warning,
            size: 64,
            color: Colors.red,
          ),
    title: validityStat
        ? Text(
            'PDF Verified Sucessfully',
            style: TextStyle(fontSize: 22),
          )
        : Text(
            'Unable To Verify PDF!',
            style: TextStyle(fontSize: 22),
          ),
    content: validityStat
        ? Container(
            height: 210,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Verification Details',
                  style: TextStyle(fontSize: 18),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Username Of Student: ${data.elementAt(1)} '),
                        Text(
                            'Time Duration Of Making PDF: ${getFormattedTimeDuration(data.elementAt(2))} - ${getFormattedTimeDuration(data.elementAt(3))} '),
                        Text('Last Modified on ${data.elementAt(4)}')
                      ],
                    )),
              ],
            ),
          )
        : Container(
            height: 160,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'The pdf may contain forged data or the selected file is incorrect'),
                Text('Last Modified on ${data.elementAt(1)}')
              ],
            ),
          ),
  );
}
