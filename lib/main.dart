import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

void main() {
  runApp(MaterialApp(
    home: screen(),
  ));
}

class screen extends StatefulWidget {
  @override
  _screenState createState() => _screenState();
}

class _screenState extends State<screen> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  int r = 3;
  int c = 4;
  int i = 0, j = 0;
  double boxsize = 50;
  double boxpading = 10;
  SequenceAnimation _sequenceAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this);
    Tween tween = Tween<double>(
        begin: Angle.fromDegrees(0).radians,
        end: Angle.fromDegrees(-90).radians);
    SequenceAnimationBuilder build = SequenceAnimationBuilder();
    for (int i = 0; i < c; i++) {
      build
          .addAnimatable(
              animatable: tween,
              from: Duration(seconds: i),
              to: Duration(seconds: i + 1),
              tag: "Col$i")
          .animate(_animationController);
    }
    _sequenceAnimation = build.animate(_animationController);
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> RLine = List();
    for (i = 0; i < c; i++) {
      List<Widget> Cline = List();
      for (j = 0; j < r; j++) {
        Cline.add(box(boxsize, boxpading,i));
      }
      RLine.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: Cline,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: RLine,
          ),
        ),
      ),
    );
  }

  box(double boxsize, double boxpading,int i) {
    return Transform.rotate(
      angle: _sequenceAnimation['Col$i'].value,
      origin: Offset(-(boxsize / 2), boxsize / 2),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          width: boxsize.toDouble(),
          height: boxsize.toDouble(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(boxpading),
          ),
        ),
      ),
    );
  }
}
