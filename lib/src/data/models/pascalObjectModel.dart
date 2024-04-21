import 'package:xml/xml.dart';

class PascalObjectModel{
  String? name,pose="Unspecified";
  int truncated=0,difficult=0,occluded=0;
  int? xmin,xmax,ymin,ymax;

  PascalObjectModel(
    this.name,
    this.xmin,
    this.xmax,
    this.ymin,
    this.ymax
  );

  PascalObjectModel.fromXML(XmlElement xml) {
    name = xml.findElements("name").single.innerText;
    pose = xml.findElements("pose").single.innerText;
    truncated = int.parse(xml.findElements("truncated").single.innerText);
    difficult = int.parse(xml.findElements("difficult").single.innerText);
    occluded = int.parse(xml.findElements("occluded").single.innerText);
    xmin = int.parse(xml.findElements("xmin").single.innerText);
    xmax = int.parse(xml.findElements("xmax").single.innerText);
    ymin = int.parse(xml.findElements("ymin").single.innerText);
    ymax = int.parse(xml.findElements("ymax").single.innerText);
  }

  XmlBuilder toXML() {
    final builder = XmlBuilder();
    builder.element('object', nest: () {
      builder.element('name',nest: name);
      builder.element('pose',nest:pose);
      builder.element('truncated',nest: truncated);
      builder.element('difficult',nest: difficult);
      builder.element('occluded',nest: occluded);
      builder.element('bndbox',nest:(){
        builder.element('xmin',nest: xmin);
        builder.element('xmax',nest: xmax);
        builder.element('ymin',nest: ymin);
        builder.element('ymax', nest: ymax);
      });
    });
    return builder;
  }
}