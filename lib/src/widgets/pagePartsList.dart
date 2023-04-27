import 'package:fluent_ui/fluent_ui.dart';

import '../../assets/values/textStyle.dart';
import '../items/pageItem.dart';

class PagePartsList extends StatelessWidget {
  const PagePartsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> itemList = [1,1,1,1,1,1,1,];
    return Padding(
      padding: const EdgeInsets.all(10),

      child: Container(
        width: double.infinity,
        height: 655,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),

        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Page Parts : ',style: TextSystem.textL(Colors.white),),
                  Text('${itemList.length} Part',style: TextSystem.textL(Colors.orange),),
                ],
              ),

              SizedBox(height: 10,),


              GridView(
                controller:
                ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate:
                const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 3 / 2.5,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                children: itemList
                    .map((item) => PageItem())
                    .toList(),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
