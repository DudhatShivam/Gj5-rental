import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:gj5_rental/Utils/utils.dart';

class ChangeProduct extends StatefulWidget {
  const ChangeProduct({Key? key}) : super(key: key);

  @override
  State<ChangeProduct> createState() => _ChangeProductState();
}

class _ChangeProductState extends State<ChangeProduct>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  Animation? _colorAnimation;
  Animation<double>? sizeAnimation;
  AnimationStatus? statuss;
  Animation? curve;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    sizeAnimation = Tween(begin: 0.0, end: 34.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.20, 0.40, curve: Curves.easeOut)));
    animationController.addListener(() {
      setState(() {});
    });
    animationController.forward();
    // sizeAnimation =
    //     Tween<double>(begin: 0, end: 1).animate(animationController);
    // _colorAnimation = ColorTween(begin: Colors.white, end: Colors.black)
    //     .animate(animationController);
    // animationController.forward();
    // animationController.addListener(() {
    //   if (animationController.isCompleted) {
    //     animationController.reverse();
    //   }
    //   if (animationController.isDismissed) {
    //     animationController.forward();
    //   }
    //   setState(() {});
    // });

    // sizeAnimation = TweenSequence([
    //   TweenSequenceItem<double>(
    //       tween: Tween<double>(begin: 30, end: 50), weight: 50),
    //   TweenSequenceItem<double>(
    //       tween: Tween<double>(begin: 50, end: 30), weight: 50)
    // ]).animate(animationController);
    // _colorAnimation = ColorTween(begin: Colors.grey, end: Colors.red)
    //     .animate(animationController);
    // animationController.addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text(
            "Change product screen",
            style: TextStyle(fontSize: sizeAnimation?.value,color: Colors.black),
          ),
        ),
        //     body: Center(
        //   child: Transform.rotate(
        //     angle: animationController.value * 6.285,
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: _colorAnimation?.value,
        //         shape: BoxShape.circle
        //       ),
        //       alignment: Alignment.center,
        //       width: animationController.value * getWidth(1, context),
        //       height: animationController.value * getWidth(1, context),
        //       child: Text(
        //         "Dishant",
        //         style: TextStyle(
        //             color: Colors.white,
        //             fontSize: animationController.value * 30,
        //             fontWeight: FontWeight.w500),
        //       ),
        //     ),
        //   ),
        // )
        // body: Column(
        //   children: [
        //     AnimatedBuilder(
        //         animation: animationController,
        //         builder: (context, _) {
        //           return Column(
        //             children: [
        //               Container(
        //                 padding: EdgeInsets.all(10),
        //                 decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.circular(20),
        //                     border: Border.all(color: _colorAnimation?.value)),
        //                 child: Icon(
        //                   Icons.favorite,
        //                   color: _colorAnimation?.value,
        //                   size: sizeAnimation?.value,
        //                 ),
        //               ),
        //               SizedBox(
        //                 height: 50,
        //               ),
        //               ElevatedButton(
        //                   onPressed: () {
        //                     animationController.addStatusListener((status) {
        //                       statuss = status;
        //                     });
        //                     if (statuss == null ||
        //                         statuss == AnimationStatus.dismissed) {
        //                       animationController.forward();
        //                     } else if (statuss == AnimationStatus.completed) {
        //                       animationController.reverse();
        //                     }
        //                   },
        //                   child: Text("Animate"))
        //             ],
        //           );
        //         }),
        //   ],
        // ),
      ),
    );
  }
}
