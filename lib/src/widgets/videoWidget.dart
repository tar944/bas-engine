import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class VideoWidget extends StatelessWidget {
  VideoWidget({
    Key? key,
    required this.path, required this.controller,
  }) : super(key: key);

  final String path;
  final MeeduPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AspectRatio(
          aspectRatio: 16 / 9,
          child: MeeduVideoPlayer(
            controller: controller,
          )),
    );
  }
}
