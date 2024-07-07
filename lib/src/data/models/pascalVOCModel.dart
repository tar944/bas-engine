import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:xml/xml.dart';

class PascalVOCModel{
  String? filename,path,objUUID,grpUUID;
  int? width,height;
  int depth=3;
  List<PascalObjectModel> objects=[];

  PascalVOCModel(
      this.objUUID,
      this.grpUUID,
      this.filename,
      this.path,
      this.width,
      this.height);

  PascalVOCModel.fromXML(XmlDocument xml) {
    filename = xml.findElements("filename").single.innerText;
    path = xml.findElements("path").single.innerText;
    var size = xml.findElements("size").single;
    width=int.parse(size.findElements("width").single.innerText);
    height=int.parse(size.findElements("height").single.innerText);
    depth= int.parse(size.findElements("depth").single.innerText);
    var allObjects = xml.findAllElements("object");
    if (allObjects.isNotEmpty) {
      for (var obj in allObjects) {
        objects.add(PascalObjectModel.fromXML(obj));
      }
    }
  }

  XmlDocument toXML() {
    final builder = XmlBuilder();
    builder.element('annotation', nest: () {
      builder.element('folder',nest: "");
      builder.element('filename',nest:filename);
      builder.element('path',nest: filename);
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
        builder.element('object', nest:() {
          builder.element('name',nest: element.exportName);
          builder.element('pose',nest:element.pose);
          builder.element('truncated',nest: element.truncated);
          builder.element('difficult',nest: element.difficult);
          builder.element('occluded',nest: element.occluded);
          builder.element('bndbox',nest:(){
            builder.element('xmin',nest: element.xmin);
            builder.element('xmax',nest: element.xmax);
            builder.element('ymin',nest: element.ymin);
            builder.element('ymax', nest: element.ymax);
          });
        });
      }
    });
    return builder.buildDocument();
  }
}