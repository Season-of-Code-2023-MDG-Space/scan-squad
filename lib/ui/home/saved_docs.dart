import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scansquad/api/modal/load_file.dart';
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
          shape: CurveAppBar(),
          backgroundColor: const Color.fromRGBO(38, 126, 157, 1),
          title: const Text(
            "Scrypt",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
          ),
        ),
        body: FutureBuilder<List<FileSystemEntity?>>(
            future: getDir(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data != null) {
                return Container(
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: ((context, index) {
                          return ListTile(
                            leading: Icon(Icons.file_copy),
                            title: Text(snapshot.data!.reversed
                                .toList()[index]!
                                .absolute
                                .path
                                .substring(30)),
                            trailing: IconButton(
                                onPressed: (() {
                                  sharePDF(snapshot.data?.reversed
                                      .toList()[index]
                                      ?.absolute
                                      .path);
                                }),
                                icon: Icon(Icons.share)),
                          );
                        })));
              } else {
                return const Center(
                    child: Text('You have not created any file'));
              }
            }));
  }
}
