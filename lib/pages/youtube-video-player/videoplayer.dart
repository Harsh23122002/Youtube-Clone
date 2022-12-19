import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final String videoId;
  final String channelName;
  final String videoTitle;

  const VideoPlayer(
      {required this.channelName,
      required this.videoTitle,
      required this.videoId,
      Key? key})
      : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController videoController;

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    videoController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    videoController = YoutubePlayerController(initialVideoId: widget.videoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: videoController,
            ),
            builder: (context, player) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  player,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.videoTitle,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.channelName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
