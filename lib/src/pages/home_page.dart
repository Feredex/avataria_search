import 'dart:ui';

import 'package:avataria_search/src/constants.dart';
import 'package:avataria_search/src/pages/friends_section.dart';
import 'package:avataria_search/src/pages/profile_section.dart';
import 'package:avataria_search/src/pages/search_section.dart';
import 'package:avataria_search/src/widgets/avataria_search_app_bar.dart';
import 'package:avataria_search/src/widgets/avataria_search_background.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedNavBarItemIndex = 1;

  static const _friendsSectionTabs = [
    Tab(child: Text('ПРИЯТЕЛИ')),
    Tab(child: Text('ВХОДЯЩИЕ ЗАЯВКИ')),
    Tab(child: Text('ИСХОДЯЩИЕ ЗАЯВКИ')),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _friendsSectionTabs.length,
      child: Scaffold(
        appBar: AvatariaSearchAppBar(
          bottom: _selectedNavBarItemIndex == 0
              ? TabBar(
                  tabs: _friendsSectionTabs,
                )
              : null,
        ),
        extendBodyBehindAppBar: true,
        extendBody: true,
        bottomNavigationBar: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: kBlur, sigmaY: kBlur),
            child: BottomNavigationBar(
              elevation: kElevation,
              currentIndex: _selectedNavBarItemIndex,
              onTap: (index) =>
                  setState(() => _selectedNavBarItemIndex = index),
              backgroundColor: Colors.transparent,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Приятели',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Поиск',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Профиль',
                ),
              ],
            ),
          ),
        ),
        body: AvatariaSearchBackground(child: _getSection()),
      ),
    );
  }

  Widget _getSection() {
    switch (_selectedNavBarItemIndex) {
      case 0:
        return FriendsSection();
      case 1:
        return SearchSection();
      case 2:
        return ProfileSection();
      default:
        return Container();
    }
  }
}
