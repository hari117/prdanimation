import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

void main() {
  runApp(LoadingApp());
}

class LoadingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LoadingIcon(),
      ),
    );
  }
}

class LoadingIcon extends StatefulWidget {
  @override
  _LoadingIconState createState() => _LoadingIconState();
}

class _LoadingIconState extends State<LoadingIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: BoxGrid(
          rows: 3,
          colums: 4,
          boxSize: 40,
          boxGap: 5,
          duration: Duration(seconds: 4),
        ),
      ),
    );
  }
}

class BoxGrid extends StatefulWidget {
  int rows;
  int colums;
  int boxSize;
  int boxGap;
  Duration duration;

  BoxGrid({this.rows, this.colums, this.boxSize, this.boxGap, this.duration}) {}

  @override
  _BoxGridState createState() => _BoxGridState();
}

class _BoxGridState extends State<BoxGrid> with SingleTickerProviderStateMixin {
  SequenceAnimation sequenceAnimation;
  AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    animationController.addListener(() {
      setState(() {});
    });

    SequenceAnimationBuilder builder = SequenceAnimationBuilder();
    Tween tween = Tween<double>(
        begin: Angle.fromDegrees(0).radians,
        end: Angle.fromDegrees(-90).radians);

    int forOneFrame = widget.duration.inMilliseconds; // total duration
    forOneFrame = forOneFrame ~/ 2; // forward only duration
    int delayDuration = 500; // delay duration
    forOneFrame =
        forOneFrame - delayDuration; // forward only duration without delay
    forOneFrame = forOneFrame ~/ widget.colums; // single column duration

    for (int ic = 0; ic < widget.colums; ic++) {
      builder.addAnimatable(
          animatable: tween,
          curve: Curves.easeIn,
          from: Duration(milliseconds: ic * forOneFrame),
          to: Duration(milliseconds: (ic + 1) * forOneFrame),
          tag: "column$ic");
    }

    builder.addAnimatable(
        animatable: tween,
        from: Duration(milliseconds: (widget.colums) * forOneFrame),
        to: Duration(
            milliseconds: ((widget.colums) * forOneFrame) + delayDuration),
        tag: "delay");

    sequenceAnimation = builder.animate(animationController);

    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = [];
    for (int ic = 0; ic < widget.colums; ic++) {
      List<Widget> columnChildren = [];
      for (int ir = 0; ir < widget.rows; ir++) {
        columnChildren.add(Box(
          boxSize: widget.boxSize,
          columnOrder: "column$ic",
          sequenceAnimation: sequenceAnimation,
        ),);
        if (ir != (widget.rows - 1)) {
          columnChildren.add(SizedBox(
            height: widget.boxGap.toDouble(),
          ));
        }
      }
      rowChildren.add(Column(
        mainAxisSize: MainAxisSize.min,
        children: columnChildren,
      ));
      if (ic != (widget.colums - 1)) {}
      rowChildren.add(SizedBox(
        width: widget.boxGap.toDouble(),
      ));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: rowChildren,
    );
  }
}

class Box extends StatelessWidget {
  int boxSize;
  String columnOrder;
  SequenceAnimation sequenceAnimation;

  Box({this.boxSize, this.columnOrder, this.sequenceAnimation});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: sequenceAnimation[columnOrder].value,
      origin: Offset(-(boxSize / 2), boxSize / 2),
      child: Container(
        height: boxSize.toDouble(),
        width: boxSize.toDouble(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),),
    );
  }
}
