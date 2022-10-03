import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ScaleContainer extends StatefulWidget {
  const ScaleContainer(
      {super.key,
      required this.child,
      required this.onTap,
      this.time = 150,
      this.scale = 0.9,
      this.alignment = Alignment.center});

  final Widget child;

  final int time;

  final double scale;

  final Function onTap;

  final Alignment alignment;

  @override
  State<ScaleContainer> createState() => _ScaleContainerState();
}

class _ScaleContainerState extends State<ScaleContainer> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedTransform(
      transform: Matrix4.diagonal3Values(pressed ? widget.scale : 1, pressed ? widget.scale : 1, 1.0),
      alignment: widget.alignment,
      transformHitTests: true,
      duration: Duration(milliseconds: widget.time),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTap: () {
          setState(() => pressed = true);
          Future.delayed(Duration(milliseconds: widget.time), () async {
            setState(() => pressed = false);
            Future.delayed(Duration(milliseconds: widget.time), () async {
              widget.onTap();
            });
          });
        },
        child: widget.child,
      ),
    );
  }
}

class AnimatedTransform extends ImplicitlyAnimatedWidget {
  const AnimatedTransform({
    Key? key,
    this.transform,
    this.origin,
    this.alignment,
    this.transformHitTests = true,
    this.child,
    Curve curve = Curves.linear,
    required Duration duration,
  }) : super(
          key: key,
          curve: curve,
          duration: duration,
        );

  final Widget? child;

  final Offset? origin;

  final AlignmentGeometry? alignment;

  final bool? transformHitTests;

  final Matrix4? transform;

  @override
  AnimatedTransformState createState() => AnimatedTransformState();
}

class AnimatedTransformState extends AnimatedWidgetBaseState<AnimatedTransform> {
  AlignmentGeometryTween? _alignment;
  Matrix4Tween? _transform;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _alignment = visitor(
            _alignment, widget.alignment, (dynamic value) => AlignmentGeometryTween(begin: value as AlignmentGeometry))
        as AlignmentGeometryTween;
    _transform =
        visitor(_transform, widget.transform, (dynamic value) => Matrix4Tween(begin: value as Matrix4)) as Matrix4Tween;
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: _transform?.evaluate(animation) ?? Matrix4.zero(),
      alignment: _alignment?.evaluate(animation),
      origin: widget.origin,
      transformHitTests: widget.transformHitTests ?? true,
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<AlignmentGeometryTween>('alignment', _alignment, showName: false, defaultValue: null));
    properties.add(ObjectFlagProperty<Matrix4Tween>.has('transform', _transform));
  }
}
