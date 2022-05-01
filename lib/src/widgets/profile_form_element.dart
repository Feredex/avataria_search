import 'package:flutter/material.dart';

class ProfileFormElement extends StatelessWidget {
  final Widget child;
  final String hintTitle;
  final String hintBody;
  final EdgeInsetsGeometry padding;

  ProfileFormElement({
    Key? key,
    required this.child,
    required this.hintTitle,
    required this.hintBody,
    this.padding = const EdgeInsets.only(bottom: 20.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: child),
          IconButton(
            icon: Icon(Icons.help, color: Theme.of(context).accentColor),
            tooltip: hintTitle,
            onPressed: () => _onShowHintButtonPressed(context),
          ),
        ],
      ),
    );
  }

  void _onShowHintButtonPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(hintTitle),
        content: SingleChildScrollView(
          child: Text(hintBody),
        ),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
