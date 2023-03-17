import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scansquad/routes/common_functions.dart';
import 'package:scansquad/routes/routes.dart';
import 'package:scansquad/widgets/styling_widgets.dart';
import '../../api/modal/load_file.dart';
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
      backgroundColor: Color.fromRGBO(117, 202, 233, 1),
      body: Stack(alignment: Alignment.topCenter, children: [
        Positioned(
          child: customText('Welcome to Scrypt!!', 28, FontWeight.w700,
              Colors.black, EdgeInsets.symmetric(vertical: 50)),
        ),
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
                                        return InkWell(
                                          onTap: (() {
                                            print(
                                                '======path=${snapshot.data?.reversed.toList()[index]?.absolute.path}');
                                            openPdfFile(snapshot.data!.reversed
                                                .toList()[index]!
                                                .absolute
                                                .path
                                                .substring(30));
                                          }),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: _fileViewIcon(
                                              snapshot,
                                              index,
                                            ),
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
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
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
    width: 100,
    decoration: BoxDecoration(
        color: Color.fromRGBO(97, 179, 209, 0.4),
        borderRadius: BorderRadius.all(Radius.circular(30))),
    child: Stack(alignment: Alignment.topCenter, children: [
      Icon(
        Icons.file_open,
        size: 45,
        color: Color.fromRGBO(55, 103, 121, 0.821),
      ),
      Positioned(
          top: -5,
          left: 60,
          child: PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Color.fromRGBO(55, 103, 121, 0.821),
                size: 20,
              ),
              color: Color.fromARGB(170, 255, 255, 255),
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
                      child: Text('Share')),
                  PopupMenuItem(
                      onTap: (() async {
                        await openPdfFile(snapshot.data?.reversed
                            .toList()[index]
                            ?.absolute
                            .path
                            .substring(30));
                      }),
                      child: Text('Open'))
                ];
              }))),
      Positioned(
        bottom: 15,
        child: Text(
          '${snapshot.data?.reversed.toList()[index]?.absolute.path.substring(30)}',
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
