import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:xml/xml.dart';

class PascalVOCModel{
  String? filename,path;
  int? width,height;
  int depth=3;
  List<PascalObjectModel> objects=[];

  PascalVOCModel(
      this.filename,
      this.path,
      this.width,
      this.height,
      this.depth,
      this.objects);


  PascalVOCModel.fromXML(XmlDocument xml) {
    filename = xml.findElements("filename").single.innerText;
    path = xml.findElements("path").single.innerText;
    var size = xml.findElements("size").single;
    width=int.parse(size.findElements("width").single.innerText);
    height=int.parse(size.findElements("height").single.innerText);
    depth= int.parse(size.findElements("depth").single.innerText);
    var allObjects = xml.findAllElements("object");
    if (allObjects.isNotEmpty) {
      allObjects.forEach((element) {
        objects.add(PascalObjectModel.fromXML(element));
      });
    }
  }

  XmlDocument toXML() {
    final builder = XmlBuilder();
    builder.element('annotation', nest: () {
      builder.element('folder');
      builder.element('filename',nest:filename);
      builder.element('path',nest: path);
      builder.element('source',nest:(){
        builder.element('database',nest: Strings.appName);
      });
      builder.element('size',nest:(){
        builder.element('width',nest: width);
        builder.element('height',nest: height);
        builder.element('depth',nest: depth);
      });
      builder.element('segmented',nest: 0);
      for (var element in objects) {
        element.toXML();
      }
    });
    return builder.buildDocument();
  }
}