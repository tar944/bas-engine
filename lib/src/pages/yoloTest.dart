import 'dart:io';
import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';


class YoloTest extends StatefulWidget {
  YoloTest({Key? key}) : super(key: key);

  @override
  State<YoloTest> createState() => _YoloTest();
}

class _YoloTest extends State<YoloTest> {
  late List<Map<String, dynamic>> yoloResults;
  File? imageFile;
  int imageHeight = 1;
  int imageWidth = 1;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const ScaffoldPage(
        content: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        imageFile != null ? Image.file(imageFile!) : const SizedBox(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ],
          ),
        ),
      ],
    );
  }

}
