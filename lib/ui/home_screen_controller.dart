import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scansquad/api/google_services/google_drive.dart';
import 'package:scansquad/api/modal/pick_item.dart';
import 'package:scansquad/api/modal/process_image.dart';
import 'package:scansquad/ui/home/home_screen.dart';
import 'package:scansquad/ui/profile_screen.dart';
import 'package:scansquad/widgets/custom_widgets_class/customAppBar.dart';
import 'package:scansquad/widgets/custom_widgets_class/customBottomBar.dart';
import 'package:scansquad/widgets/navBar.dart';
import '../routes/routes.dart';

class HomeScreenController extends StatefulWidget {
  const HomeScreenController({super.key, required this.user});
  final User user;
  @override
  State<HomeScreenController> createState() => _HomeScreenControllerState();
}

class _HomeScreenControllerState extends State<HomeScreenController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late User _currentUser;
  bool _isProcessing = false;
  int _selectedIndex = 0;
  static final List<Widget> _pages = [
    HomeScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _pages.add(ProfilePage(user: _currentUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavBar(_currentUser),
      appBar: AppBar(
        shape: CurveAppBar(),
        backgroundColor: const Color.fromRGBO(38, 126, 157, 1),
        title: const Text(
          "Scrypt",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        titleSpacing: 30,
        leading: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Icon(
            Icons.pages,
            size: 50,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: (() async {
                  _scaffoldKey.currentState?.openDrawer();
                }),
                icon: Icon(
                  Icons.menu_sharp,
                  size: 30,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: (() async {
                  final file = await pickFiles();
                  final fileToUpload = File(file!.files.first.path!);
                  await GoogleDriveServices().uploadToNormal(fileToUpload);
                }),
                icon: Icon(
                  Icons.sync,
                  size: 30,
                )),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _isProcessing
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                color: Colors.black,
              ),
            )
          : _pages[_selectedIndex],
      bottomNavigationBar: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -40,
              child: Container(
                height: 70,
                width: 70,
                child: FloatingActionButton(
                  tooltip: 'Create a new PDF',
                  backgroundColor: const Color.fromRGBO(97, 180, 209, 1),
                  onPressed: (() async {
                    setState(() {
                      _isProcessing = true;
                    });
                    final pickedFile = await pickImage();
                    if (pickedFile != null) {
                      final mImage = await ImageProcess().writeExifData(
                        await pickedFile.readAsBytes(),
                        userName: _currentUser.displayName!,
                      );
                      setState(() {
                        _isProcessing = false;
                      });
                      goToCapturedImagesPage(context, _currentUser, mImage);
                    }
                    setState(() {
                      _isProcessing = false;
                    });
                  }),
                  child: const Icon(
                    Icons.add,
                    size: 32,
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: CustomCurveBottomBar(),
              child: BottomNavigationBar(
                elevation: 4,
                iconSize: 32,
                backgroundColor: const Color.fromRGBO(117, 202, 233, 1),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                mouseCursor: SystemMouseCursors.grab,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_box_rounded),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex, //New
                onTap: _onItemTapped,
              ),
            ),
          ]),
    );
  }
}
