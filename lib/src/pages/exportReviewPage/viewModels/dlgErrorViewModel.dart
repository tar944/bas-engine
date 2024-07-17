import 'package:bas_dataset_generator_engine/src/data/models/pascalVOCModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class DlgErrorViewModel extends ViewModel {

  final List<String> errors;


  DlgErrorViewModel(this.errors);

  void onCloseClicked() {
    Navigator.pop(context);
  }

}