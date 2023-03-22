import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scansquad/api/modal/load_file.dart';
import 'package:scansquad/asset/images.dart';
import 'package:scansquad/widgets/styling_widgets.dart';
import '../../api/google_services/google_drive.dart';
import '../../routes/common_functions.dart';
import '../../widgets/custom_widgets_class/customAppBar.dart';

class SavedFiles extends StatefulWidget {
  const SavedFiles({super.key});

  @override
  State<SavedFiles> createState() => _SavedFilesState();
}

class _SavedFilesState extends State<SavedFiles> {
  int len = -1;
  bool isProcessing = false;
  @override
  void initState() {
    getDir().then(
      (value) {
        len = value.length;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 5,
          shadowColor: Color.fromARGB(236, 251, 250, 250),
          shape: CurveAppBar(),
          backgroundColor: const Color.fromRGBO(69, 177, 200, 1),
          title: const Text(
            "Local Files",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'MontSerrat'),
          ),
        ),
        body: (len == 0)
            ? emptyFiles()
            : FutureBuilder<List<FileSystemEntity?>>(
                future: getDir(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return isProcessing
                        ? const SpinKitFadingCube(
                            color: const Color.fromRGBO(69, 177, 200, 1),
                            size: 40.0,
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 30),
                            child: ListView.builder(
                                itemCount: snapshot.data?.length,
                                itemBuilder: ((context, index) {
                                  final item = snapshot.data!.reversed
                                      .toList()[index]!
                                      .absolute
                                      .path
                                      .substring(30);
                                  return Dismissible(
                                    key: Key(item),
                                    onDismissed: (direction) {
                                      snapshot.data!.reversed
                                          .toList()[index]
                                          ?.deleteSync();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'File deleted from storage')));
                                    },
                                    child: Material(
                                      elevation: 25,
                                      shape: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      shadowColor:
                                          Color.fromARGB(72, 251, 250, 250),
                                      child: InkWell(
                                        onTap: (() {
                                          openPdfFile(snapshot.data!.reversed
                                              .toList()[index]!
                                              .absolute
                                              .path
                                              .substring(30));
                                        }),
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          height: 50,
                                          child: ListTile(
                                            leading: Image.asset(
                                              CommonIcons.fileIcon,
                                              height: 45,
                                            ),
                                            title: Text(snapshot.data!.reversed
                                                .toList()[index]!
                                                .absolute
                                                .path
                                                .substring(30)),
                                            trailing: Container(
                                              width: 110,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  customIconButton(
                                                      CommonIcons.uploadIcon,
                                                      () async {
                                                    var result =
                                                        await showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          _buildConfirmationPopupDialog(
                                                              context),
                                                    );
                                                    if (result == true) {
                                                      setState(() {
                                                        isProcessing = true;
                                                      });
                                                      if (await GoogleDriveServices()
                                                          .uploadToDrive(File(
                                                              snapshot.data!
                                                                  .reversed
                                                                  .toList()[
                                                                      index]!
                                                                  .absolute
                                                                  .path))) {
                                                        setState(() {
                                                          isProcessing = false;
                                                        });
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Upload Sucessful');
                                                      } else {
                                                        setState(() {
                                                          isProcessing = false;
                                                        });
                                                      }
                                                    } else {
                                                      return;
                                                    }
                                                  }, 25, 25),
                                                  customIconButton(
                                                      CommonIcons.fshareIcon,
                                                      (() {
                                                    sharePDF(snapshot
                                                        .data?.reversed
                                                        .toList()[index]
                                                        ?.absolute
                                                        .path);
                                                  }), 25, 25),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                })));
                  } else {
                    return const Center(
                        child: Text('You have not created any file'));
                  }
                }));
  }
}

Widget _buildConfirmationPopupDialog(BuildContext context) {
  bool isYes = false;
  return AlertDialog(
    title:
        Text('Are you sure you want to upload this file to your Google Drive?'),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          isYes = true;
          Navigator.pop(context, isYes);
        },
        child: const Text('Yes'),
      ),
      TextButton(
        onPressed: () {
          isYes = false;
          Navigator.pop(context, isYes);
        },
        child: const Text('No'),
      ),
    ],
  );
}

Widget emptyFiles() {
  return const Center(child: Text('You have not created any file'));
}
