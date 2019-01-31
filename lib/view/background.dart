import 'package:flutter/material.dart';
import 'package:flutter_view/widget/video_view.dart';

class Background extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return BackgroundState();
  }

}

class BackgroundState extends State<Background>{
  static const double DEFAULT_WIDTH = 160;
  static const double DEFAULT_HEIGHT = 90;
  GlobalKey _globalKey = new GlobalKey();
  //视频的参数，宽，高，比例
  double _width;
  double _height;
  double _x;
  double _y;
  double _ratio;

  //临时变量
  double _tmpW;
  double _tmpH;
  Offset _lastOffset;

  //背景的宽高
  double _bgW;
  double _bgH;

  @override
  void initState() {
    super.initState();
    //一些参数的初始化
    _width = DEFAULT_WIDTH;
    _height = DEFAULT_HEIGHT;
    _x = _width;
    _y = _height;
    _ratio = _width / _height;
    _tmpW = _width;
    _tmpH = _height;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(key:_globalKey, color: Colors.blueGrey, width: double.infinity, height: double.infinity,),
        Positioned(child: GestureDetector(child:CustomView(width: _width, height: _height, url: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",), onScaleEnd: scaleEnd, onScaleStart: scaleStart, onScaleUpdate: scaleUpdate,), left: _x, top: _y,),
      ],
    );
  }

  //计算背景的宽高
  void getBgInfo(){
    RenderBox renderObject = _globalKey.currentContext.findRenderObject();
    _bgW = renderObject.paintBounds.size.width;
    _bgH = renderObject.paintBounds.size.height;
  }

  //开始缩放
  void scaleStart(ScaleStartDetails details){
    _tmpW = _width;
    _tmpH = _height;
    _lastOffset = details.focalPoint;
    getBgInfo();
  }

  //缩放更新
  void scaleUpdate(ScaleUpdateDetails details){

    setState(() {
      _width = _tmpW*details.scale;
      _height = _tmpH*details.scale;
      _x += (details.focalPoint.dx - _lastOffset.dx) ;
      _y += (details.focalPoint.dy - _lastOffset.dy);
      //边界判定，保持宽高比
      if(_width > _bgW){
        _width = _bgW;
        _height = _width / _ratio;
      }
      if(_height > _bgH){
        _height = _bgH;
        _width = _height * _ratio;
      }
      if(_x < 0){
        _x = 0;
      }
      if(_y < 0){
        _y = 0;
      }
      if(_x > _bgW-_width){
        _x = _bgW-_width;
      }
      if(_y > _bgH-_height){
        _y = _bgH-_height;
      }
      _lastOffset = details.focalPoint;
    });
  }

  //缩放结束
  void scaleEnd(ScaleEndDetails details){
    _tmpW = _width;
    _tmpH = _height;
    //边界判定，保持宽高比
    if(_width < DEFAULT_WIDTH){
      _width = DEFAULT_WIDTH;
      _height = _width / _ratio;
    }
    if(_height < DEFAULT_HEIGHT){
      _height = DEFAULT_HEIGHT;
      _width = _height * _ratio;
    }
  }

}