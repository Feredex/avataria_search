import 'package:avataria_search/src/constants.dart';
import 'package:avataria_search/src/models/profile.dart';
import 'package:avataria_search/src/models/profile_change_notifier.dart';
import 'package:avataria_search/src/pages/profiles_search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchSection extends StatefulWidget {
  @override
  _SearchSectionState createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final _idController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _levelController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Gender _characterGender = Gender.undefined;
  Gender _playerGender = Gender.undefined;
  final _ageController = TextEditingController();
  final _ageFromController = TextEditingController();
  final _ageToController = TextEditingController();
  StringSearchMode _nicknameSearchMode = StringSearchMode.values.first;
  bool _fromCountry = false;
  bool _fromRegion = false;
  bool _fromCity = false;
  SearchOption _ageSearchOption = SearchOption.values.first;
  SearchOption _levelSearchOption = SearchOption.values.first;
  final _levelFromController = TextEditingController();
  final _levelToController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _nicknameController.dispose();
    _levelController.dispose();
    _ageController.dispose();
    _ageFromController.dispose();
    _ageToController.dispose();
    _levelFromController.dispose();
    _levelToController.dispose();
    super.dispose();
  }

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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: kBodyWidth,
                  child: ListTile(
                    leading: Icon(
                      Icons.info,
                      color: Theme.of(context).accentColor,
                    ),
                    title: Text(
                      'Ограничения по поиску',
                      style: TextStyle(
                        color: Theme.of(context).accentColor.withOpacity(0.7),
                      ),
                    ),
                    subtitle: Text(
                      'Возможно использовать только один расширенный '
                      'поиск ("По началу строки", "Диапазон значений") за запрос. ',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: kBodyWidth,
                  child: _buildFormWidgets(context),
                ),
                SizedBox(height: 10),
                RaisedButton.icon(
                  icon: Icon(Icons.search),
                  label: Text('ИСКАТЬ'),
                  onPressed: () => _onSearchButtonPressed(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormWidgets(BuildContext context) {
    final Profile profile =
        Provider.of<ProfileChangeNotifier>(context).profile!;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Данные персонажа',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Theme.of(context).accentColor.withOpacity(0.7),
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: TextFormField(
            controller: _idController,
            decoration: InputDecoration(hintText: 'ID'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final val = value.trim();
                if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                  return 'ID может содержать только цифры';
                } else if (val.length > 20) {
                  return 'Слишком длинный ID';
                }
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Пол',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Theme.of(context).accentColor),
              ),
              RadioListTile<Gender>(
                onChanged: (value) => setState(() => _characterGender = value!),
                groupValue: _characterGender,
                value: Gender.undefined,
                title: Text(
                  'Неважно',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
              RadioListTile<Gender>(
                onChanged: (value) => setState(() => _characterGender = value!),
                groupValue: _characterGender,
                value: Gender.male,
                title: Text(
                  'Парень',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
              RadioListTile<Gender>(
                onChanged: (value) => setState(() => _characterGender = value!),
                groupValue: _characterGender,
                value: Gender.female,
                title: Text(
                  'Девушка',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            'Ник',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Theme.of(context).accentColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
              DropdownButtonFormField(
                value: _nicknameSearchMode,
                decoration: InputDecoration(),
                onChanged: (StringSearchMode? mode) => setState(() {
                  if (mode != null) {
                    _nicknameSearchMode = mode;
                    if (mode == StringSearchMode.fromStart) {
                      _ageSearchOption = SearchOption.exactValue;
                      _levelSearchOption = SearchOption.exactValue;
                    }
                  }
                }),
                items: [
                  for (final mode in StringSearchMode.values)
                    DropdownMenuItem(
                      child: Text(mode.convertToString()),
                      value: mode,
                    ),
                ],
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(hintText: 'Ник'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != null) {
                    if (value.isNotEmpty) {
                      final val = value.trim();
                      if (!RegExp(r'^[A-Za-zА-Яа-яёЁ0-9 ]+$').hasMatch(val)) {
                        return 'Неразрешеные символы!';
                      } else if (val.length > 30) {
                        return 'Слишком длинный ник';
                      }
                    }
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            'Уровень',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Theme.of(context).accentColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
              DropdownButtonFormField(
                value: _levelSearchOption,
                decoration: InputDecoration(),
                onChanged: (SearchOption? option) {
                  if (option != null) {
                    setState(() {
                      _levelSearchOption = option;
                      if (option == SearchOption.valueRange) {
                        _nicknameSearchMode = StringSearchMode.exactValue;
                        _ageSearchOption = SearchOption.exactValue;
                      }
                    });
                  }
                },
                items: [
                  for (final option in SearchOption.values)
                    DropdownMenuItem(
                      child: Text(option.convertToString()),
                      value: option,
                    ),
                ],
              ),
              SizedBox(height: 10.0),
              if (_levelSearchOption == SearchOption.exactValue)
                TextFormField(
                  controller: _levelController,
                  decoration: InputDecoration(hintText: 'Уровень'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value != null) {
                      if (value.isNotEmpty) {
                        final val = value.trim();
                        if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                          return 'Уровень должен быть числом';
                        } else {
                          final level = int.tryParse(val) ?? 0;
                          if (level > 28 || level < 1) {
                            return 'Некорректный уровень';
                          }
                        }
                      }
                    }
                    return null;
                  },
                ),
              if (_levelSearchOption == SearchOption.valueRange)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _levelFromController,
                        decoration: InputDecoration(hintText: 'Уровень (от)'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != null) {
                            if (value.isNotEmpty) {
                              final val = value.trim();
                              if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                                return 'Уровень должен быть числом';
                              } else {
                                final level = int.tryParse(val) ?? 0;
                                if (level > 28 || level < 1) {
                                  return 'Некорректный уровень';
                                }
                              }
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: TextFormField(
                        controller: _levelToController,
                        decoration: InputDecoration(hintText: 'Уровень (до)'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != null) {
                            if (value.isNotEmpty) {
                              final val = value.trim();
                              if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                                return 'Уровень должен быть числом';
                              } else {
                                final level = int.tryParse(val) ?? 0;
                                if (level > 28 || level < 1) {
                                  return 'Некорректный уровень';
                                }
                              }
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Данные игрока',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Theme.of(context).accentColor.withOpacity(0.7),
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Пол',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Theme.of(context).accentColor),
              ),
              RadioListTile<Gender>(
                onChanged: (value) => setState(() => _playerGender = value!),
                groupValue: _playerGender,
                value: Gender.undefined,
                title: Text(
                  'Неважно',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
              RadioListTile<Gender>(
                onChanged: (value) => setState(() => _playerGender = value!),
                groupValue: _playerGender,
                value: Gender.male,
                title: Text(
                  'Парень',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
              RadioListTile<Gender>(
                onChanged: (value) => setState(() => _playerGender = value!),
                groupValue: _playerGender,
                value: Gender.female,
                title: Text(
                  'Девушка',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            'Возраст',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Theme.of(context).accentColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
              DropdownButtonFormField(
                value: _ageSearchOption,
                decoration: InputDecoration(),
                onChanged: (SearchOption? option) {
                  if (option != null) {
                    setState(() {
                      _ageSearchOption = option;
                      if (option == SearchOption.valueRange) {
                        _nicknameSearchMode = StringSearchMode.exactValue;
                        _levelSearchOption = SearchOption.exactValue;
                      }
                    });
                  }
                },
                items: [
                  for (final option in SearchOption.values)
                    DropdownMenuItem(
                      child: Text(option.convertToString()),
                      value: option,
                    ),
                ],
              ),
              SizedBox(height: 10.0),
              if (_ageSearchOption == SearchOption.exactValue)
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(hintText: 'Возраст'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value != null) {
                      if (value.isNotEmpty) {
                        final val = value.trim();
                        if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                          return 'Возраст должен содержать только цифры';
                        } else {
                          final age = int.tryParse(val) ?? 0;
                          if (age < 10 || age > 50) {
                            return 'Некорректный возраст';
                          }
                        }
                      }
                    }
                    return null;
                  },
                ),
              if (_ageSearchOption == SearchOption.valueRange)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ageFromController,
                        decoration: InputDecoration(hintText: 'Возраст (от)'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != null) {
                            if (value.isNotEmpty) {
                              final val = value.trim();
                              if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                                return 'Возраст должен содержать только цифры';
                              } else {
                                final age = int.tryParse(val) ?? 0;
                                if (age < 10 || age > 50) {
                                  return 'Некорректный возраст';
                                }
                              }
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: TextFormField(
                        controller: _ageToController,
                        decoration: InputDecoration(hintText: 'Возраст (до)'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final val = value.trim();
                            if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                              return 'Возраст должен содержать только цифры';
                            } else {
                              final age = int.tryParse(val) ?? 0;
                              if (age < 10 || age > 50) {
                                return 'Некорректный возраст';
                              }
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            'Местоположение',
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Theme.of(context).accentColor),
          ),
        ),
        if (profile.player?.address?.country == null &&
            profile.player?.address?.region == null &&
            profile.player?.address?.city == null)
          ListTile(
            leading: Icon(
              Icons.info,
              color: Theme.of(context).accentColor,
            ),
            subtitle: Text(
              'Чтобы искать по местоположению, укажите его в своём профиле. ',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ),
        if (profile.player?.address?.country != null)
          CheckboxListTile(
            checkColor: Colors.black,
            title: Text(
              'Из моей страны',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            value: _fromCountry,
            onChanged: !_fromRegion
                ? (value) {
                    if (value != null) setState(() => _fromCountry = value);
                  }
                : null,
          ),
        if (profile.player?.address?.region != null)
          CheckboxListTile(
            checkColor: Colors.black,
            title: Text(
              'Из моего региона',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            value: _fromRegion,
            onChanged: !_fromCity
                ? (value) {
                    if (value != null)
                      setState(() => _fromCountry = _fromRegion = value);
                  }
                : null,
          ),
        if (profile.player?.address?.city != null)
          CheckboxListTile(
            checkColor: Colors.black,
            title: Text(
              'Из моего населённого пункта',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            value: _fromCity,
            onChanged: (value) {
              if (value != null)
                setState(() => _fromCountry = _fromRegion = _fromCity = value);
            },
          ),
      ],
    );
  }

  // TODO: Composite indeces (try different variations)

  void _onSearchButtonPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final address = Provider.of<ProfileChangeNotifier>(context, listen: false)
          .profile!
          .player
          ?.address;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilesSearchPage(
            characterId: _idController.text.isNotEmpty
                ? int.tryParse(_idController.text.trim())
                : null,
            characterGender: _characterGender,
            characterNickname: _nicknameController.text.isNotEmpty
                ? _nicknameController.text.trim().toLowerCase()
                : null,
            characterNicknameExtendedSearch:
                _nicknameSearchMode == StringSearchMode.fromStart,
            characterLevel: _levelSearchOption == SearchOption.exactValue
                ? _levelController.text.isNotEmpty
                    ? int.tryParse(_levelController.text.trim())
                    : null
                : null,
            characterLevelFrom: _levelSearchOption == SearchOption.valueRange
                ? _levelFromController.text.isNotEmpty
                    ? int.tryParse(_levelFromController.text.trim())
                    : null
                : null,
            characterLevelTo: _levelSearchOption == SearchOption.valueRange
                ? _levelToController.text.isNotEmpty
                    ? int.tryParse(_levelToController.text.trim())
                    : null
                : null,
            playerAge: _ageSearchOption == SearchOption.exactValue
                ? _ageController.text.isNotEmpty
                    ? int.tryParse(_ageController.text.trim())
                    : null
                : null,
            playerAgeFrom: _ageSearchOption == SearchOption.valueRange
                ? _ageFromController.text.isNotEmpty
                    ? int.tryParse(_ageFromController.text.trim())
                    : null
                : null,
            playerAgeTo: _ageSearchOption == SearchOption.valueRange
                ? _ageToController.text.isNotEmpty
                    ? int.tryParse(_ageToController.text.trim())
                    : null
                : null,
            playerGender: _playerGender,
            countryIso: _fromCountry ? address.country.iso : null,
            regionId: _fromRegion ? address.region.id : null,
            cityId: _fromCity ? address.city.id : null,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Есть ошибки в заполнении полей!',
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

enum SearchOption { exactValue, valueRange }

extension SearchOptionToString on SearchOption {
  String convertToString() {
    switch (this) {
      case SearchOption.exactValue:
        return 'Точное значение';
      case SearchOption.valueRange:
        return 'Диапазон значений';
    }
  }
}

enum StringSearchMode { exactValue, fromStart }

extension StringSearchModeToString on StringSearchMode {
  String convertToString() {
    switch (this) {
      case StringSearchMode.exactValue:
        return 'Точное значение';
      case StringSearchMode.fromStart:
        return 'По началу строки';
    }
  }
}
