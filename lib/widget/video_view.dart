import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomView extends StatefulWidget{
  final double width;
  final double height;
  final String url;

  const CustomView({@required this.width, @required this.height, @required this.url});

  @override
  State<StatefulWidget> createState() {
    return CustomViewState();
  }

}

class CustomViewState extends State<CustomView>{
  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: _controller.value.initialized ? VideoPlayer(_controller) : Container(color: Colors.black,),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}