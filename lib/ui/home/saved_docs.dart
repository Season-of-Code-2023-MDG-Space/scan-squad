import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scansquad/api/modal/load_file.dart';
import 'package:scansquad/asset/images.dart';
import 'package:scansquad/widgets/styling_widgets.dart';
import '../../routes/common_functions.dart';
import '../../widgets/custom_widgets_class/customAppBar.dart';

class SavedFiles extends StatefulWidget {
  const SavedFiles({super.key});

  @override
  State<SavedFiles> createState() => _SavedFilesState();
}

class _SavedFilesState extends State<SavedFiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          shape: CurveAppBar(),
          backgroundColor: const Color.fromRGBO(69, 177, 200, 1),
          title: const Text(
            "My Files",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'MontSerrat'),
          ),
        ),
        body: FutureBuilder<List<FileSystemEntity?>>(
            future: getDir(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('File deleted from storage')));
                            },
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
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    customIconButton(CommonIcons.uploadIcon,
                                        (() {}), 25, 25),
                                    customIconButton(CommonIcons.fshareIcon,
                                        (() {
                                      sharePDF(snapshot.data?.reversed
                                          .toList()[index]
                                          ?.absolute
                                          .path);
                                    }), 25, 25),
                                  ],
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
