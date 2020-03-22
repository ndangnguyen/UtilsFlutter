import 'dart:math';

import 'package:base/utils/logging_utils.dart';
import 'package:flutter/material.dart';

class FadeInWidget extends StatefulWidget {
  final Widget child;

  final Duration duration;

  FadeInWidget({this.child, this.duration = const Duration(milliseconds: 400)});

  @override
  _FadeInWidgetState createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget> {
  double _opacity;

  @override
  void initState() {
    super.initState();
    _opacity = 0.0;
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: widget.duration,
      curve: Curves.easeInOut,
      child: widget.child,
    );
  }
}

class RotateWidget extends StatefulWidget {
  final Widget child;
  final double angle;

  RotateWidget({this.child, this.angle});

  @override
  _RotateWidgetState createState() => _RotateWidgetState();
}

class _RotateWidgetState extends State<RotateWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _currentAngle;
  double _previousAngle;
  Animation<double> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350))
          ..forward(from: 0.00);
    _currentAngle = widget.angle;
    super.initState();
  }

  @override
  void didUpdateWidget(RotateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.angle != widget.angle) {
      _previousAngle = _currentAngle;
      _currentAngle = widget.angle;
      _animation = Tween<double>(begin: _previousAngle, end: _currentAngle)
          .animate(_controller);
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_previousAngle == null) {
      return Transform.rotate(
        angle: _currentAngle,
        child: widget.child,
      );
    } else {
      return RotationTransition(
        turns: _animation,
        child: widget.child,
      );
    }
  }
}

class SlideWidget extends StatefulWidget {
  final Widget child;

  final Duration duration;

  final Offset offset;

  final Curve curve;

  SlideWidget(
      {this.child,
        this.curve = Curves.linear,
      this.duration = const Duration(milliseconds: 400),
      this.offset = const Offset(0.0, -0.05)});

  @override
  _SlideWidgetState createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward(from: 0.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: widget.offset, end: Offset.zero)
          .animate(CurvedAnimation(parent: _controller, curve: widget.curve)),
      child: widget.child,
    );
  }
}

class ShakeCurve extends Curve {
  @override
  double transform(double t) => sin(t * pi * 2);
}

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final Axis axis;
  final int shakeCount;
  final bool autoPlay;
  final Duration delay;

  static final countInfinite = -1;

  const ShakeWidget(
      {Key key,
      @required this.child,
      this.duration = const Duration(milliseconds: 50),
      this.offset = 10,
      this.shakeCount = 3,
      this.axis = Axis.horizontal,
      this.delay,
      this.autoPlay = false})
      : super(key: key);

  @override
  _ShakeWidgetState createState() => _ShakeWidgetState();

  static shakeScreen(BuildContext context) {
    final _ShakeWidgetState state =
        context.ancestorStateOfType(const TypeMatcher<_ShakeWidgetState>());
    state?.shake();
  }
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _shakeAnimation;
  double _offset;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        upperBound: 1.0,
        lowerBound: -1.0,
        value: 0.0,
        duration: widget.duration);

    _offset = widget.offset;

    _shakeAnimation = CurvedAnimation(parent: _controller, curve: ShakeCurve());

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.shakeCount == ShakeWidget.countInfinite) {
          _controller.reverse();
        } else {
          _offset -= (widget.offset / widget.shakeCount);
          if (_offset > 0) {
            _controller.reverse();
          } else {
            _controller.animateTo(0.0);
          }
        }
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    if (widget.autoPlay) {
      if (widget.delay != null) {
        Future.delayed(widget.delay, () {
          _controller.forward(from: 0.0);
        });
      } else {
        _controller.forward(from: 0.0);
      }
    }

    super.initState();
  }

  @override
  void didUpdateWidget(ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    _controller.duration = widget.duration;
    _offset = widget.offset;
    log('New config: ${widget.duration}, ${widget.offset}');
    if (_controller.isAnimating) {
      _controller.forward(from: 0.0);
    }
  }

  void shake() {
    _offset = widget.offset;
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget.child,
      builder: (BuildContext context, Widget child) {
        double newOffset = _controller.value * _offset;
        return Transform.translate(
          offset: widget.axis == Axis.horizontal
              ? Offset(newOffset, 0)
              : Offset(0, newOffset),
          child: Container(
            child: child,
          ),
        );
      },
      animation: _shakeAnimation,
    );
  }
}

class BlinkingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const BlinkingWidget({Key key, this.child, this.duration}) : super(key: key);

  @override
  _BlinkingWidgetState createState() => _BlinkingWidgetState();
}

class _BlinkingWidgetState extends State<BlinkingWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: Container(
        child: widget.child,
      ),
      opacity: _animationController,
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward(from: 0.0);
      }
    });
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class BouncingButton extends StatefulWidget {
  final Widget child;
  final Function onTap;
  final double shrinkOffset;

  const BouncingButton(
      {Key key, this.onTap, this.child, this.shrinkOffset = 0.9})
      : super(key: key);

  @override
  _BouncingButtonState createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 70));
    _animation = Tween<double>(begin: 1.0, end: widget.shrinkOffset).animate(
        CurvedAnimation(parent: _controller, curve: Curves.decelerate));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap != null) {
      return GestureDetector(
        onTapDown: (details) {
          _controller.forward(from: 0.0);
        },
        onTapUp: (details) {
          _controller.reverse();
          Future.delayed(Duration(milliseconds: 50), () {
            widget.onTap();
          });
        },
        onTapCancel: () {
          _controller.reverse();
        },
        behavior: HitTestBehavior.translucent,
        child: ScaleTransition(
          scale: _animation,
          child: widget.child,
        ),
      );
    } else {
      return widget.child;
    }
  }
}
