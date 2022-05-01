import 'dart:math';

import 'package:flutter/material.dart';

import 'package:avataria_search/src/widgets/animated_background.dart';
import 'package:avataria_search/src/widgets/animated_wave.dart';

class AvatariaSearchBackground extends StatelessWidget {
  final Widget child;

  const AvatariaSearchBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: AnimatedBackground()),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(
              height: 180,
              speed: 1.0,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(
              height: 120,
              speed: 0.9,
              offset: pi,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(
              height: 220,
              speed: 1.2,
              offset: pi / 2,
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}
