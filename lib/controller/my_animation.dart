import 'dart:async';

import 'package:flutter/material.dart';

class MyAnimation extends StatefulWidget {
  int duree;
  Widget child;
  MyAnimation({required this.child,required this.duree,super.key});

  @override
  State<MyAnimation> createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
      duration: const Duration(seconds: 2),
    );
    CurvedAnimation animationCurved = CurvedAnimation(parent: _controller, curve: Curves.linear);

    animation = Tween<Offset>(
      begin: const Offset(0,5),
      end: Offset.zero,
    ).animate(animationCurved);

    Timer(Duration(seconds: widget.duree), () {
      _controller.forward();
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: animation,
      child: FadeTransition(
        opacity: _controller,
        child: widget.child,
      ),
    );
  }
}
