import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';

import '../../assets/values/dimens.dart';

class PageItem extends StatelessWidget {
  const PageItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(Dimens.dialogCornerRadius)),
        color: Colors.grey[170],
        border: Border.all(color: Colors.magenta, width: 1.5),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 12,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                image: DecorationImage(
                  image: AssetImage('lib/assets/testImages/testImg3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unlabeled Pages',
                      style: TextSystem.textS(Colors.white),
                    ),
                    Text('lorem lksdmc as;l slxca ksd klds lskdc lsdc ldsk',style: TextSystem.textXs(Colors.white),textAlign: TextAlign.justify,),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blue,
                          ),
                          child: Icon(CupertinoIcons.pen,color: Colors.white,size: 15,),

                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.red,
                          ),
                          child: Icon(CupertinoIcons.delete,color: Colors.white,size: 15,),

                        ),
                      ],
                    )
                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
