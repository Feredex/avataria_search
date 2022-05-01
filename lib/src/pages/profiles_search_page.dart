import 'package:avataria_search/src/constants.dart';
import 'package:avataria_search/src/models/profile.dart';
import 'package:avataria_search/src/models/profile_change_notifier.dart';
import 'package:avataria_search/src/models/request.dart';
import 'package:avataria_search/src/pages/passport_view_page.dart';
import 'package:avataria_search/src/services/firebase_storage_service.dart';
import 'package:avataria_search/src/services/firestore_database.dart';
import 'package:avataria_search/src/widgets/avataria_search_app_bar.dart';
import 'package:avataria_search/src/widgets/avataria_search_background.dart';
import 'package:avataria_search/src/widgets/profile_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilesSearchPage extends StatelessWidget {
  final int characterId;
  final Gender characterGender;
  final String characterNickname;
  final bool characterNicknameExtendedSearch;
  final int characterLevel;
  final int characterLevelFrom;
  final int characterLevelTo;
  final Gender playerGender;
  final int playerAge;
  final int playerAgeFrom;
  final int playerAgeTo;
  final String countryIso;
  final int regionId;
  final int cityId;
  final DocumentSnapshot startAfter;

  ProfilesSearchPage({
    this.characterId,
    this.characterGender,
    this.characterNickname,
    this.characterLevel,
    this.characterLevelFrom,
    this.characterLevelTo,
    this.playerGender,
    this.playerAge,
    this.playerAgeFrom,
    this.playerAgeTo,
    this.countryIso,
    this.regionId,
    this.cityId,
    this.startAfter,
    this.characterNicknameExtendedSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AvatariaSearchAppBar(hasBackButton: true),
      extendBodyBehindAppBar: true,
      body: AvatariaSearchBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: kHorizontalPadding,
              right: kHorizontalPadding,
              top: kAppBarHeight + kSectionVerticalPadding,
              bottom: kBottomNavigationBarHeight + kSectionVerticalPadding,
            ),
            child: Container(
              width: double.infinity,
              child: Column(
                children: _buildBodyWidgets(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBodyWidgets(BuildContext context) {
    return [
      Text(
        'Результаты поиска',
        style: Theme.of(context)
            .textTheme
            .headline5
            .copyWith(color: Theme.of(context).accentColor),
      ),
      SizedBox(height: 25.0),
      FutureBuilder<List<DocumentSnapshot>>(
        future: FirestoreDatabase.searchForProfiles(
          characterId: characterId,
          characterGender: characterGender,
          characterNickname: characterNickname,
          characterNicknameExtendedSearch: characterNicknameExtendedSearch,
          characterLevel: characterLevel,
          characterLevelFrom: characterLevelFrom,
          characterLevelTo: characterLevelTo,
          playerAge: playerAge,
          playerAgeFrom: playerAgeFrom,
          playerAgeTo: playerAgeTo,
          playerGender: playerGender,
          countryIso: countryIso,
          regionId: regionId,
          cityId: cityId,
          startAfter: startAfter,
        ),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Произошла ошибка при загрузке: ${snapshot.error}',
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null || snapshot.data.isEmpty) {
              return const Center(
                child: Text('Игроков не надено :('),
              );
            }
            final profiles = snapshot.data
                .map((doc) => Profile.fromMap(doc.documentID, doc.data))
                .toList();
            return SizedBox(
              width: kBodyWidth,
              child: Column(
                children: [
                  for (int i = 0; i < profiles.length; i++)
                    _buildProfileCard(profiles[i], i),
                  if (profiles.length == FirestoreDatabase.profilesPerPage)
                    RaisedButton(
                      child: Text('СЛЕДУЮЩАЯ СТРАНИЦА'),
                      onPressed: () => _onNextPageButtonPressed(
                        context,
                        snapshot.data.last,
                      ),
                    ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    ];
  }

  Widget _buildProfileCard(Profile profile, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kProfileListPadding),
      child: FutureBuilder<Uri>(
        future: FirebaseStorageService.getPhotoUri(
          FirebaseStoragePath.character(profile.userId),
        ),
        builder: (context, imageSnapshot) {
          if (imageSnapshot.connectionState == ConnectionState.done) {
            return ProfileCard(
              nickname: profile.character.nickname,
              id: profile.character.id,
              level: profile.character.level,
              imagePoints: profile.character.imagePoints,
              comfortPoints: profile.character.comfortPoints,
              description: profile.player.description,
              characterImageUrl: imageSnapshot.data.toString(),
              onViewPassportButtonPressed: () => _onViewPassportButtonPressed(
                context,
                profile.userId,
              ),
              onAddToFriendsButtonPressed: profile.userId !=
                      Provider.of<ProfileChangeNotifier>(context).profile.userId
                  ? () => _onAddToFriendsButtonPressed(context, profile, index)
                  : null,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Future<void> _onAddToFriendsButtonPressed(
    BuildContext context,
    Profile profile,
    int index,
  ) async {
    final userProfile =
        Provider.of<ProfileChangeNotifier>(context, listen: false).profile;
    await FirestoreDatabase.sendFriendRequest(
      FriendRequest(
        from: Friend(
          id: userProfile.userId,
          nickname: userProfile.character.nickname,
        ),
        to: Friend(
          id: profile.userId,
          nickname: profile.character.nickname,
        ),
        userIds: [userProfile.userId, profile.userId],
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Запрос в друзья игроку ${profile.character.nickname} отправлен',
          ),
        ),
      );
  }

  void _onViewPassportButtonPressed(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassportViewPage(userId: userId),
      ),
    );
  }

  void _onNextPageButtonPressed(
    BuildContext context,
    DocumentSnapshot startAfter,
  ) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilesSearchPage(
          characterId: characterId,
          characterGender: characterGender,
          characterNickname: characterNickname,
          characterNicknameExtendedSearch: characterNicknameExtendedSearch,
          characterLevel: characterLevel,
          characterLevelFrom: characterLevelFrom,
          characterLevelTo: characterLevelTo,
          playerAge: playerAge,
          playerAgeFrom: playerAgeFrom,
          playerAgeTo: playerAgeTo,
          playerGender: playerGender,
          countryIso: countryIso,
          regionId: regionId,
          cityId: cityId,
          startAfter: startAfter,
        ),
      ),
    );
  }
}
