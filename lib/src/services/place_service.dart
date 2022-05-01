import 'dart:convert';
import 'dart:math';

import 'package:avataria_search/src/models/secret.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  final String authority;
  final Map<String, String>? defaultParameters;

  const NetworkHelper(
    this.authority, [
    this.defaultParameters,
  ]);

  Future<dynamic> getData(
    String path, [
    Map<String, String>? parameters,
  ]) async {
    final response = await http.get(
      Uri.http(authority, path, {...?parameters, ...?defaultParameters}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data with a response: ${response.body}');
    }
  }
}

class PlaceService {
  final NetworkHelper _networkHelper;

  static const _paginationLimit = 50;

  PlaceService._(String apiKey)
      : _networkHelper = NetworkHelper('geohelper.info', {
          'apiKey': apiKey,
          'locale[lang]': 'ru',
          'locale[fallbackLang]': 'en',
          'pagination[page]': '1',
          'pagination[limit]': '$_paginationLimit',
        });

  static Future<PlaceService> create() async {
    final apiKey = await SecretLoader.load('geohelper_api_key');
    return PlaceService._(apiKey);
  }

  _getUriMethodPath(String methodName) => '/api/v1/$methodName';

  Future<List<Country>> getCountries(
      {required String name, required String iso}) async {
    final json = await _networkHelper.getData(
      _getUriMethodPath('countries'),
      {
        'filter[name]': name,
        'filter[iso]': iso,
      },
    );
    return List.generate(
      json['pagination']['totalCount'],
      (index) => Country.fromMap(json['result'][index]),
    );
  }

  Future<List<Region>> getRegions(
      {required int id,
      required String name,
      required String countryIso}) async {
    final json = await _networkHelper.getData(
      _getUriMethodPath('regions'),
      {
        'filter[id]': '$id',
        'filter[name]': name,
        'filter[countryIso]': countryIso,
      },
    );
    final totalCount = json['pagination']['totalCount'];
    return List.generate(
      min(totalCount, _paginationLimit),
      (index) => Region.fromMap(json['result'][index]),
    );
  }

  Future<List<City>> getCities(
      {required int id,
      required String name,
      required String countryIso,
      required int regionId}) async {
    final json = await _networkHelper.getData(
      _getUriMethodPath('cities'),
      {
        'filter[id]': '$id',
        'filter[name]': name,
        'filter[countryIso]': countryIso,
        'filter[regionId]': '$regionId',
      },
    );
    final totalCount = json['pagination']['totalCount'];
    return List.generate(
      min(totalCount, _paginationLimit),
      (index) => City.fromMap(json['result'][index]),
    );
  }
}

class Country {
  final String name;
  final String? iso;

  const Country({required this.name, this.iso});

  Country.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        iso = map['iso'];

  Map<String, dynamic> toMap() => {
        'name': name,
        'iso': iso,
      };

  @override
  String toString() => name;

  @override
  operator ==(o) => o is Country && o.name == name && o.iso == iso;

  @override
  int get hashCode => name.hashCode ^ iso.hashCode;
}

class Region {
  final int id;
  final String name;

  const Region({required this.id, required this.name});

  Region.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  @override
  String toString() => name;

  @override
  operator ==(o) => o is Region && o.id == id && o.name == name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class City {
  final int id;
  final String name;
  final LocalityType? localityType;
  final String? area;

  const City(
      {required this.id, required this.name, this.localityType, this.area});

  City.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        localityType = map['localityType'] != null
            ? LocalityType.fromMap(map['localityType'])
            : null,
        area = map['area'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'localityType': localityType?.toMap(),
        'area': area,
      };

  @override
  String toString() => '${localityType != null ? '$localityType ' : ''}$name';

  @override
  operator ==(o) =>
      o is City &&
      o.id == id &&
      o.name == name &&
      o.localityType == localityType &&
      o.area == area;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ localityType.hashCode ^ area.hashCode;
}

class LocalityType {
  final String name;

  LocalityType({required this.name});

  LocalityType.fromMap(Map<String, dynamic> map) : name = map['name'];

  Map<String, dynamic> toMap() => {
        'name': name,
      };

  @override
  String toString() => name;

  @override
  bool operator ==(o) => o is LocalityType && o.name == name;

  @override
  int get hashCode => name.hashCode;
}
