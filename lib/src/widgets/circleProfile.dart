import 'package:fluent_ui/fluent_ui.dart';

class CircleProfile extends StatelessWidget {
  CircleProfile(
      {Key? key,
      required this.imageUrl,
      required this.description,
      required this.size,
        this.onProfileCaller,})
      : super(key: key);

  final String imageUrl;
  final String description;
  final double size;
  ValueSetter<bool>? onProfileCaller;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: description,
      displayHorizontally: true,
      useMousePosition: false,
      style: const TooltipThemeData(preferBelow: true),
      child: IconButton(
        style: ButtonStyle(
          padding: ButtonState.all(const EdgeInsets.all(5))
        ),
        icon: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imageUrl), fit: BoxFit.cover),
            shape: BoxShape.circle,
          ),
        ),
        onPressed: ()=>onProfileCaller!(true),
      ),
    );
  }
}
