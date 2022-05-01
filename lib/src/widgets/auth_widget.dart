import 'package:flutter/material.dart';

import 'package:avataria_search/src/models/user.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({
    required this.userSnapshot,
    required this.signedInWidgetBuilder,
    required this.notSignedInWidgetBuilder,
  });

  final AsyncSnapshot<User> userSnapshot;
  final WidgetBuilder signedInWidgetBuilder;
  final WidgetBuilder notSignedInWidgetBuilder;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData
          ? signedInWidgetBuilder(context)
          : notSignedInWidgetBuilder(context);
    } else {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
