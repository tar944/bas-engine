import 'dart:math';

import 'package:bas_dataset_generator_engine/src/models/softwareModel.dart';
import 'package:bas_dataset_generator_engine/src/models/videoModel.dart';


class FakeData {
  var softwareTitle = [
    "Google Chrome",
    "VSCode",
    "Word",
    "Excel",
    "Access",
    "Powerpoint",
    "PhotoShop",
    "Acrobat",
    "AfterEffect",
    "XD",
    "Lightroom",
  ];

  var comTitle = [
    "Tesla",
    "Microsoft",
    "Apple",
    "Telegram",
    "Adobe",
    "Google",
    "Meta",
    "Catia",
    "Cisco",
    "Nokia",
  ];

  var logo = [
    "https://www.freepnglogos.com/uploads/mercedes-logo-png/mercedes-logo-png-mercedes-benz-logo-vector-icons-and-png-17.png",
    "data:image/jpeg;base64,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",
    "https://www.freepnglogos.com/uploads/huawei-logo-png/huawei-logo-9.png",
    "https://pngimg.com/uploads/amazon/amazon_PNG18.png",
    "https://a.slack-edge.com/80588/marketing/img/meta/slack_hash_256.png",
    "https://www.freeiconspng.com/thumbs/honda-logo-png/honda-icon-13.png",
    "https://i.stack.imgur.com/WfoqA.png",
    "data:image/png;base64,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",
    "https://cdn.iconscout.com/icon/free/png-256/adobe-252-722666.png?f=webp&w=256",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYkuvEg8B8NHNNgOFxKfX_TkU1vJqZSIZu9v3UJJrk2YpPBJCueNQAkkXLFB4WmYSHfiU&usqp=CAU",
  ];

  var description = [
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quisque sagittis purus sit amet volutpat consequat mauris nunc. At tempor commodo ullamcorper a lacus vestibulum sed arcu.",
    "Dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Libero volutpat sed cras ornare arcu dui vivamus arcu. Interdum posuere lorem ipsum dolor sit amet consectetur adipiscing elit.",
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nibh tellus molestie nunc non blandit massa enim. Maecenas ultricies mi eget mauris pharetra.",
    "Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed euismod nisi porta lorem. Mi proin sed libero enim.",
    "Elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sit amet nisl purus in. Viverra maecenas accumsan lacus vel facilisis volutpat.",
    "Generate Lorem Ipsum placeholder text. Select the number of characters, words, sentences or paragraphs, and hit generate!",
    "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sollicitudin nibh sit amet commodo nulla facilisi nullam vehicula. Penatibus et magnis dis parturient montes nascetur ridiculus mus.",
    "Incididunt ut labore et dolore magna aliqua. Sem nulla pharetra diam sit amet nisl suscipit adipiscing. Amet aliquam id diam maecenas ultricies.",
    "Amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Venenatis a condimentum vitae sapien pellentesque habitant. Faucibus et molestie ac feugiat sed lectus vestibulum mattis.",
    "Eiusmod tempor incididunt ut labore et dolore magna aliqua. At ultrices mi tempus imperdiet nulla malesuada pellentesque. Etiam erat velit scelerisque in dictum non consectetur a."
  ];

  var appIcon = [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Adobe_Photoshop_Mobile_icon.svg/1200px-Adobe_Photoshop_Mobile_icon.svg.png",
    "https://1000logos.net/wp-content/uploads/2020/06/illustrator-Logo-2013.png",
    "https://www.pngitem.com/pimgs/m/33-339973_new-microsoft-word-icon-microsoft-word-icon-2019.png",
    "https://toppng.com/uploads/preview/microsoft-powerpoint-icon-microsoft-powerpoint-mac-icon-11553457699j3vw0lt5mb.png",
    "https://icons-for-free.com/iconfiles/png/512/js+library+long+shadow+nodejs+web+icon-1320184850167478047.png",
    "data:image/png;base64,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"
  ];

  List<SoftwareModel> generateSoftware() {
    List<SoftwareModel> list = [];
    for (var i = 0; i < 12; i++) {
      list.add(SoftwareModel(
          'id',
          softwareTitle[Random().nextInt(softwareTitle.length - 1)],
          'companyId',
          comTitle[Random().nextInt(comTitle.length-1)],
          description[Random().nextInt(description.length-1)],
          appIcon[Random().nextInt(appIcon.length-1)],
          'companyLogo'));
    }
    return list;
  }
  List<VideoModel> generateVideos() {
    List<VideoModel> list = [];
    // for (var i = 0; i < 12; i++) {
    //   list.add(VideoModel(
    //       'id',
    //       softwareTitle[Random().nextInt(softwareTitle.length - 1)],
    //       'companyId',
    //       comTitle[Random().nextInt(comTitle.length-1)],
    //       description[Random().nextInt(description.length-1)],
    //       appIcon[Random().nextInt(appIcon.length-1)],
    //       'companyLogo'));
    // }
    return list;
  }

}
