import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
//import 'package:video_player_in_flutter/main.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class NetworkPlayer extends StatefulWidget {
  late TextEditingController textController;
  String url = "";
  String path;

  NetworkPlayer(this.path, {Key? key}) : super(key: key) {
    textController = TextEditingController(
        text: 'https://www.youtube.com/watch?v=OBF4kZS9baw');
  }

  @override
  _NetworkPlayerState createState() => _NetworkPlayerState();
}

class _NetworkPlayerState extends State<NetworkPlayer> {
  late YoutubePlayerController controller;
  //bool isValid = false;
  String videoId = "Dpp1sIL1m5Q";
  String savedLocation = "Move Your Video After Downloading";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          youtubePlayerCustom(),
          urlInput(context),
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(top: 20),
              child: Text(savedLocation,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )))
        ],
      ),
    );
  }

  Widget youtubePlayerCustom() {
    try {
      print(widget.url);
      videoId = YoutubePlayer.convertUrlToId(widget.url);
      setState(() {
        controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
      });

      return YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        onReady: () {
          controller.addListener(() {});
        },
      );
    } catch (e) {
      videoId = "";
      return Container(
          height: 150,
          alignment: Alignment.center,
          child: Center(child: Text("Some Error Occured")));
    }
  }

  Widget urlInput(BuildContext context) {
    final snackBar = SnackBar(content: Text('Invalid URL'));

    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextField(
                controller: widget.textController,
                keyboardType: TextInputType.url,
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                    prefixText: "Youtube URL:",
                    prefixIcon: Icon(Icons.youtube_searched_for_rounded))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    String val = widget.textController.text.trim();
                    if (Uri.parse(Uri.encodeFull(val)).isAbsolute == false) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                    setState(() {
                      widget.url = val;
                    });
                  },
                  child: Icon(Icons.play_arrow_outlined)),
              ElevatedButton(
                  onPressed: () async {
                    if (videoId != "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Download Started')));

                      getApplicationDocumentsDirectory().then((path) {
                        //print(path);

                        getVideo(path.path, videoId).then((value) {
                          if (path == 'Some Error Occured') {
                            setState(() {
                              savedLocation = "Failed to Download";
                            });
                            return;
                          }
                          //print("Video Saved At: $value");
                          setState(() {
                            savedLocation = "Video Saved At: $value";
                          });
                        });
                      });
                    }
                  },
                  child: Icon(Icons.download)),
            ],
          )
        ],
      ),
    );
  }

  Future<String> getVideo(String path, String videoId) async {
    var yt = YoutubeExplode();
    //print(videoId);
    //print("Waiting to fetch Video Instance");

    // Video video =
    //     await yt.videos.get('https://www.youtube.com/watch?v=' + videoId);
    try {
      var manifest = await yt.videos.streamsClient.getManifest(videoId);
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
      //print('Title: videodata');

      // Close the YoutubeExplode's http client.
      yt.close();
    } catch (e) {
      return 'Some Error Occured';
    }

    return '$path/videodata.mp4';
  }
}
