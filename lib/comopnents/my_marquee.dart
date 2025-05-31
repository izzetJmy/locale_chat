import 'package:flutter/material.dart';

class MyMarquee extends StatefulWidget {
  final Widget child;
  final String textToMeasure;
  final TextStyle? textStyleToMeasure;
  final double scrollSpeed;
  final double pauseDuration;

  const MyMarquee({
    Key? key,
    required this.child,
    required this.textToMeasure,
    this.textStyleToMeasure,
    this.scrollSpeed = 50.0,
    this.pauseDuration = 2.0,
  }) : super(key: key);

  @override
  State<MyMarquee> createState() => _MyMarqueeState();
}

class _MyMarqueeState extends State<MyMarquee> {
  late final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;

  double _getTextWidth() {
    final textSpan = TextSpan(
      text: widget.textToMeasure,
      style: widget.textStyleToMeasure ?? Theme.of(context).textTheme.bodyLarge,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width;
  }

  void _startScrolling(double textWidth) {
    if (!mounted) return;
    _isScrolling = true;
    _scrollController.jumpTo(0.0);
    Future.delayed(Duration(seconds: widget.pauseDuration.toInt()), () {
      if (!mounted) return;
      _animateScroll(textWidth);
    });
  }

  void _animateScroll(double textWidth) {
    if (!mounted || !_isScrolling) return;
    final duration =
        Duration(seconds: (textWidth / widget.scrollSpeed).toInt());
    _scrollController
        .animateTo(
      textWidth,
      duration: duration,
      curve: Curves.linear,
    )
        .then((_) {
      if (!mounted) return;
      _scrollController.jumpTo(0.0);
      Future.delayed(Duration(seconds: widget.pauseDuration.toInt()), () {
        if (!mounted) return;
        _animateScroll(textWidth);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textWidth = _getTextWidth();
        if (textWidth <= constraints.maxWidth) {
          // Sığıyorsa: child'ı olduğu gibi göster
          return SizedBox(
            width: constraints.maxWidth,
            child: widget.child,
          );
        } else {
          // Sığmıyorsa kaydırmalı göster
          if (!_isScrolling) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _startScrolling(textWidth);
            });
          }
          return SizedBox(
            width: constraints.maxWidth,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: widget.child,
            ),
          );
        }
      },
    );
  }
}
