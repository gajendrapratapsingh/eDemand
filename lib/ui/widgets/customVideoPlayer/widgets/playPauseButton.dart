import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayPauseButtonContainer extends StatefulWidget {
  final AnimationController controlsAnimationController;

  final VideoPlayerController? videoPlayerController;

  const PlayPauseButtonContainer(
      {Key? key,
        this.videoPlayerController,
        required this.controlsAnimationController,})
      : super(key: key);

  @override
  State<PlayPauseButtonContainer> createState() =>
      _PlayPauseButtonContainerState();
}

class _PlayPauseButtonContainerState extends State<PlayPauseButtonContainer> {
  bool _isPlaying = false;
  bool _isCompleted = false;

  void listener() {
    _isPlaying = widget.videoPlayerController!.value.isPlaying;

    if (widget.videoPlayerController!.value.position.inSeconds != 0) {
      _isCompleted = widget.videoPlayerController!.value.position.inSeconds ==
          widget.videoPlayerController!.value.duration.inSeconds;

    }

    setState(() {});
  }

  @override
  void initState() {
    widget.videoPlayerController?.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.videoPlayerController?.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        iconSize: 40,
        color: Theme.of(context).scaffoldBackgroundColor,
        onPressed: () async {
          //if control menu is not opened then open the menu
          if (!widget.controlsAnimationController.isCompleted) {
            widget.controlsAnimationController.forward();
            return;
          }

          if (_isCompleted) {
            widget.videoPlayerController!.seekTo(Duration.zero);
            widget.videoPlayerController!.play();
            return;

          }

          if (_isPlaying) { widget.videoPlayerController!.pause();
          await Future.delayed(const Duration(milliseconds: 500));
          widget.controlsAnimationController.reverse();
          } else {widget.videoPlayerController!.play();
          await Future.delayed(const Duration(milliseconds: 500));
          widget.controlsAnimationController.reverse();
          }
        },
        icon: _isCompleted
            ? const Icon(Icons.restart_alt)
            : _isPlaying
            ? const Icon(
          Icons.pause,
        )
            : const Icon(Icons.play_arrow),
      ),
    );
  }
}
