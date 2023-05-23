import 'package:flython/flython.dart';
//py -m pip install opencv-python
class PythonHelper extends Flython {

  Future<dynamic> generateScreenShoots(
      String inputFile,
      String outputDirPath,
      ) async {
    initialize("py", "./lib/src/python/findFrames.py", true);
    var command = {
      "input": inputFile,
      "outputPath": outputDirPath,
    };
    final result = await runCommand(command);
    finalize();
    return result;
  }
}