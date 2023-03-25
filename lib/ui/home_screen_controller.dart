import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scansquad/api/modal/pick_item.dart';
import 'package:scansquad/api/modal/process_image.dart';
import 'package:scansquad/asset/images.dart';
import 'package:scansquad/ui/home/home_screen.dart';
import 'package:scansquad/ui/profile_screen.dart';
import 'package:scansquad/widgets/custom_widgets_class/customAppBar.dart';
import 'package:scansquad/widgets/custom_widgets_class/customBottomBar.dart';
import 'package:scansquad/widgets/navBar.dart';
import 'package:scansquad/widgets/styling_widgets.dart';
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
        elevation: 5,
        shadowColor: Color.fromARGB(236, 251, 250, 250),
        shape: CurveAppBar(),
        backgroundColor: const Color.fromRGBO(69, 177, 200, 1),
        title: titleName(
            'Scrypt', 28, FontWeight.w700, Colors.white, 'SedanSC', 1.2),
        titleSpacing: 10,
        leading: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Image.asset(
            CommonIcons.logoIcon,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: customIconButton(CommonIcons.menuIcon, (() async {
              _scaffoldKey.currentState?.openDrawer();
            }), 25, 25),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _isProcessing
          ? const SpinKitFadingCube(
              color: const Color.fromRGBO(69, 177, 200, 1),
              size: 40.0,
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
                  elevation: 0,
                  tooltip: 'Create a new PDF',
                  backgroundColor: Color.fromRGBO(92, 201, 203, 1),
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
                backgroundColor: const Color.fromRGBO(167, 234, 235, 1),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                mouseCursor: SystemMouseCursors.grab,
                items: [
                  BottomNavigationBarItem(
                    activeIcon: Image.asset(CommonIcons.homeDarkIcon),
                    icon: Image.asset(CommonIcons.homeLightIcon),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: Image.asset(CommonIcons.userDarkIcon),
                    icon: Image.asset(CommonIcons.userLightIcon),
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
