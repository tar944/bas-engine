import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:pmvvm/pmvvm.dart';

class NavigationRowViewModel extends ViewModel {

  List<NavModel> allNavs;
  NavigationRowViewModel(this.allNavs);
}