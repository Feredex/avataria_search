import 'dart:async';

import 'package:avataria_search/src/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:avataria_search/src/models/profile.dart';
import 'package:avataria_search/src/services/firestore_database.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  DocumentSnapshot? _profileDocument;
  bool _loading = true;
  late StreamSubscription<DocumentSnapshot> _profileStreamSubscription;

  Profile? get profile {
    return _profileDocument?.data != null
        ? Profile.fromMap(_profileDocument!.documentID, _profileDocument!.data)
        : null;
  }

  bool? get profileExists => _profileDocument?.exists;

  bool get loading => _loading;

  ProfileChangeNotifier(String userId) {
    _profileStreamSubscription =
        FirestoreService.documentStream(path: FirestorePath.profile(userId))
            .listen(_onProfileUpdate);
  }

  void _onProfileUpdate(DocumentSnapshot updatedProfile) {
    _profileDocument = updatedProfile;
    _loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _profileStreamSubscription.cancel();
    super.dispose();
  }
}
