import 'package:flutter/material.dart';

import 'package:clipboard/clipboard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:avataria_search/src/models/user.dart';
import 'package:avataria_search/src/pages/passport_view_page.dart';
import 'package:avataria_search/src/services/firebase_auth_service.dart';
import 'package:avataria_search/src/services/firebase_storage_service.dart';
import 'package:avataria_search/src/widgets/profile_card.dart';
import 'package:avataria_search/src/constants.dart';
import 'package:avataria_search/src/models/profile.dart';
import 'package:avataria_search/src/models/profile_change_notifier.dart';
import 'package:avataria_search/src/pages/profile_filling_page.dart';

class ProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: kHorizontalPadding,
          right: kHorizontalPadding,
          top: kAppBarHeight + kSectionVerticalPadding,
          bottom: kBottomNavigationBarHeight + kSectionVerticalPadding,
        ),
        child: Container(
          width: double.infinity,
          child: Consumer<ProfileChangeNotifier>(
            builder: (context, notifier, _) {
              final profile = notifier.profile;
              return Column(
                children: [
                  SizedBox(
                    width: kBodyWidth,
                    child: FutureBuilder<Uri>(
                      future: FirebaseStorageService.getPhotoUri(
                        FirebaseStoragePath.character(profile!.userId),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ProfileCard(
                            nickname: profile.character.nickname,
                            id: profile.character.id,
                            level: profile.character.level,
                            imagePoints: profile.character.imagePoints,
                            comfortPoints: profile.character.comfortPoints,
                            name: profile.player.name,
                            age: profile.player.age,
                            description: profile.player!.description!,
                            countryName: profile.player?.address?.country?.name,
                            regionName: profile.player?.address?.region?.name,
                            cityName: profile.player?.address?.city?.name,
                            contacts: profile.player!.contacts,
                            characterImageUrl: snapshot.data.toString(),
                            onViewPassportButtonPressed: () =>
                                _onViewPassportButtonPressed(context),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 25.0),
                  RaisedButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text('РЕДАКТИРОВАТЬ'),
                    onPressed: () =>
                        _onEditProfileButtonPressed(context, profile),
                  ),
                  SizedBox(height: 25.0),
                  RaisedButton.icon(
                    icon: Icon(Icons.share),
                    label: Text('РАССКАЗАТЬ ДРУЗЬЯМ'),
                    onPressed: () => _onShareButtonPressed(
                      context,
                      profile.character!.nickname!,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton.icon(
                    icon: FaIcon(FontAwesomeIcons.vk),
                    label: Text('ГРУППА ВКОНТАКТЕ'),
                    onPressed: _onOpenVkGroupButtonPressed,
                  ),
                  SizedBox(height: 25.0),
                  RaisedButton.icon(
                    icon: Icon(Icons.exit_to_app),
                    label: Text('ВЫЙТИ'),
                    onPressed: () => _onSignOutButtonPressed(context),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _onEditProfileButtonPressed(BuildContext context, Profile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileFillingPage(existingProfile: profile),
      ),
    );
  }

  void _onViewPassportButtonPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassportViewPage(
          userId: Provider.of<User>(context).uid,
        ),
      ),
    );
  }

  Future<void> _onShareButtonPressed(
      BuildContext context, String nickname) async {
    await FlutterClipboard.copy(
      'Находи игроков в мобильной Аватарии вместе с $nickname в AvatariaSearch! '
      'https://avataria-search.web.app/',
    );
    _showSharingDialog(context);
  }

  Future<void> _onOpenVkGroupButtonPressed() async {
    const url = 'https://vk.com/avataria.search';
    if (await canLaunch(url)) {
      launch(url);
    }
  }

  void _onSignOutButtonPressed(BuildContext context) {
    Provider.of<FirebaseAuthService>(context, listen: false).signOut();
  }

  void _showSharingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Отправь друзьям сообщение из буфера обмена'),
        content: SingleChildScrollView(
          child: Text(
            'Мы скопировали в буфер обмена сообщение о сайте для твоих друзей! '
            'Чтобы поделиться им, нажми и удерживай поле, '
            'в которое хочешь вставить сообщение, потом нажми "Вставить", '
            'а затем отправь его.',
          ),
        ),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
