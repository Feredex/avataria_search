class FriendRequest {
  final String? id;
  final Friend? from;
  final Friend? to;
  final bool? accepted;
  final List? userIds;

  FriendRequest({
    this.id,
    this.from,
    this.to,
    this.accepted = false,
    this.userIds,
  });

  Map<String, dynamic> toMap() => {
        'from': from?.toMap(),
        'to': to?.toMap(),
        'accepted': accepted,
        'userIds': userIds,
      };

  FriendRequest.fromMap(String id, Map<String, dynamic> map)
      : from = Friend.fromMap(map['from']),
        to = Friend.fromMap(map['to']),
        accepted = map['accepted'],
        id = id,
        userIds = map['userIds'];

  Friend? getUserFriend(String userId) {
    if (from?.id == userId) {
      return to;
    } else if (to?.id == userId) {
      return from;
    } else {
      return null;
    }
  }
}

class Friend {
  final String? id;
  final String? nickname;

  Friend({this.id, this.nickname});

  Map<String, dynamic> toMap() => {
        'id': id,
        'nickname': nickname,
      };

  Friend.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        nickname = map['nickname'];
}
