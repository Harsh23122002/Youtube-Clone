import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtubeclone/pages/login-page/login.dart';
import 'package:youtubeclone/pages/splash-screen/splash_screen.dart';
import 'package:youtubeclone/pages/videos-page/videos_page.dart';
import 'package:youtubeclone/utils/youtube_api_service.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: SplashScreen(),
            ),
          );
        } else if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginPage();
        }
      }),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isScreenLoading = true;
  late List channels;
  void loadData() async {
    await Provider.of<ApiServiceProvider>(context, listen: false)
        .fetchAllChannelData();
    if (mounted) {
      channels = Provider.of<ApiServiceProvider>(context, listen: false)
          .getAllChannelData;
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        isScreenLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (isScreenLoading) {
      return const Scaffold(
        body: Center(
          child: SplashScreen(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Youtube"),
        ),
        body: SafeArea(
          child: Center(
            child: GridView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: channels.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 3.0,
                  mainAxisSpacing: 4.0,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ChannelThumbnail(
                      channelData: channels[index],
                    ),
                  );
                }),
          ),
          // GridView.builder(gridDelegate: gridDelegate, itemBuilder: (context,index) => ),
        ),
      );
    }
  }
}

class ChannelThumbnail extends StatelessWidget {
  final Map channelData;

  const ChannelThumbnail({
    required this.channelData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: ((context) => VideosPage(
                  channelName: channelData['snippet']['title'],
                  contentData: (channelData['contentDetails']),
                ))));
      },
      child: Column(children: [
        CircleAvatar(
          radius: 43,
          backgroundImage: NetworkImage(
              channelData['snippet']['thumbnails']['medium']['url']),
        ),
        Flexible(child: Text((channelData['snippet']['title']).toString()))
      ]),
    );
  }
}
