import 'package:avataria_search/src/constants.dart';
import 'package:avataria_search/src/services/firebase_auth_service.dart';
import 'package:avataria_search/src/widgets/avataria_search_background.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

enum _ButtonType { register, signIn, restorePassword }

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  static const _animationDuration = Duration(milliseconds: 200);
  _ButtonType? _pressedButton;
  String? _currentErrorCode;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _inAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AvatariaSearchBackground(
        child: ModalProgressHUD(
          inAsyncCall: _inAsyncCall,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(kHorizontalPadding),
              child: Form(
                key: _formKey,
                child: AnimatedSwitcher(
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      children: <Widget>[
                        ...previousChildren,
                        if (currentChild != null) currentChild,
                      ],
                      alignment: Alignment.center,
                    );
                  },
                  duration: _animationDuration,
                  child: Column(
                    key: ValueKey(_pressedButton),
                    children: <Widget>[
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: Text(
                          _getTitleText(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Theme.of(context).accentColor),
                        ),
                      ),
                      SizedBox(
                        width: kBodyWidth,
                        child: Column(
                          children: _buildFormWidgets(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTitleText() {
    switch (_pressedButton) {
      case _ButtonType.register:
        return 'Регистрация';
      case _ButtonType.signIn:
        return 'Вход';
      case _ButtonType.restorePassword:
        return 'Сброс пароля';
      default:
        return 'Находите игроков в мобильной Аватарии';
    }
  }

  List<Widget> _buildFormWidgets() {
    if (_pressedButton != null) {
      return [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(hintText: 'Электронная почта'),
          validator: (value) {
            if (value != null && value.isEmpty) {
              return 'Введите электронную почту';
            }
            switch (_currentErrorCode) {
              case FirebaseAuthErrors.invalidEmail:
              case FirebaseAuthErrors.emailAlreadyInUse:
              case FirebaseAuthErrors.userNotFound:
                return FirebaseAuthErrors.getErrorMessage(_currentErrorCode!);
              default:
                return null;
            }
          },
        ),
        if (_pressedButton != _ButtonType.restorePassword)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Пароль'),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Введите пароль';
                }
                switch (_currentErrorCode) {
                  case FirebaseAuthErrors.weakPassword:
                  case FirebaseAuthErrors.wrongPassword:
                    return FirebaseAuthErrors.getErrorMessage(
                        _currentErrorCode!);
                  default:
                    return null;
                }
              },
            ),
          ),
        SizedBox(height: 20.0),
        Builder(builder: (context) => _buildButton(context)),
        if (_pressedButton == _ButtonType.signIn)
          FlatButton(
            textTheme: ButtonTextTheme.accent,
            child: Text('СБРОСИТЬ ПАРОЛЬ'),
            onPressed: () =>
                setState(() => _pressedButton = _ButtonType.restorePassword),
          ),
        FlatButton(
          textTheme: ButtonTextTheme.accent,
          child: Text('НАЗАД'),
          onPressed: _onBackButtonPressed,
        ),
      ];
    } else {
      return [
        RaisedButton(
          child: Text('ЗАРЕГИСТРИРОВАТЬСЯ'),
          onPressed: () =>
              setState(() => _pressedButton = _ButtonType.register),
        ),
        SizedBox(height: 10.0),
        RaisedButton(
          child: Text('ВОЙТИ'),
          onPressed: () => setState(() => _pressedButton = _ButtonType.signIn),
        ),
      ];
    }
  }

  Widget _buildButton(BuildContext context) {
    switch (_pressedButton) {
      case _ButtonType.register:
        return RaisedButton(
          child: Text('ЗАРЕГИСТРИРОВАТЬСЯ'),
          onPressed: () => _onRegisterButtonPressed(context),
        );
      case _ButtonType.signIn:
        return RaisedButton(
          child: Text('ВОЙТИ'),
          onPressed: () => _onSignInButtonPressed(context),
        );
      case _ButtonType.restorePassword:
        return RaisedButton(
          child: Text('СБРОСИТЬ ПАРОЛЬ'),
          onPressed: () => _onResetPasswordButtonPressed(context),
        );
      default:
        throw Error;
    }
  }

  void _onBackButtonPressed() {
    _currentErrorCode = null;
    _emailController.clear();
    _passwordController.clear();
    switch (_pressedButton!) {
      case _ButtonType.register:
      case _ButtonType.signIn:
        setState(() => _pressedButton = null);
        break;
      case _ButtonType.restorePassword:
        setState(() => _pressedButton = _ButtonType.signIn);
        break;
    }
  }

  Future<void> _onRegisterButtonPressed(BuildContext context) async {
    _currentErrorCode = null;
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _inAsyncCall = true);
        await Provider.of<FirebaseAuthService>(context, listen: false)
            .createUserWithEmailAndPasswordAndSendEmailVerification(
                _emailController.text, _passwordController.text);
      } catch (e) {
        _handleAuthException(e, context);
        setState(() => _inAsyncCall = false);
      }
    }
  }

  Future<void> _onSignInButtonPressed(BuildContext context) async {
    _currentErrorCode = null;
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _inAsyncCall = true);
        await Provider.of<FirebaseAuthService>(context, listen: false)
            .signInWithEmailAndPassword(
                _emailController.text, _passwordController.text);
      } catch (e) {
        _handleAuthException(e, context);
        setState(() => _inAsyncCall = false);
      }
    }
  }

  Future<void> _onResetPasswordButtonPressed(BuildContext context) async {
    _currentErrorCode = null;
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _inAsyncCall = true);
        await Provider.of<FirebaseAuthService>(context, listen: false)
            .sendPasswordResetEmail(_emailController.text);
        setState(() => _inAsyncCall = false);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Ссылка для сброса пароля отправлена на Вашу электронную почту',
              ),
              content: Text(
                'Для сброса пароля перейдите по ссылке из письма, только что '
                'отправленного нами на Вашу электронную почту.\n\n'
                'Если Вы не обнаруживаете письмо, проверьте папку "Спам".',
              ),
              actions: [
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    setState(() => _pressedButton = null);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        _emailController.clear();
      } catch (e) {
        _handleAuthException(e, context);
        setState(() => _inAsyncCall = false);
      }
    }
  }

  void _handleAuthException(e, BuildContext context) {
    if (e.code != null) {
      switch (e.code) {
        case FirebaseAuthErrors.invalidEmail:
        case FirebaseAuthErrors.weakPassword:
        case FirebaseAuthErrors.emailAlreadyInUse:
        case FirebaseAuthErrors.wrongPassword:
        case FirebaseAuthErrors.userNotFound:
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          _currentErrorCode = e.code;
          _formKey.currentState!.validate();
          break;
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
