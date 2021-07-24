import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OverlayController extends StatefulWidget {
  final VideoPlayerController controller;
  const OverlayController(this.controller, {Key? key}) : super(key: key);

  @override
  _OverlayControllerState createState() => _OverlayControllerState();
}

class _OverlayControllerState extends State<OverlayController> {
  double _speed = 1.0;
  //bool _triggered = false;
  String showme = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          //print(widget.controller.dataSource);
          //print(widget.controller.position.toString());
          //print(widget.controller.value.size);
          //print(widget.controller.value.position);
          widget.controller.value.isPlaying
              ? await widget.controller.pause()
              : await widget.controller.play();
          print(widget.controller.value.isPlaying);
        },
        onPanUpdate: (details) {
          //if (details.delta.dy < 0) print('Swipe Up');
          setState(() {
            if (details.delta.dx < -5) {
              _speed -= 0.05;
              //print(_speed);
            }
            //if (details.delta.dy > 0) print('Swipe Down');
            if (details.delta.dx > 5) {
              _speed += 0.05;
              //print(_speed);
            }
            showme = "${_speed.toStringAsFixed(2)} X";
            //print(showme);
            if (_speed <= 0) _speed = 0.25;
            if (_speed > 2.0) _speed = 2.0;
            widget.controller.setPlaybackSpeed(_speed);
            //whatToShow = popup;

            //widget.controller.value.
          });

          Timer(Duration(seconds: 2), () {
            setState(() {
              showme = "";
            });
          });
        },
        child: Stack(
          children: [
            buildPlay(),
            Center(
                child: Text(
              showme,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            )),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 12,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: VideoProgressIndicator(
                    widget.controller,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      backgroundColor: Color(0xff99ffff),
                      playedColor: Colors.red,
                    ),
                  ),
                ))
          ],
        ));
  }

  Widget buildPlay() {
    return widget.controller.value.isPlaying
        ? Container()
        : Container(
            alignment: Alignment.center,
            color: Colors.black26,
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ));
  }
}
