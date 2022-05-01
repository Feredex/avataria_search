import 'package:avataria_search/src/constants.dart';
import 'package:avataria_search/src/models/profile_change_notifier.dart';
import 'package:avataria_search/src/models/request.dart';
import 'package:avataria_search/src/models/user.dart';
import 'package:avataria_search/src/services/firestore_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        _buildFriendsList(context),
        _buildIngoingRequestsList(context),
        _buildOutgoingRequestsList(context),
      ],
    );
  }

  Widget _buildBase({required Widget child}) {
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
          child: child,
        ),
      ),
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    return _buildBase(
      child: StreamBuilder<List<FriendRequest>>(
        stream: FirestoreDatabase.getAcceptedIngoingFriendRequests(
          Provider.of<ProfileChangeNotifier>(context).profile.userId,
        ),
        builder: (context, list1) {
          if (list1.hasError) {
            return Center(child: Text(list1.error.toString()));
          }
          return StreamBuilder<List<FriendRequest>>(
            stream: FirestoreDatabase.getAcceptedOutgoingFriendRequests(
              Provider.of<ProfileChangeNotifier>(context).profile.userId,
            ),
            builder: (context, list2) {
              if (list2.hasError) {
                return Center(child: Text(list1.error.toString()));
              }
              if (!list1.hasData || !list2.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (list1.data.isEmpty && list2.data.isEmpty) {
                  return Center(child: Text('Нет приятелей!'));
                }
                final requests = [...list1.data, ...list2.data];
                return Column(
                  children: [
                    for (final request in requests)
                      Container(
                        width: kBodyWidth,
                        padding:
                            const EdgeInsets.only(bottom: kProfileListPadding),
                        child: ListTile(
                          title: Text(
                            request
                                .getUserFriend(Provider.of<User>(context).uid)
                                .nickname,
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.person_remove),
                            onPressed: () =>
                                FirestoreDatabase.cancelFriendRequest(
                              request.id,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildIngoingRequestsList(BuildContext context) {
    return _buildBase(
      child: StreamBuilder<List<FriendRequest>>(
        stream: FirestoreDatabase.getIngoingFriendRequests(
          Provider.of<User>(context).uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return Center(child: Text('Нет входящих заявок!'));
            }
            return Column(
              children: [
                for (final request in snapshot.data)
                  Container(
                    width: kBodyWidth,
                    padding: const EdgeInsets.only(bottom: kProfileListPadding),
                    child: ListTile(
                      title: Text(request.from.nickname),
                      trailing: SizedBox(
                        width: 100.0,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.person_add),
                              onPressed: () =>
                                  FirestoreDatabase.acceptFriendRequest(
                                request.id,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.person_remove),
                              onPressed: () =>
                                  FirestoreDatabase.cancelFriendRequest(
                                request.id,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildOutgoingRequestsList(BuildContext context) {
    return _buildBase(
      child: StreamBuilder<List<FriendRequest>>(
        stream: FirestoreDatabase.getOutgoingFriendRequests(
          Provider.of<User>(context).uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return Center(child: Text('Нет исходящих заявок!'));
            }
            return Column(
              children: [
                for (final request in snapshot.data)
                  Container(
                    width: kBodyWidth,
                    padding: const EdgeInsets.only(bottom: kProfileListPadding),
                    child: ListTile(
                      title: Text(request.to.nickname),
                      trailing: IconButton(
                        icon: Icon(Icons.person_remove),
                        onPressed: () => FirestoreDatabase.cancelFriendRequest(
                          request.id,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
