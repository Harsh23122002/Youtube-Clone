import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:youtubeclone/utils/channelid.dart';

const String apiKey = "AIzaSyBeNjEUiZztZLFlWCttB6SokZetkVMd_Rc";

const channelUrl =
    'https://www.googleapis.com/youtube/v3/channels?key=$apiKey&part=contentDetails,id,snippet,status&id=$ids';

const playlisturl =
    'https://www.googleapis.com/youtube/v3/playlistItems?key=$apiKey&maxResults=20&part=contentDetails,id,snippet,status&playlistId=';

void kPrintLog(String screenName, dynamic data) {
  log('$data', name: screenName, time: DateTime.now());
}

class ApiServiceProvider with ChangeNotifier {
  dynamic _allChannelData;
  dynamic _channelVideos;

  dynamic get getAllChannelData {
    return _allChannelData;
  }

  dynamic get getChannelVideos {
    return _channelVideos;
  }

  Future<void> fetchAllChannelData() async {
    final response = await http.get(Uri.parse(channelUrl));

    _allChannelData = json.decode(response.body)['items'];

    kPrintLog("All-Channels-Data", _allChannelData);

    notifyListeners();
  }

  Future<void> fetchChannelUploads(String playlistId) async {
    final response = await http.get(Uri.parse("$playlisturl$playlistId"));
    _channelVideos = json.decode(response.body)['items'];

    kPrintLog("Channel-Videos", _channelVideos);
    notifyListeners();
  }
}
