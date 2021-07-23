import 'package:flutter/material.dart';
import 'package:video_player_in_flutter/models/network_player.dart';
import 'package:video_player_in_flutter/models/static_player.dart';

class MainRoute extends StatelessWidget {
  final String asset;
  final String path;
  const MainRoute(this.path, {Key? key, this.asset = 'videos/main_video.mp4'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Page(asset, path));
  }
}

class Page extends StatefulWidget {
  final String asset;
  final String path;
  const Page(this.asset, this.path, {Key? key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  int _index = 0;

  List<Widget> tabs = <Widget>[];
  @override
  Widget build(BuildContext context) {
    tabs.add(StaticPlayer(widget.asset));
    tabs.add(NetworkPlayer(widget.path));
    return GestureDetector(
        onPanUpdate: (details) {
          int sensitivity = 12;
          if (details.delta.dx < -sensitivity) {
            setState(() {
              if (_index == 0) _index = 1;
            });
          }
          if (details.delta.dx > sensitivity) {
            setState(() {
              if (_index == 1) _index = 0;
            });
          }
        },
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            enableFeedback: true,
            elevation: 100,
            type: BottomNavigationBarType.fixed,
            currentIndex: _index,
            onTap: (int index) {
              setState(() {
                _index = index;
              });
              //debugPrint(index.toString());
            },
            backgroundColor: Colors.grey[900],
            selectedItemColor: Colors.greenAccent,
            selectedIconTheme: IconThemeData(color: Colors.white, size: 40),
            unselectedIconTheme: IconThemeData(color: Colors.grey, size: 30),
            unselectedLabelStyle: TextStyle(color: Colors.yellow, fontSize: 15),
            selectedLabelStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  label: "Local Storage",
                  icon: Icon(Icons.attach_file_rounded)),
              BottomNavigationBarItem(
                  label: "Internet",
                  icon: Icon(
                    Icons.youtube_searched_for_rounded,
                  ))
            ],
          ),
          appBar: appbar(),
          body: tabs[_index],
        ));
  }
}

AppBar appbar() {
  return AppBar(
    flexibleSpace: Container(
      height: 140,
      alignment: Alignment.bottomLeft,
      child: Container(
        height: 50,
        margin: EdgeInsets.only(left: 10),
        child: Text(
          "OmniPlayer",
          style: TextStyle(
              color: Colors.grey[900],
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontFamily: "Verdana"),
        ),
        alignment: Alignment.centerLeft,
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              end: Alignment.topLeft,
              begin: Alignment.bottomRight,
              colors: [Colors.purpleAccent, Colors.orange])),
    ),
  );
}

class W1 extends StatefulWidget {
  final Color value;
  const W1(this.value, {Key? key}) : super(key: key);

  @override
  _W1State createState() => _W1State();
}

class _W1State extends State<W1> {
  int _ans = 0;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(alignment: Alignment.center, child: Text("$_ans")),
      Container(
        child: ElevatedButton(
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              _ans++;
            });
          },
        ),
      )
    ]);
  }
}
