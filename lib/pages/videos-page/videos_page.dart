import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:youtubeclone/pages/youtube-video-player/videoplayer.dart';
import 'package:youtubeclone/utils/youtube_api_service.dart';

class VideosPage extends StatefulWidget {
  final String channelName;
  final Map contentData;

  const VideosPage(
      {required this.channelName, required this.contentData, Key? key})
      : super(key: key);

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  bool isLoading = true;
  late String playlistId;

  dynamic videos;

  void loadData() async {
    playlistId = widget.contentData['relatedPlaylists']['uploads'].toString();
    await Provider.of<ApiServiceProvider>(context)
        .fetchChannelUploads(playlistId);

    if (mounted) {
      videos = Provider.of<ApiServiceProvider>(context, listen: false)
          .getChannelVideos;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // loadData();
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.channelName.toString()),
        ),
        body: ListView.builder(
          itemCount: videos.length,
          itemBuilder: ((context, index) {
            return VideoCard(
                url: (videos[index]['snippet']['thumbnails']['high']['url'])
                    .toString(),
                title: (videos[index]['snippet']['title']).toString(),
                channelTitle:
                    (videos[index]['snippet']['channelTitle']).toString(),
                videoId:
                    (videos[index]['contentDetails']['videoId']).toString());
          }),
        ),
      );
    }
  }
}

class VideoCard extends StatelessWidget {
  String url;
  String title;
  String channelTitle;
  String videoId;

  VideoCard(
      {required this.videoId,
      required this.channelTitle,
      required this.url,
      required this.title,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VideoPlayer(
              videoTitle: title,
              channelName: channelTitle,
              videoId: videoId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Card(
          child: SizedBox(
            height: 400,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              // textBaseline: TextBaseline.alphabetic,
              children: [
                Image.network(
                  url,
                  height: 350,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    overflow: TextOverflow.clip,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
