import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_in_flutter/widgets/custom_video_player.dart';

class StaticPlayer extends StatefulWidget {
  final String asset;
  const StaticPlayer(this.asset, {Key? key}) : super(key: key);

  @override
  _StaticPlayerState createState() => _StaticPlayerState();
}

class _StaticPlayerState extends State<StaticPlayer> {
  late final String asset;
  late VideoPlayerController controller;
  bool isController = false;

  @override
  void initState() {
    asset = widget.asset;
    super.initState();
    // controller = VideoPlayerController.asset((asset))
    //   ..addListener(() {
    //     setState(() {
    //       isController = true;
    //     });
    //   })
    //   ..setLooping(false)
    //   ..initialize().then((_) {
    //     return controller.pause();
    //   });
  }

  @override
  void dispose() {
    controller.dispose();
    // Hey

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print(controller.value.isInitialized);
    return ListView(
      children: [
        isController
            ? VideoPlayerWidget(controller, isController)
            : Container(),
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [accessInternalFile()])
        // if (isController && controller.value.isInitialized)
        //   InkWell(child: Icon(Icons.volume_mute))
      ],
    );
  }

  Widget accessInternalFile() {
    // return Container(
    //     width: 100, height: 100, color: Colors.black, child: Icon(Icons.pause));
    return Container(
      width: 200,
      margin: EdgeInsets.only(top: 20),
      child: ElevatedButton(
          onPressed: () async {
            dynamic file = await pickVideoFile();
            if (file != null && !file.existsSync()) {
              //print("Not in Existance");
              return;
            }
            controller = VideoPlayerController.file(file)
              ..addListener(() {
                setState(() {
                  isController = true;
                });
              })
              ..setLooping(false)
              ..initialize().then((_) {
                controller.pause();
              });
          },
          child: Text("Access Local Storage")),
    );
  }

  dynamic pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null) return null;
    return File(result.files.single.path);
    // return File(
    //     '/data/user/0/com.example.video_player_in_flutter/app_flutter/videodata.mp4');
  }
}
