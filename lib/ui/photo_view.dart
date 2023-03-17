import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FullImageView extends StatefulWidget {
  FullImageView({super.key, required this.viewLargeImage});
  Uint8List viewLargeImage;
  @override
  State<FullImageView> createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  late Uint8List imageToShow;
  @override
  void initState() {
    imageToShow = widget.viewLargeImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: InteractiveViewer(
            panEnabled: false,
            minScale: 1,
            maxScale: 3,
            child: Image.memory(
              imageToShow,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
