import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_in_flutter/widgets/overlay_controller.dart';

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isController;
  const VideoPlayerWidget(this.controller, this.isController, {Key? key})
      : super(key: key);

  Widget buildVideo() {
    //await controller.setPlaybackSpeed(4);
    return Stack(children: [
      buildVideoPlayer(),
      Positioned.fill(child: OverlayController(controller))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ((controller.value.isInitialized)
        ? Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                buildVideo(),
                videoDetails(),
                ButtonController(controller),
              ],
            ))
        : Container(
            height: 200, child: Center(child: CircularProgressIndicator())));
  }

  Widget buildVideoPlayer() {
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller));
  }

  Container videoDetails() {
    TextStyle decorate = TextStyle(
        fontWeight: FontWeight.bold, color: Colors.grey[700], fontSize: 17);

    TextStyle decorate2 = TextStyle(
        fontStyle: FontStyle.italic, color: Colors.black, fontSize: 17);

    return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Source:", style: decorate2),
                    Divider(height: 10, color: Colors.blue),
                    Text("Duration:", style: decorate2),
                    Divider(height: 10, color: Colors.blue),
                    Text(
                      "Resolution:",
                      style: decorate2,
                    ),
                    Divider(height: 10, color: Colors.blue),
                    Text(
                      "Aspect Ratio:",
                      style: decorate2,
                    )
                  ],
                )),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(controller.dataSource.split('/').last, style: decorate),
                Divider(height: 10, color: Colors.blue),
                Text("${controller.value.duration.inMinutes.toString()} Min",
                    style: decorate),
                Divider(height: 10, color: Colors.blue),
                Text(controller.value.size.toString(), style: decorate),
                Divider(height: 10, color: Colors.blue),
                Text(controller.value.aspectRatio.toStringAsFixed(2),
                    style: decorate)
              ],
            ))
          ],
        ));
  }
}

class ButtonController extends StatefulWidget {
  final VideoPlayerController controller;
  const ButtonController(this.controller, {Key? key}) : super(key: key);

  @override
  _ButtonControllerState createState() => _ButtonControllerState();
}

class _ButtonControllerState extends State<ButtonController> {
  final IconData playing = Icons.play_arrow;
  final IconData paused = Icons.pause;
  late IconData toShowState;
  @override
  Widget build(BuildContext context) {
    toShowState = playing;
    return Container(
      margin: EdgeInsets.only(top: 50, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.8),
      ),
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              speedUpdater(0),
              playPauseButton(),
              muteUnmuteButton(),
              speedUpdater(1)
            ],
          ),
          VideoProgressIndicator(
            widget.controller,
            allowScrubbing: true,
            colors: VideoProgressColors(
              backgroundColor: Color(0xff99ffff),
              playedColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton playPauseButton() {
    return ElevatedButton(
        onPressed: () async {
          if (widget.controller.value.isPlaying) {
            await widget.controller.pause();
          } else {
            await widget.controller.play();
          }
        },
        child: Icon(
          (widget.controller.value.isPlaying) ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ));
  }

  ElevatedButton muteUnmuteButton() {
    return ElevatedButton(
        onPressed: () {
          if (widget.controller.value.volume == 0)
            widget.controller.setVolume(1);
          else
            widget.controller.setVolume(0);
        },
        child: Icon(widget.controller.value.volume == 0
            ? Icons.volume_up
            : Icons.volume_mute));
  }

  ElevatedButton speedUpdater(int i) {
    return ElevatedButton(
        onPressed: () {
          double spd = widget.controller.value.playbackSpeed;
          i == 0 ? spd -= 0.25 : spd += 0.25;
          if (spd <= 0) spd = 0.25;
          if (spd > 2) spd = 2.0;
          widget.controller.setPlaybackSpeed(spd);
        },
        child:
            Icon(i == 0 ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios));
  }
}
