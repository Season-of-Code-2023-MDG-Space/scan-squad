import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scansquad/routes/common_functions.dart';
import 'package:scansquad/routes/routes.dart';
import 'package:scansquad/widgets/styling_widgets.dart';
import '../../api/modal/load_file.dart';
import '../../asset/images.dart';
import '../../widgets/custom_widgets_class/customClipPath.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(167, 234, 235, 1),
      body: Stack(alignment: Alignment.topCenter, children: [
        Positioned(
            child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: titleName('Welcome to Scrypt!!', 28, FontWeight.w500,
              Colors.black, 'Montserrat', 1),
        )),
        ClipPath(
          clipper: CurveClipPath(),
          child: FutureBuilder<List<FileSystemEntity?>>(
            future: getDir(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data != null) {
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.38,
                      ),
                      (snapshot.data!.isEmpty)
                          ? emptyContainer()
                          : Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Recent Files',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      customTextButton(
                                          labelText: 'View All',
                                          onPressed: (() {
                                            goToMyDocsPage(context);
                                          }))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 80,
                                    child: ListView.builder(
                                      itemCount: snapshot.data?.length,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: ((context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 30),
                                          child: _fileViewIcon(
                                            snapshot,
                                            index,
                                          ),
                                        );
                                      }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                );
              } else {
                return const SpinKitFadingCube(
                  color: const Color.fromRGBO(69, 177, 200, 1),
                  size: 40.0,
                );
              }
            },
          ),
        ),
      ]),
    );
  }
}

Widget _fileViewIcon(
  AsyncSnapshot snapshot,
  int index,
) {
  return Container(
    decoration: BoxDecoration(
        color: Color.fromRGBO(167, 234, 235, 1),
        borderRadius: BorderRadius.all(Radius.circular(30))),
    child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Image.asset(CommonIcons.fileIcon),
          Positioned(
              top: -3,
              left: 30,
              child: PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Color.fromRGBO(55, 103, 121, 0.821),
                    size: 20,
                  ),
                  color: Color.fromRGBO(236, 237, 238, 0.56),
                  elevation: 0,
                  itemBuilder: ((context) {
                    return [
                      PopupMenuItem(
                        onTap: (() {
                          sharePDF(snapshot.data?.reversed
                              .toList()[index]
                              ?.absolute
                              .path);
                        }),
                        child: Container(
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                CommonIcons.fshareIcon,
                                height: 20,
                              ),
                              Text('Share'),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        onTap: (() async {
                          await openPdfFile(snapshot.data?.reversed
                              .toList()[index]
                              .absolute
                              .path
                              .substring(30));
                        }),
                        child: Container(
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                CommonIcons.openFileIcon,
                                height: 20,
                              ),
                              Text('Open'),
                            ],
                          ),
                        ),
                      )
                    ];
                  }))),
          Positioned(
            bottom: -20,
            child: Text(
              '${snapshot.data?.reversed.toList()[index]?.absolute.path.substring(30)}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Color.fromRGBO(55, 103, 121, 0.821),
                  fontWeight: FontWeight.w700),
            ),
          ),
        ]),
  );
}

Widget emptyContainer() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 40),
    child: const Center(
      child: Text('Your recent files will appear here'),
    ),
  );
}
