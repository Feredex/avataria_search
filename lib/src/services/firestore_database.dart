import 'package:avataria_search/src/models/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:avataria_search/src/models/profile.dart';
import 'package:avataria_search/src/services/firestore_service.dart';

import 'package:async/async.dart';

class FirestoreDatabase {
  static Future<void> createProfile(
      {required Profile profile, required String userId}) {
    return FirestoreService.setDocumentData(
      path: FirestorePath.profile(userId),
      data: profile.toMap(),
    );
  }

  static Future<void> deleteProfile(String userId) {
    return FirestoreService.deleteDocument(
      path: FirestorePath.profile(userId),
    );
  }

  static Stream<Profile?> profileStream(String userId) {
    return FirestoreService.documentStream(path: FirestorePath.profile(userId))
        .map(
      (profileDocument) => profileDocument.exists
          ? Profile.fromMap(
              profileDocument.documentID,
              profileDocument.data,
            )
          : null,
    );
  }

  static Future<void> acceptFriendRequest(String requestId) {
    return FirestoreService.updateDocument(
      path: FirestorePath.request(requestId),
      data: {
        'accepted': true,
      },
    );
  }

  static Future<void> sendFriendRequest(FriendRequest request) {
    return FirestoreService.createDocument(
      collectionPath: FirestorePath.requests,
      data: request.toMap(),
    );
  }

  static Future<void> cancelFriendRequest(String requestId) {
    return FirestoreService.deleteDocument(
      path: FirestorePath.request(requestId),
    );
  }

  // TODO: разложить на несколько функций (без StreamZip)
  static Stream<bool> requestExists(String userId, String friendId) {
    final stream1 = FirestoreService.collectionStream(
      path: FirestorePath.requests,
      queryBuilder: (query) => query
          .where('from.id', isEqualTo: userId)
          .where('to.id', isEqualTo: friendId)
          .limit(1),
    );
    final stream2 = FirestoreService.collectionStream(
      path: FirestorePath.requests,
      queryBuilder: (query) => query
          .where('from.id', isEqualTo: friendId)
          .where('to.id', isEqualTo: userId)
          .limit(1),
    );
    final streamGroup = StreamZip([stream1, stream2]).asBroadcastStream();
    return streamGroup.map((lists) => lists.any((docs) => docs.isNotEmpty));
  }

  static Stream<List<FriendRequest>> getOutgoingFriendRequests(String userId) {
    final stream = FirestoreService.collectionStream(
      path: FirestorePath.requests,
      queryBuilder: (query) => query
          .where('from.id', isEqualTo: userId)
          .where('accepted', isEqualTo: false),
    );
    return stream.map((docs) => docs
        .map((doc) => FriendRequest.fromMap(doc.documentID, doc.data))
        .toList());
  }

  static Stream<List<FriendRequest>> getIngoingFriendRequests(String userId) {
    final stream = FirestoreService.collectionStream(
      path: FirestorePath.requests,
      queryBuilder: (query) => query
          .where('to.id', isEqualTo: userId)
          .where('accepted', isEqualTo: false),
    );
    return stream.map((docs) => docs
        .map((doc) => FriendRequest.fromMap(doc.documentID, doc.data))
        .toList());
  }

  static Stream<List<FriendRequest>> getAcceptedIngoingFriendRequests(
      String userId) {
    final stream = FirestoreService.collectionStream(
      path: FirestorePath.requests,
      queryBuilder: (query) => query
          .where('to.id', isEqualTo: userId)
          .where('accepted', isEqualTo: true),
    );
    return stream.map((docs) => docs
        .map((doc) => FriendRequest.fromMap(doc.documentID, doc.data))
        .toList());
  }

  static Stream<List<FriendRequest>> getAcceptedOutgoingFriendRequests(
      String userId) {
    final stream = FirestoreService.collectionStream(
      path: FirestorePath.requests,
      queryBuilder: (query) => query
          .where('from.id', isEqualTo: userId)
          .where('accepted', isEqualTo: true),
    );
    return stream.map((docs) => docs
        .map((doc) => FriendRequest.fromMap(doc.documentID, doc.data))
        .toList());
  }

  static const profilesPerPage = 5;

  static Future<List<DocumentSnapshot>> searchForProfiles({
    int? characterId,
    Gender? characterGender,
    String? characterNickname,
    bool characterNicknameExtendedSearch = false,
    int? characterLevel,
    int? characterLevelFrom,
    int? characterLevelTo,
    Gender? playerGender,
    int? playerAge,
    int? playerAgeFrom,
    int? playerAgeTo,
    String? countryIso,
    int? regionId,
    int? cityId,
    DocumentSnapshot? startAfter,
  }) async {
    final documents = await FirestoreService.getCollection(
      path: FirestorePath.profiles,
      queryBuilder: (query) {
        if (characterId != null) {
          query = query.where('character.id', isEqualTo: characterId);
        }
        if (characterGender?.value != null) {
          query = query.where(
            'character.gender',
            isEqualTo: characterGender?.value,
          );
        }
        if (characterNickname != null) {
          if (characterNicknameExtendedSearch) {
            query = query
                .where(
                  'character.searchNickname',
                  isGreaterThanOrEqualTo: characterNickname,
                )
                .where(
                  'character.searchNickname',
                  isLessThanOrEqualTo: characterNickname + '\uf8ff',
                );
          } else {
            query = query.where(
              'character.searchNickname',
              isEqualTo: characterNickname,
            );
          }
        }
        if (characterLevelFrom != null || characterLevelTo != null) {
          if (characterLevelFrom != null) {
            query = query.where(
              'character.level',
              isGreaterThanOrEqualTo: characterLevelFrom,
            );
          }
          if (characterLevelTo != null) {
            query = query.where(
              'character.level',
              isLessThanOrEqualTo: characterLevelTo,
            );
          }
        } else if (characterLevel != null) {
          query = query.where('character.level', isEqualTo: characterLevel);
        }
        if (playerGender?.value != null) {
          query = query.where('player.gender', isEqualTo: playerGender?.value);
        }
        if (playerAgeFrom != null || playerAgeTo != null) {
          if (playerAgeFrom != null) {
            query = query.where(
              'player.age',
              isGreaterThanOrEqualTo: playerAgeFrom,
            );
          }
          if (playerAgeTo != null) {
            query = query.where(
              'player.age',
              isLessThanOrEqualTo: playerAgeTo,
            );
          }
        } else if (playerAge != null) {
          query = query.where('player.age', isEqualTo: playerAge);
        }
        if (countryIso != null) {
          query = query.where(
            'player.address.country.iso',
            isEqualTo: countryIso,
          );
        }
        if (regionId != null) {
          query = query.where('player.address.region.id', isEqualTo: regionId);
        }
        if (cityId != null) {
          query = query.where('player.address.city.id', isEqualTo: cityId);
        }
        if (startAfter != null) {
          query = query.startAfterDocument(startAfter);
        }
        return query.limit(profilesPerPage);
      },
    );
    return documents;
  }
}

class FirestorePath {
  static String profile(String userId) => 'profiles/$userId';
  static const profiles = 'profiles';

  static String request(String id) => 'requests/$id';
  static const requests = 'requests';
}
