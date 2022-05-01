import 'package:flutter/material.dart';

import 'package:simple_animations/simple_animations.dart';

enum _BgProps { color1, color2 }

class AnimatedBackground extends StatelessWidget {
  static const durationInSeconds = 10;

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_BgProps>()
      ..add(
        _BgProps.color1,
        ColorTween(
          begin: Theme.of(context).colorScheme.primary,
          end: Color(0xffc5a8ea),
        ),
      )
      ..add(
        _BgProps.color2,
        ColorTween(
          begin: Theme.of(context).colorScheme.primaryVariant,
          end: Color(0xff756397),
        ),
      );

    return MirrorAnimation<MultiTweenValues<_BgProps>>(
      tween: tween,
      duration: Duration(seconds: durationInSeconds),
      builder: (context, child, value) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [value.get(_BgProps.color1), value.get(_BgProps.color2)],
            ),
          ),
        );
      },
    );
  }
}
