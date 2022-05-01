import 'package:avataria_search/src/services/place_service.dart';

class Profile {
  final String userId;
  final Character? character;
  final Player? player;

  const Profile({
    required this.userId,
    this.character,
    this.player,
  });

  Map<String, dynamic> toMap() => {
        'character': character?.toMap(),
        'player': player?.toMap(),
      };

  Profile.fromMap(String userId, Map<String, dynamic> map)
      : userId = userId,
        character = map['character'] != null
            ? Character.fromMap(map['character'])
            : null,
        player = map['player'] != null ? Player.fromMap(map['player']) : null;
}

class Character {
  final String? nickname;
  final String? searchNickname;
  final int? id;
  final int? level;
  final int? imagePoints;
  final int? comfortPoints;
  final Gender? gender;

  const Character({
    this.nickname,
    this.searchNickname,
    this.id,
    this.level,
    this.imagePoints,
    this.comfortPoints,
    this.gender,
  });

  Map<String, dynamic> toMap() => {
        'nickname': nickname,
        'searchNickname': searchNickname,
        'id': id,
        'level': level,
        'imagePoints': imagePoints,
        'comfortPoints': comfortPoints,
        'gender': gender?.value,
      };

  Character.fromMap(Map<String, dynamic> map)
      : nickname = map['nickname'],
        searchNickname = map['searchNickname'],
        id = map['id'],
        level = map['level'],
        imagePoints = map['imagePoints'],
        comfortPoints = map['comfortPoints'],
        gender = Gender(map['gender']);
}

class Player {
  final String name;
  final int age;
  final String description;
  final Address? address;
  final Gender gender;
  final String? contacts;

  const Player({
    required this.name,
    required this.age,
    required this.description,
    this.address,
    required this.gender,
    this.contacts,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'age': age,
        'description': description,
        'address': address?.toMap(),
        'gender': gender.value,
        'contacts': contacts,
      };

  Player.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        age = map['age'],
        description = map['description'],
        address =
            map['address'] != null ? Address.fromMap(map['address']) : null,
        gender = Gender(map['gender']),
        contacts = map['contacts'];
}

class Address {
  final Country? country;
  final Region? region;
  final City? city;

  const Address({
    this.country,
    this.region,
    this.city,
  });

  Map<String, dynamic> toMap() => {
        'country': country?.toMap(),
        'region': region?.toMap(),
        'city': city?.toMap(),
      };

  Address.fromMap(Map<String, dynamic> map)
      : country =
            map['country'] != null ? Country.fromMap(map['country']) : null,
        region = map['region'] != null ? Region.fromMap(map['region']) : null,
        city = map['city'] != null ? City.fromMap(map['city']) : null;
}

class Gender {
  const Gender(this.value) : assert(value == null || value == 0 || value == 1);

  final int? value;

  static const undefined = Gender(null);
  static const male = Gender(0);
  static const female = Gender(1);

  @override
  String toString() {
    switch (value) {
      case 0:
        return 'Парень';
      case 1:
        return 'Девушка';
      default:
        return 'Неизвестный пол';
    }
  }

  @override
  bool operator ==(o) => o is Gender && o.value == value;

  @override
  int get hashCode => value.hashCode;
}
