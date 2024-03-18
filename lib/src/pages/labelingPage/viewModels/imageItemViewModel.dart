import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ImageItemViewModel extends ViewModel {

  final ImageGroupModel group;
  final ValueSetter<String>? onActionCaller;
  int allImagesNumber =0;

  ImageItemViewModel(this.group, this.onActionCaller);
}