import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scansquad/api/google_services/google_drive.dart';
import 'package:scansquad/routes/common_functions.dart';
import 'package:scansquad/routes/routes.dart';
import 'package:scansquad/widgets/styling_widgets.dart';
import '../../api/modal/load_file.dart';
import '../../asset/images.dart';
import '../../widgets/custom_widgets_class/customClipPath.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int len = -1;
  bool isLogged = false;
  void checkIfLogin() async {
    if (await (await GoogleDriveServices().logInUser()).isSignedIn()) {
      setState(() {
        isLogged = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDir().then(
      (value) {
        len = value.length;
      },
    );
    checkIfLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(167, 234, 235, 1),
      body: Stack(alignment: Alignment.topCenter, children: [
        Positioned(
            child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: titleName('Welcome to Scrypt', 28, FontWeight.w500,
              Colors.black, 'Montserrat', 1),
        )),
        ClipPath(
            clipper: CurveClipPath(),
            child: (len == 0)
                ? _onlyDriveContainer(isLogged)
                : FutureBuilder<List<FileSystemEntity?>>(
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
                                height:
                                    MediaQuery.of(context).size.height * 0.38,
                              ),
                              (snapshot.data!.isEmpty)
                                  ? emptyContainer()
                                  : Column(
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              _labelRow(context, 'Recent Files',
                                                  true),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              _customListView(
                                                  snapshot, _fileViewIcon)
                                            ],
                                          ),
                                        ),
                                        _labelRow(
                                            context, 'Uploaded Files', false),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        isLogged
                                            ? FutureBuilder<List<drive.File?>>(
                                                future: GoogleDriveServices()
                                                    .listGoogleDriveFiles(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return (snapshot
                                                                .data?.length !=
                                                            0)
                                                        ? _customListView(
                                                            snapshot,
                                                            _driveFileViewIcon)
                                                        : Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 35),
                                                            child: Center(
                                                                child: Text(
                                                                    'No file found in folder')),
                                                          );
                                                  } else {
                                                    return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 35),
                                                        child: customSpinLoader(
                                                            20));
                                                  }
                                                },
                                              )
                                            : Container(
                                                margin: const EdgeInsets.only(
                                                    top: 35),
                                                child: Center(
                                                    child: Text(
                                                        'Not connected with Google Account')),
                                              )
                                      ],
                                    ),
                            ],
                          ),
                        );
                      } else {
                        return customSpinLoader(40);
                      }
                    },
                  )),
      ]),
    );
  }
}

Widget _labelRow(BuildContext context, String heading, bool show) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          heading,
          style: TextStyle(fontSize: 18),
        ),
        show
            ? customTextButton(
                labelText: 'View All',
                onPressed: (() {
                  goToMyDocsPage(context);
                }))
            : Container()
      ],
    ),
  );
}

Widget _fileViewIcon(
  AsyncSnapshot snapshot,
  int index,
) {
  return Column(
    children: [
      Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Image.asset(
              CommonIcons.fileIcon,
              height: 60,
            ),
            Positioned(
              top: -6,
              left: 16,
              child: PopupMenuButton(
                icon: const Icon(
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
                              height: 16,
                            ),
                            Text(
                              'Share',
                              style: TextStyle(
                                color: Color.fromRGBO(23, 42, 49, 0.82),
                              ),
                            ),
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
                              height: 16,
                            ),
                            Text(
                              'Open',
                              style: TextStyle(
                                color: Color.fromRGBO(23, 42, 49, 0.82),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ];
                }),
              ),
            ),
          ],
        ),
      ),
      Text(
        '${snapshot.data?.reversed.toList()[index]?.absolute.path.substring(30)}',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Color.fromRGBO(55, 103, 121, 0.821),
            fontWeight: FontWeight.w700),
      ),
    ],
  );
}

Widget _driveFileViewIcon(
  AsyncSnapshot snapshot,
  int index,
) {
  return Column(
    children: [
      Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Image.asset(
          CommonIcons.fileIcon,
          height: 60,
        ),
      ),
      Text(
        snapshot.data[index].name,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            color: Color.fromRGBO(55, 103, 121, 0.821),
            fontWeight: FontWeight.w700),
      ),
    ],
  );
}

Widget _customListView(AsyncSnapshot snapshot,
    Widget Function(AsyncSnapshot<dynamic>, int) iconName) {
  return Container(
    height: 100,
    child: ListView.builder(
      itemCount: snapshot.data?.length,
      padding: const EdgeInsets.only(left: 30),
      scrollDirection: Axis.horizontal,
      itemBuilder: ((context, index) {
        return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: iconName(snapshot, index));
      }),
    ),
  );
}

Widget emptyContainer() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 40),
    child: Center(
      child: Text('Your recent files will appear here'),
    ),
  );
}

Widget _onlyDriveContainer(bool isLogged) {
  return isLogged
      ? FutureBuilder<List<drive.File?>>(
          future: GoogleDriveServices().listGoogleDriveFiles(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return (snapshot.data?.length != 0)
                  ? Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                          _labelRow(context, 'Uploaded Files', false),
                          const SizedBox(
                            height: 15,
                          ),
                          _customListView(snapshot, _driveFileViewIcon),
                        ],
                      ),
                    )
                  : Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 35),
                      child: Center(child: Text('No file found in folder')),
                    );
            } else {
              return Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Container(
                      color: Colors.white,
                      child: Center(child: customSpinLoader(20))));
            }
          },
        )
      : Container(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 35),
          child: Center(child: Text('Not connected with Google Account')),
        );
}
