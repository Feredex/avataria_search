import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'package:avataria_search/src/models/user.dart';
import 'package:avataria_search/src/services/firebase_auth_service.dart';
import 'package:avataria_search/src/widgets/avataria_search_background.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _inAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AvatariaSearchBackground(
        child: ModalProgressHUD(
          inAsyncCall: _inAsyncCall,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Image.asset(
                          'assets/logo-full.png',
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    children: [
                      Text(
                        'Поздравляем с регистрацией!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Theme.of(context).accentColor),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Для продолжения подтвердите Ваш адрес электронной почты, '
                        'перейдя по ссылке из письма, которое мы отправили Вам на '
                        '${Provider.of<User>(context).email}.\n\n'
                        'После подтверждения обновите эту страницу.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Theme.of(context).accentColor),
                      ),
                      SizedBox(height: 20.0),
                      RaisedButton(
                        child: Text('ВЫЙТИ ИЗ АККАУНТА'),
                        onPressed: () => _onSignOutButtonPressed(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSignOutButtonPressed(BuildContext context) async {
    try {
      setState(() => _inAsyncCall = true);
      await Provider.of<FirebaseAuthService>(context, listen: false).signOut();
    } catch (e) {
      setState(() => _inAsyncCall = false);
      _handleAuthException(e, context);
    }
  }

  void _handleAuthException(e, BuildContext context) {
    if (e.code != null) {
      switch (e.code) {
        case FirebaseAuthErrors.userDisabled:
        case FirebaseAuthErrors.tooManyRequests:
        case FirebaseAuthErrors.operationNotAllowed:
        case FirebaseAuthErrors.networkRequestFailed:
          _showSnackBar(
            FirebaseAuthErrors.getErrorMessage(e.code),
            context,
          );
          break;
        default:
          _showSnackBar('Произошла ошибка: $e.', context);
          break;
      }
    }
  }

  void _showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          duration: Duration(seconds: 10),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
  }
}
