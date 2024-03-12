# diff_image

A Dart [Package](https://pub.dev/packages/diff_image2) to get the % difference between two images of the same width and height.

diff_image2 is a Dart version of [this](https://github.com/amorenew/diff_image2) with changes on visualization and , you guessed it, the language.

## Example

A simple usage example:

```dart
import 'package:diff_image2/diff_image.dart';
import 'package:image/image.dart';

final FIRST_IMAGE = 'https://seeklogo.com/images/F/flutter-logo-5086DD11C5-seeklogo.com.png';
final SECOND_IMAGE = 'https://seeklogo.com/images/A/android-western-logo-8F117A7F00-seeklogo.com.png';

void foo() async {
  try {
      var diff = await DiffImage.compareFromUrl(
        FIRST_IMAGE,
        SECOND_IMAGE,
      );
      print('The difference between images is: ${diff.value} %');
  } catch(e) {
      print(e);
  }
}

void goo(Image first, Image second) {
  try {
    var diff = DiffImage.compareFromMemory(
      first,
      second,
    );
    print('The difference between images is: ${diff.diffValue} %');
  } catch(e) {
    print(e);
  }
}

main() {
  foo();
  /*These can be obtained with any method*/
  Image first;
  Image second;
  // Here is posible to manipulate both images before passing them
  // to the function.
  goo(first, second);
}
```

A more detailed example can be found [here](https://github.com/amorenew/diff_image2/tree/main/example)

## Features

1. Currently there is support for comparing images fetched from urls and from memory or storage.
2. The `compareFromUrl` definition is:
```dart
  static Future<DiffImgResult> compareFromUrl(
    dynamic firstImageSrc,
    dynamic secondImageSrc, {
    bool asPercentage = true,
    bool ignoreAlpha = true,
  }) async{...}
```
3. And the `compareFromMemory` definition is:
```dart
  static DiffImgResult compareFromMemory(
    Image firstImage,
    Image secondImage, {
    bool asPercentage = true,
    bool ignoreAlpha = true,
  }) {...}
```
4. And the `compareFromFile` definition is:
```dart
  static Future<DiffImgResult> compareFromFile(
    File firstImage,
    File secondImage, {
    bool asPercentage = true,
    bool ignoreAlpha = true,
  }) {...}
```
where:
+ `ignoreAlpha` allows to decide whether to take alpha from RGBA into account for the calculation
+ `asPercentage` set the format of the output (as percentage or between 0-1)

Both methods return an `DiffImgResult`, a model which contains two elements: An image showing the differences between both images and the numeric value representing the difference (as percentage or not).

5. A function called `saveImage` which saves a png showing the differences between `firstImage` and `secondImage` (currently not available on Dart Web).
```dart
  static Future<File> saveImage({
    required Image image,
    required String name,
    String directory = '',
  }) {...}
```

## Sample Results
### First Image
![flutter_logo](https://seeklogo.com/images/F/flutter-logo-5086DD11C5-seeklogo.com.png "Flutter Logo")
### Second Image
![android_logo](https://seeklogo.com/images/A/android-western-logo-8F117A7F00-seeklogo.com.png "Android Logo")
### Difference Percentage
**With Alpha    :** 35.67169421487167 %

**Without Alpha :** 34.83905183744361 %
### Difference Image
![DiffImg](https://raw.githubusercontent.com/amorenew/diff_image2/main/DiffImage.png "DiffImg")


## Suggestions and bugs

Please file feature requests, suggestions and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/amorenew/diff_image2/issues
