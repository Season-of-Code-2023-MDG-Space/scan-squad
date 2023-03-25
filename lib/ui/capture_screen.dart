import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:scansquad/api/modal/pick_item.dart';
import 'package:scansquad/api/modal/process_image.dart';
import 'package:scansquad/asset/images.dart';
import 'package:scansquad/routes/routes.dart';
import 'package:scansquad/widgets/custom_widgets_class/customAppBar.dart';
import '../api/modal/generate_pdf.dart';
import '../widgets/styling_widgets.dart';

class CapturedImagesScreen extends StatefulWidget {
  const CapturedImagesScreen(
      {Key? key, required this.user, required this.uint8list0})
      : super(key: key);
  final Uint8List uint8list0;
  final User user;
  @override
  State<CapturedImagesScreen> createState() => _CapturedImagesScreenState();
}

class _CapturedImagesScreenState extends State<CapturedImagesScreen> {
  List<Uint8List> _listUint8List = [];
  late User _currentUser;
  @override
  void initState() {
    super.initState();

    _currentUser = widget.user;
    _listUint8List.add(widget.uint8list0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
          customIconButton(CommonIcons.clickMoreIcon, () async {
        final pickedFile = await pickImage();
        if (pickedFile != null) {
          final mImage = await ImageProcess().writeExifData(
            await pickedFile.readAsBytes(),
            userName: _currentUser.displayName!,
          );
          setState(() {
            _listUint8List.add(mImage);
          });
        }
      }, 48, 48),
      appBar: AppBar(
        elevation: 5,
        shadowColor: Color.fromARGB(236, 251, 250, 250),
        shape: CurveAppBar(),
        backgroundColor: const Color.fromRGBO(69, 177, 200, 1),
        title: const Text(
          "New File",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'MontSerrat'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: customIconButton(CommonIcons.saveFileIcon, () async {
              if (_listUint8List.isEmpty) {
                Fluttertoast.showToast(msg: 'Please capture atleast one image');
              } else {
                var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                );
                await convertToPdf(_listUint8List, result);
                Fluttertoast.showToast(msg: 'File saved in storage');
                Navigator.pop(context);
              }
            }, 36, 36),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: ReorderableGridView.builder(
            itemCount: _listUint8List.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 15),
            itemBuilder: ((context, index) {
              return GestureDetector(
                onHorizontalDragEnd: (endDetails) {
                  double? velocity = endDetails.primaryVelocity;
                  if (velocity! > 0) {
                    _listUint8List.removeAt(index);
                    setState(() {});
                  }
                },
                key: ValueKey(_listUint8List[index]),
                onTap: (() =>
                    goToPhotoViewPage(context, _listUint8List[index])),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: MemoryImage(
                            _listUint8List[index],
                          ),
                          fit: BoxFit.fitWidth)),
                ),
              );
            }),
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                final item = _listUint8List.removeAt(oldIndex);
                _listUint8List.insert(newIndex, item);
              });
            },
          )),
    );
  }
}

Widget _container(User _currentUser, List<Uint8List> _listUint8List, int index,
    void Function(void Function()) setState, BuildContext context) {
  return ReorderableGridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 15),
    itemBuilder: (BuildContext context, int index) {
      return InkWell(
        key: ValueKey(_listUint8List[0]),
        onTap: () async {
          final pickedFile = await pickImage();
          if (pickedFile != null) {
            final mImage = await ImageProcess().writeExifData(
              await pickedFile.readAsBytes(),
              userName: _currentUser.displayName!,
            );
            setState(() {
              _listUint8List.add(mImage);
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 184, 192, 196),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
              child: Icon(
            Icons.add,
            color: Color.fromARGB(255, 94, 94, 94),
          )),
        ),
      );
    },
    onReorder: (int oldIndex, int newIndex) {
      setState(() {
        final item = _listUint8List.removeAt(oldIndex);
        _listUint8List.insert(newIndex, item);
      });
    },
  );
}

Widget _buildPopupSavedDialog() {
  return AlertDialog(
    content: Text('Your file has been saved in storage'),
  );
}

Widget _buildPopupDialog(BuildContext context) {
  TextEditingController _fileNameTextController = TextEditingController();
  var fileName;
  return AlertDialog(
    title: Text('Enter a file name'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: _fileNameTextController,
          onSubmitted: ((value) {}),
        ),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          fileName = _fileNameTextController.text;
          Navigator.pop(context, fileName);
        },
        child: const Text('Submit'),
      ),
    ],
  );
}
