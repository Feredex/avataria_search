import 'package:avataria_search/src/models/profile_change_notifier.dart';
import 'package:avataria_search/src/pages/profile_dispatcher.dart';
import 'package:avataria_search/src/pages/verify_email_page.dart';
import 'package:avataria_search/src/services/firebase_auth_service.dart';
import 'package:avataria_search/src/widgets/auth_widget.dart';
import 'package:avataria_search/src/widgets/auth_widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:avataria_search/src/pages/welcome_page.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

class AvatariaSearchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => FirebaseAuthService(),
      child: AuthWidgetBuilder(
        userProvidersBuilder: (context, user) => [
          Provider<User>.value(value: user),
          ChangeNotifierProvider<ProfileChangeNotifier>(
            create: (_) => ProfileChangeNotifier(user.uid),
          )
        ],
        builder: (context, userSnapshot) {
          return MaterialApp(
            title: 'AvatariaSearch',
            home: AuthWidget(
              userSnapshot: userSnapshot,
              notSignedInWidgetBuilder: (context) => WelcomePage(),
              signedInWidgetBuilder: (context) {
                if (Provider.of<User>(context).isEmailVerified == false) {
                  return VerifyEmailPage();
                }
                return ProfileDispatcher();
              },
            ),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ru', 'RU'),
            ],
            theme: ThemeData(
              primaryColor: Color(0xff5b2b8b),
              accentColor: Color(0xffdff7f9),
              colorScheme: ColorScheme(
                primary: Color(0xff5b2b8b),
                primaryVariant: Color(0xff0f152d),
                onPrimary: Colors.white,
                secondary: Color(0xffdff7f9),
                secondaryVariant: Color(0xffaadaf1),
                onSecondary: Colors.black,
                surface: Colors.white,
                onSurface: Colors.black,
                error: Colors.yellow,
                onError: Colors.black,
                background: Colors.white,
                onBackground: Colors.black,
                brightness: Brightness.light,
              ),
              scaffoldBackgroundColor: Color(0xff5b2b8b),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              buttonTheme: ButtonThemeData(
                buttonColor: Color(0xffdff7f9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                errorStyle: TextStyle(color: Colors.yellow),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow, width: 2.0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow, width: 3.0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffaadaf1), width: 3.0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              fontFamily: 'Raleway',
              textTheme: TextTheme(
                headline1: TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -1.5,
                ),
                headline2: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.5,
                ),
                headline3: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                ),
                headline4: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.25,
                ),
                headline5: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                headline6: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                ),
                subtitle1: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
                subtitle2: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
                bodyText1: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
                bodyText2: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                  color: Color(0xffdff7f9),
                ),
                button: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.25,
                ),
                caption: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                ),
                overline: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
