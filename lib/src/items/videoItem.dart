import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';

import '../../assets/values/dimens.dart';
import '../../assets/values/textStyle.dart';

class VideoItem extends StatelessWidget {
  const VideoItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  Radius.circular(Dimens.dialogCornerRadius)),
              color: Colors.grey[170],
              border: Border.all(color: Colors.magenta, width: 1.5),
            image: DecorationImage(
              image: AssetImage(
                  'lib/assets/testImages/testImg1.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[170].withOpacity(0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.play,color: Colors.white,size: 25,),
                      SizedBox(width: 5,),
                      Text('3:45',style: TextSystem.textM(Colors.white),)
                    ],
                  )),

              Spacer(),
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10),),
                  color: Colors.grey[170].withOpacity(0.7)
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {},
                          icon: Text('Videos',style: TextSystem.textM(Colors.white),),
                        )),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {},
                          icon: Text('Main pages',style: TextSystem.textM(Colors.blue.lighter),),
                        ))
                  ],
                ),
              ),
            ],
          ),
        );
  }
}
