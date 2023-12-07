import "package:flutter/material.dart";
import "dart:ui";

import "package:flutter_spinkit/flutter_spinkit.dart";

class CustomLoader extends StatelessWidget {
  final double opacity;

  final Color color;

  final Widget progressIndicator;

  final Offset? offset;

  final bool dismissible;

  final double blur;

  const CustomLoader({
    Key? key,
    this.opacity = 0.1,
    this.color = Colors.indigo,
    this.progressIndicator = const SpinKitChasingDots(
      color: Colors.indigo,
      size: 50.0,
    ),
    this.offset,
    this.dismissible = false,
    this.blur = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget layOutProgressIndicator;
    if (offset == null) {
      layOutProgressIndicator = Center(child: progressIndicator);
    } else {
      layOutProgressIndicator = Positioned(
        left: offset!.dx,
        top: offset!.dy,
        child: progressIndicator,
      );
    }

    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: dismissible, color: color),
          ),
        ),
        layOutProgressIndicator,
      ],
    );
  }
}
