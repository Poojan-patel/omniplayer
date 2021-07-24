// @dart=2.9
import 'dart:io';
//import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:video_player_in_flutter/main_route.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

//https://github.com/JohannesMilke/video_example
//import 'package:youtube_explode_dart/src/youtube_explode_base.dart';

Future<void> main() async {
  String path = '/data/user/0/com.example.video_player_in_flutter/app_flutter';
  runApp(MainRoute(path));
  //String fileName = await getVideo(path);
}

Future<String> getVideo(String path) async {
  var yt = YoutubeExplode();

  //print("Waiting to fetch Video Instance");

  //Video video = await yt.videos.get('ZSt9tm3RoUU');

  var manifest = await yt.videos.streamsClient.getManifest('ZSt9tm3RoUU');
  //print("fetched Video Instance");
  var streamInfo = manifest.muxed.sortByBitrate();

  //print(path);
  var stream = yt.videos.streamsClient.get(streamInfo[0]);
  var file = File('$path/videodata.mp4');

  var fileStream = file.openWrite();
  //print("Download Started");
  // // Pipe all the content of the stream into the file.
  await stream.pipe(fileStream);
  //print("Download Ended");
  // // Close the file.
  await fileStream.flush();
  await fileStream.close();

  //print(streamInfo);
  //print('Title: ');

  // Close the YoutubeExplode's http client.
  yt.close();

  return '$path/videodata.mp4';
}
