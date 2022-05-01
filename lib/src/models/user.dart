import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';

@immutable
class User {
  const User({
    required this.uid,
    this.email,
    this.displayName,
    this.isEmailVerified,
    this.photoUrl,
  });

  final String uid;
  final String? email;
  final String? displayName;
  final bool? isEmailVerified;
  final String? photoUrl;

  static User fromFirebaseUser(FirebaseUser user) {
    return User(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      isEmailVerified: user.isEmailVerified,
      photoUrl: user.photoUrl,
    );
  }
}
