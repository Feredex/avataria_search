import 'package:avataria_search/src/widgets/auto_icon_button.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileCard extends StatelessWidget {
  final String nickname;
  final int id;
  final int level;
  final int imagePoints;
  final int comfortPoints;
  final String? name;
  final int? age;
  final String description;
  final String? countryName;
  final String? regionName;
  final String? cityName;
  final String? contacts;
  final String characterImageUrl;
  final void Function() onViewPassportButtonPressed;
  final void Function()? onAddToFriendsButtonPressed;

  ProfileCard({
    required this.nickname,
    required this.id,
    required this.level,
    required this.imagePoints,
    required this.comfortPoints,
    this.name,
    this.age,
    required this.description,
    this.countryName,
    this.regionName,
    this.cityName,
    this.contacts,
    required this.characterImageUrl,
    required this.onViewPassportButtonPressed,
    required this.onAddToFriendsButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 7 / 4,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white.withOpacity(0.2),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(characterImageUrl),
                          fit: BoxFit.fitHeight,
                          alignment: FractionalOffset.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                nickname,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                        color: Theme.of(context).accentColor),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ID: $id',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            color:
                                                Theme.of(context).accentColor),
                                  ),
                                  SizedBox(width: 10.0),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 18.0,
                                    icon: FaIcon(FontAwesomeIcons.idBadge),
                                    color: Theme.of(context).accentColor,
                                    constraints: BoxConstraints(),
                                    onPressed: onViewPassportButtonPressed,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _PointsWithIconRow(
                                    icon: FontAwesomeIcons.solidStar,
                                    points: level,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _PointsWithIconRow(
                                    icon: FontAwesomeIcons.crown,
                                    points: imagePoints,
                                  ),
                                  _PointsWithIconRow(
                                    icon: FontAwesomeIcons.home,
                                    points: comfortPoints,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              children: [
                                if (name != null || age != null)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      _nameAgeText,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .accentColor),
                                    ),
                                  ),
                                if (countryName != null ||
                                    regionName != null ||
                                    cityName != null)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      _addressText,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .accentColor),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    description,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            color:
                                                Theme.of(context).accentColor),
                                  ),
                                ),
                                if (contacts != null)
                                  Text(
                                    contacts!,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            color:
                                                Theme.of(context).accentColor),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (onAddToFriendsButtonPressed != null)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                      ),
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                    height: 50.0,
                    width: 50.0,
                    child: AutoIconButton(
                      disabledColor: Colors.transparent,
                      icon: Icon(
                        Icons.person_add,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: onAddToFriendsButtonPressed!,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String get _nameAgeText {
    return '${name ?? ''}'
        '${name != null && age != null ? ', ' : ''}'
        '${age != null ? '$age лет' : ''}';
  }

  String get _addressText {
    final cityText = cityName != null ? '$cityName, ' : '';
    final regionText = regionName != null ? '$regionName, ' : '';
    final countryText = countryName ?? '';
    return '$cityText$regionText$countryText';
  }
}

class _PointsWithIconRow extends StatelessWidget {
  final IconData icon;
  final int points;

  _PointsWithIconRow({required this.icon, required this.points});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FaIcon(icon, size: 18.0, color: Theme.of(context).accentColor),
        SizedBox(width: 2.0),
        Text(
          points < 1000 ? '$points' : '${(points / 1000).toStringAsFixed(1)}k',
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Theme.of(context).accentColor),
        )
      ],
    );
  }
}
