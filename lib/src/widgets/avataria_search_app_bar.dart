import 'dart:ui';

import 'package:avataria_search/src/constants.dart';
import 'package:flutter/material.dart';

class AvatariaSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool hasBackButton;
  final PreferredSizeWidget? bottom;

  AvatariaSearchAppBar({this.hasBackButton = false, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: kElevation,
      toolbarHeight: bottom != null ? kAppBarHeight + 46.0 : kAppBarHeight,
      centerTitle: true,
      bottom: bottom,
      title: SizedBox(
        height: bottom != null ? kAppBarHeight + 46.0 : kAppBarHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: kBlur, sigmaY: kBlur),
                child: Container(),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/logo-full.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  height: kAppBarLogoHeight,
                ),
              ),
            ),
            if (hasBackButton)
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        bottom != null ? kAppBarHeight + 46.0 : kAppBarHeight,
      );
}

class AvatariaSearchSliverAppBar extends StatelessWidget {
  final bool hasBackButton;

  AvatariaSearchSliverAppBar({this.hasBackButton = false});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: kElevation,
      centerTitle: true,
      pinned: true,
      toolbarHeight: kAppBarHeight,
      backgroundColor: Colors.transparent,
      title: SizedBox(
        height: kAppBarHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: kBlur, sigmaY: kBlur),
                child: Container(),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/logo-full.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  height: kAppBarLogoHeight,
                ),
              ),
            ),
            if (hasBackButton)
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
