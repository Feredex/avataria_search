import 'package:flutter/material.dart';

class AutoIconButton extends StatefulWidget {
  final void Function() onPressed;
  final Widget icon;
  final Color? disabledColor;

  AutoIconButton({
    required this.icon,
    required this.onPressed,
    this.disabledColor,
  });

  @override
  _AutoIconButtonState createState() => _AutoIconButtonState();
}

class _AutoIconButtonState extends State<AutoIconButton> {
  bool _disabled = false;

  @override
  Widget build(BuildContext context) {
    print(_disabled);
    return IconButton(
      icon: widget.icon,
      disabledColor: widget.disabledColor,
      onPressed: !_disabled
          ? () {
              widget.onPressed();
              setState(() => _disabled = true);
            }
          : null,
    );
  }
}
