import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:avataria_search/src/models/profile_change_notifier.dart';
import 'package:avataria_search/src/pages/home_page.dart';
import 'package:avataria_search/src/pages/profile_filling_page.dart';

class ProfileDispatcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileChangeNotifier>(
      builder: (context, notifier, _) {
        if (notifier.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          // TODO: No internet?
          /*if (notifier.profile == null) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AvatariaSearchAppBar(),
              body: AvatariaSearchBackground(
                child: Center(
                  child: Text(
                    'Нет подключения к Интернету! ☹',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                ),
              ),
            );
          } */
          if (notifier.profileExists!) {
            return HomePage();
          } else {
            return ProfileFillingPage();
          }
        }
      },
    );
  }
}
