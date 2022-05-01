import 'package:firebase_auth/firebase_auth.dart';

import 'package:avataria_search/src/models/user.dart';

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged
        .map((firebaseUser) => User.fromFirebaseUser(firebaseUser));
  }

  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return User.fromFirebaseUser(authResult.user);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return User.fromFirebaseUser(authResult.user);
  }

  Future<User> createUserWithEmailAndPasswordAndSendEmailVerification(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await authResult.user.sendEmailVerification();
    return User.fromFirebaseUser(authResult.user);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return User.fromFirebaseUser(user);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}

class FirebaseAuthErrors {
  static const _errorPrefix = 'auth/';
  static const invalidEmail = '${_errorPrefix}invalid-email';
  static const weakPassword = '${_errorPrefix}weak-password';
  static const emailAlreadyInUse = '${_errorPrefix}email-already-in-use';
  static const networkRequestFailed = '${_errorPrefix}network-request-failed';
  static const wrongPassword = '${_errorPrefix}wrong-password';
  static const userNotFound = '${_errorPrefix}user-not-found';
  static const userDisabled = '${_errorPrefix}user-disabled';
  static const tooManyRequests = '${_errorPrefix}too-many-requests';
  static const operationNotAllowed = '${_errorPrefix}operation-not-allowed';

  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case invalidEmail:
        return 'Неверный адрес электронной почты';
      case weakPassword:
        return 'Слабый пароль';
      case emailAlreadyInUse:
        return 'Эта электронная почта уже используется';
      case networkRequestFailed:
        return 'Проверьте соединение с интернетом!';
      case wrongPassword:
        return 'Неправильный пароль';
      case userNotFound:
        return 'Аккаунта с этой почтой не существует';
      case userDisabled:
        return 'Этот аккаунт был отключён';
      case tooManyRequests:
        return 'Слишком много попыток войти! Попробуйте позже.';
      case operationNotAllowed:
        return 'Функция для входа в приложение не включена';
      default:
        return 'Произошла ошибка: $errorCode';
    }
  }
}
