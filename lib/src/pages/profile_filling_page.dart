import 'package:avataria_search/src/constants.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';

import 'package:avataria_search/src/models/profile.dart';
import 'package:avataria_search/src/services/firestore_database.dart';
import 'package:avataria_search/src/widgets/avataria_search_app_bar.dart';
import 'package:avataria_search/src/services/firebase_storage_service.dart';
import 'package:avataria_search/src/models/user.dart';
import 'package:avataria_search/src/services/place_service.dart';
import 'package:avataria_search/src/widgets/avataria_search_background.dart';
import 'package:avataria_search/src/widgets/profile_form_element.dart';

class ProfileFillingPage extends StatefulWidget {
  final Profile? existingProfile;

  ProfileFillingPage({this.existingProfile});

  @override
  _ProfileFillingPageState createState() => _ProfileFillingPageState();
}

class _ProfileFillingPageState extends State<ProfileFillingPage> {
  final _formKey = GlobalKey<FormState>();
  Gender _characterGender = Gender.male;
  final _nicknameController = TextEditingController();
  final _searchNicknameController = TextEditingController();
  final _idController = TextEditingController();
  final _levelController = TextEditingController();
  final _imagePointsController = TextEditingController();
  final _comfortPointsController = TextEditingController();
  Gender _playerGender = Gender.undefined;
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactsContoller = TextEditingController();
  Country? _country;
  Region? _region;
  City? _city;
  PickedFile? _passportImage;
  PickedFile? _characterImage;
  final _imagePicker = ImagePicker();
  bool _inAsyncCall = false;
  bool _uploadedCharacterImage = false;
  bool _uploadedPassportImage = false;

  @override
  void initState() {
    if (widget.existingProfile != null) {
      _characterGender =
          widget.existingProfile!.character.gender ?? Gender.male;
      _nicknameController.text =
          widget.existingProfile!.character.nickname ?? '';
      _searchNicknameController.text =
          widget.existingProfile!.character.searchNickname ?? '';
      _idController.text = widget.existingProfile!.character.id != null
          ? widget.existingProfile!.character.id.toString()
          : '';
      _levelController.text = widget.existingProfile.character.level != null
          ? widget.existingProfile!.character.level.toString()
          : null;
      _imagePointsController.text =
          widget.existingProfile!.character.imagePoints != null
              ? widget.existingProfile!.character.imagePoints.toString()
              : '';
      _comfortPointsController.text =
          widget.existingProfile!.character.comfortPoints != null
              ? widget.existingProfile!.character.comfortPoints.toString()
              : '';
      _playerGender = widget.existingProfile!.player.gender;
      _nameController.text = widget.existingProfile!.player.name ?? '';
      _ageController.text = widget.existingProfile!.player.age != null
          ? widget.existingProfile!.player.age.toString()
          : '';
      _descriptionController.text =
          widget.existingProfile!.player.description ?? '';
      _contactsContoller.text = widget.existingProfile!.player.contacts ?? '';
      _country = widget.existingProfile!.player.address.country;
      _region = widget.existingProfile!.player.address.region;
      _city = widget.existingProfile!.player.address.city;
      _loadExistingProfileImages();
    }
    super.initState();
  }

  Future<void> _loadExistingProfileImages() async {
    setState(() => _inAsyncCall = true);
    final characterImageUri = await FirebaseStorageService.getPhotoUri(
      FirebaseStoragePath.character(widget.existingProfile.userId),
    );
    _characterImage = PickedFile(characterImageUri.toString());
    final passportImageUri = await FirebaseStorageService.getPhotoUri(
      FirebaseStoragePath.passport(widget.existingProfile.userId),
    );
    _passportImage = PickedFile(passportImageUri.toString());
    setState(() => _inAsyncCall = false);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _searchNicknameController.dispose();
    _idController.dispose();
    _nameController.dispose();
    _levelController.dispose();
    _imagePointsController.dispose();
    _comfortPointsController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    _contactsContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AvatariaSearchBackground(
        child: ModalProgressHUD(
          inAsyncCall: _inAsyncCall,
          child: CustomScrollView(
            slivers: [
              AvatariaSearchSliverAppBar(
                hasBackButton: widget.existingProfile != null,
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kHorizontalPadding,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Center(
                      child: Form(
                        key: _formKey,
                        child: Container(
                          width: kBodyWidth,
                          child: Column(
                            children: _buildFormWidgets(),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormWidgets() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text(
          widget.existingProfile == null
              ? 'Теперь давайте настроим Ваш профиль.'
              : 'Редактирование профиля',
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Theme.of(context).accentColor),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Данные персонажа',
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Theme.of(context).accentColor.withOpacity(0.7),
                ),
          ),
        ),
      ),
      ProfileFormElement(
        padding: const EdgeInsets.only(bottom: 5.0),
        hintTitle: 'Пол персонажа',
        hintBody: 'Вспомните, какой пол вы выбирали при начале игры.\n\n'
            'Эта информация может быть использована при поиске другими пользователями.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Пол',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Theme.of(context).accentColor),
            ),
            RadioListTile<Gender>(
              onChanged: (value) => setState(() => _characterGender = value),
              groupValue: _characterGender,
              value: Gender.male,
              title: Text(
                'Парень',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
            RadioListTile<Gender>(
              onChanged: (value) => setState(() => _characterGender = value),
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
      ProfileFormElement(
        hintTitle: 'Ник персонажа',
        hintBody: 'Ник можно найти в паспорте Вашего персонажа.',
        child: TextFormField(
          controller: _nicknameController,
          decoration: InputDecoration(hintText: 'Ник'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            final val = value.trim();
            if (val.isEmpty) {
              return 'Введите ник';
            } else if (val.length > 30) {
              return 'Слишком длинный ник';
            }
            return null;
          },
        ),
      ),
      ProfileFormElement(
        hintTitle: 'Ник для поиска',
        hintBody:
            'Ник для поиска – это "чтение" Вашего ника, которое будет использоваться, '
            'когда Вас будут искать по нику другие игроки. \n\n'
            'Ник для поиска может содержать лишь цифры и буквы русского и английского алфавитов. '
            'Также он не должен содержать в себе префиксов Вашего сквада.\n\n'
            'Трансформируйте свой ник по следующим примерам:\n'
            'Γζã₥у®ñãя™ => Гламурная\n'
            '|¤СаХаРоК¤| => СаХаРоК\n'
            '{BM}ЌӦĿӦŠӦЌ => KOLOSOK\n'
            'Ẅē® Ђįŋ į¢ђ? => Wer bin ich\n\n'
            'Если Ваш ник не содержит специальных символов, введите Ваш ник заново:\n'
            'Жанна => Жанна',
        child: TextFormField(
          controller: _searchNicknameController,
          decoration: InputDecoration(hintText: 'Ник для поиска'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            final val = value.trim();
            if (val.isEmpty) {
              return 'Введите ник для поиска';
            } else if (!RegExp(r'^[A-Za-zА-Яа-яёЁ0-9 ]+$').hasMatch(val)) {
              return 'Неразрешеные символы! Чит. "Помощь" ➡';
            } else if (val.length > 30) {
              return 'Слишком длинный ник';
            }
            return null;
          },
        ),
      ),
      ProfileFormElement(
        hintTitle: 'ID персонажа',
        hintBody: 'Ваш ID можно найти в паспорте Вашего персонажа, '
            'в нижнем левом углу.\n\n'
            'Эта информация может быть использована при поиске другими пользователями.',
        child: TextFormField(
          controller: _idController,
          decoration: InputDecoration(hintText: 'ID'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            final val = value.trim();
            if (val.isEmpty) {
              return 'Введите ID';
            } else if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
              return 'ID может содержать только цифры';
            } else if (val.length > 20) {
              return 'Слишком длинный ID';
            }
            return null;
          },
        ),
      ),
      ProfileFormElement(
        hintTitle: 'Уровень',
        hintBody: 'Ваш уровень в игре можно найти в паспорте под ником.\n\n'
            'Эта информация может быть использована при поиске другими пользователями.',
        child: TextFormField(
          controller: _levelController,
          decoration: InputDecoration(hintText: 'Уровень'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            final val = value.trim();
            if (val.isEmpty) {
              return 'Введите уровень';
            } else if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
              return 'Уровень должен быть числом';
            } else {
              final level = int.tryParse(val) ?? 0;
              if (level > 28 || level < 1) {
                return 'Некорректный уровень';
              }
            }
            return null;
          },
        ),
      ),
      ProfileFormElement(
        hintTitle: 'Количество очков имиджа',
        hintBody:
            'Ваши очки имиджа в игре можно найти в паспорте под ником.\n\n'
            'Эта информация может быть использована при поиске другими пользователями.',
        child: TextFormField(
          controller: _imagePointsController,
          decoration: InputDecoration(hintText: 'Очки имиджа'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            final val = value.trim();
            if (val.isEmpty) {
              return 'Введите количество очков';
            } else if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
              return 'Очки должны содержать только цифры';
            } else if (val.length > 8) {
              return 'Некорректное значение';
            } else {
              return null;
            }
          },
        ),
      ),
      ProfileFormElement(
        hintTitle: 'Количество очков комфорта',
        hintBody:
            'Ваши очки комфорта в игре можно найти в паспорте под ником.\n\n'
            'Эта информация может быть использована при поиске другими пользователями.',
        child: TextFormField(
          controller: _comfortPointsController,
          decoration: InputDecoration(hintText: 'Очки комфорта'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            final val = value.trim();
            if (val.isEmpty) {
              return 'Введите количество очков';
            } else if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
              return 'Очки должны содержать только цифры';
            } else if (val.length > 8) {
              return 'Некорректное значение';
            } else {
              return null;
            }
          },
        ),
      ),
      ProfileFormElement(
        hintTitle: 'Скриншот паспорта',
        hintBody: '• Сделайте скриншот паспорта Вашего персонажа\n'
            '• Чтобы загрузить скриншот, нажмите на кнопку "Загрузить".\n\n'
            'Скриншот должен быть неотредактированным '
            '(тем не менее, Вы можете замазать информацию об отношениях).',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Скриншот паспорта: '
              '${_passportImage != null ? 'загружен' : 'не загружен'}',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Theme.of(context).accentColor),
            ),
            RaisedButton(
              child: Text(
                  _passportImage == null ? 'ЗАГРУЗИТЬ' : 'ЗАГРУЗИТЬ ДРУГОЙ'),
              onPressed: () async {
                final img =
                    await _imagePicker.getImage(source: ImageSource.gallery);
                setState(() => _passportImage = img);
                _uploadedPassportImage = true;
              },
            ),
          ],
        ),
      ),
      if (_passportImage != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Image.network(
            _passportImage.path,
            fit: BoxFit.fitWidth,
          ),
        ),
      ProfileFormElement(
        hintTitle: 'Скриншот персонажа',
        hintBody: '• Сделайте скриншот из игры с Вашим персонажем\n'
            '• Обрежьте скриншот в редакторе фото, чтобы было видно только Вашего '
            'персонажа, в формате 3:4 (формат изображения можно выбрать в редакторе при обрезке). '
            'Вы можете также обрезать скриншот в произвольном формате, '
            'но не факт, что персонажа будет полностью видно на сайте.\n'
            '• Чтобы загрузить обрезанное фото, нажмите на кнопку "Загрузить" и выберите его.\n'
            '• После загрузки под кнопкой появится Ваше фото. Убедитесь, что '
            'Вашего персонажа полностью и хорошо видно.',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Скриншот персонажа: '
              '${_characterImage != null ? 'загружен' : 'не загружен'}\n'
              '(формат изображения – 3:4)',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Theme.of(context).accentColor),
            ),
            RaisedButton(
              child: Text(
                  _characterImage == null ? 'ЗАГРУЗИТЬ' : 'ЗАГРУЗИТЬ ДРУГОЙ'),
              onPressed: () async {
                final img =
                    await _imagePicker.getImage(source: ImageSource.gallery);
                setState(() => _characterImage = img);
                _uploadedCharacterImage = true;
              },
            ),
          ],
        ),
      ),
      if (_characterImage != null)
        Container(
          padding: const EdgeInsets.only(bottom: 20.0),
          height: 300.0,
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(_characterImage.path),
                  fit: BoxFit.fitHeight,
                  alignment: FractionalOffset.center,
                ),
              ),
            ),
          ),
        ),
      Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        alignment: Alignment.centerLeft,
        child: Text(
          'Данные игрока',
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Theme.of(context).accentColor.withOpacity(0.7),
              ),
        ),
      ),
      ProfileFormElement(
        padding: const EdgeInsets.only(bottom: 5.0),
        hintTitle: 'Ваш пол',
        hintBody: 'Ваш пол в реальной жизни.\n\n'
            'Эта информация может быть использована при поиске другими пользователями. '
            'Тем не менее, она не видна пользователям, не состоящим в Вашем списке приятелей в AvatariaSearch.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Пол',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Theme.of(context).accentColor),
            ),
            RadioListTile<Gender>(
              onChanged: (value) => setState(() => _playerGender = value),
              groupValue: _playerGender,
              value: Gender.undefined,
              title: Text(
                'Не выбран',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
            RadioListTile<Gender>(
              onChanged: (value) => setState(() => _playerGender = value),
              groupValue: _playerGender,
              value: Gender.male,
              title: Text(
                'Парень',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
            RadioListTile<Gender>(
              onChanged: (value) => setState(() => _playerGender = value),
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
      ProfileFormElement(
        hintTitle: 'Имя',
        hintBody: 'Ваше имя в реальной жизни.\n\n'
            'Эта информация не видна пользователям, не состоящим в Вашем списке приятелей в AvatariaSearch.',
        child: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(hintText: 'Ваше имя (необязательно)'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value.isNotEmpty) {
              final val = value.trim();
              if (val.length > 30) {
                return 'Слишком длинное имя';
              } else if (!RegExp(r'^[A-Za-zА-Яа-яёЁ]+$').hasMatch(val)) {
                return 'Имя может содержать только буквы';
              }
            }
            return null;
          },
        ),
      ),
      ProfileFormElement(
        hintTitle: 'Возраст',
        hintBody: 'Ваш возраст в реальной жизни.\n\n'
            'Эта информация может быть использована при поиске другими пользователями. '
            'Тем не менее, она не видна пользователям, не состоящим в Вашем списке приятелей в AvatariaSearch.',
        child: TextFormField(
          controller: _ageController,
          decoration: InputDecoration(hintText: 'Ваш возраст (необязательно)'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
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
            return null;
          },
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          'Ваше местоположение (необязательно)',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Theme.of(context).accentColor),
        ),
      ),
      ProfileFormElement(
        hintTitle: 'Страна',
        hintBody: 'Страна, в которой Вы живёте.\n\n'
            'Эта информация может быть использована при поиске другими пользователями. '
            'Тем не менее, она не видна пользователям, не состоящим в Вашем списке приятелей в AvatariaSearch.',
        padding: _country != null
            ? EdgeInsets.zero
            : const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Страна: ${_country != null ? _country : 'не выбрана'}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Theme.of(context).accentColor),
              ),
            ),
            if (_country == null)
              RaisedButton(
                child: Text('ВЫБРАТЬ'),
                onPressed: () => _onSelectLocationButtonPressed(
                  context,
                  _LocationType.country,
                ),
              ),
            if (_country != null)
              RaisedButton(
                child: Text('УДАЛИТЬ'),
                onPressed: () =>
                    setState(() => _country = _region = _city = null),
              ),
          ],
        ),
      ),
      if (_country != null)
        ProfileFormElement(
          hintTitle: 'Регион',
          hintBody: 'Регион, в котором Вы живёте.\n\n'
              'Эта информация может быть использована при поиске другими пользователями. '
              'Тем не менее, она не видна пользователям, не состоящим в Вашем списке приятелей в AvatariaSearch.',
          padding: _region != null
              ? EdgeInsets.zero
              : const EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Регион: ${_region != null ? _region : 'не выбран'}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Theme.of(context).accentColor),
                ),
              ),
              if (_region == null)
                RaisedButton(
                  child: Text('ВЫБРАТЬ'),
                  onPressed: () => _onSelectLocationButtonPressed(
                    context,
                    _LocationType.region,
                  ),
                ),
              if (_region != null)
                RaisedButton(
                  child: Text('УДАЛИТЬ'),
                  onPressed: () => setState(() => _region = _city = null),
                ),
            ],
          ),
        ),
      if (_country != null && _region != null)
        ProfileFormElement(
          hintTitle: 'Населённый пункт',
          hintBody: 'Населённый пункт, в котором Вы живёте.\n\n'
              'Эта информация может быть использована при поиске другими пользователями. '
              'Тем не менее, она не видна пользователям, не состоящим в Вашем списке приятелей в AvatariaSearch.',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Населённый пункт: ${_city != null ? _city : 'не выбран'}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Theme.of(context).accentColor),
                ),
              ),
              if (_city == null)
                RaisedButton(
                  child: Text('ВЫБРАТЬ'),
                  onPressed: () => _onSelectLocationButtonPressed(
                    context,
                    _LocationType.city,
                  ),
                ),
              if (_city != null)
                RaisedButton(
                  child: Text('УДАЛИТЬ'),
                  onPressed: () => setState(() => _city = null),
                ),
            ],
          ),
        ),
      ProfileFormElement(
        hintTitle: 'Описание профиля',
        hintBody: 'Укажите информацию о себе и о том, кого Вы хотите найти.\n\n'
            'Эта информация видна всем пользователям в AvatariaSearch.',
        child: TextFormField(
          decoration: InputDecoration(hintText: 'Описание профиля'),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _descriptionController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            final val = value.trim();
            if (val.isEmpty) {
              return 'Напишите о себе и кого Вы хотите найти';
            } else if (val.length > 100) {
              return 'Макс. длина - 100 символов';
            }
            return null;
          },
        ),
      ),
      ProfileFormElement(
        hintTitle: 'Контакты',
        hintBody:
            'Укажите, как с Вами могут связаться другие пользователи (Ваши соцсети).\n\n'
            'Эта информация не видна пользователям, не состоящим в Вашем списке приятелей в AvatariaSearch.',
        child: TextFormField(
          decoration: InputDecoration(hintText: 'Контакты'),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _contactsContoller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            final val = value.trim();
            if (val.isEmpty) {
              return 'Напишите, как с Вами могут связаться другие игроки';
            } else if (val.length > 100) {
              return 'Макс. длина - 100 символов';
            }
            return null;
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Builder(
          builder: (context) => RaisedButton(
            child: Text('СОХРАНИТЬ'),
            onPressed: () => _onSaveButtonPressed(context),
          ),
        ),
      ),
    ];
  }

  Future<void> _onSelectLocationButtonPressed(
      BuildContext context, _LocationType locationType) async {
    var onChange, onFind, hintText, label, selectedValue, itemBuilder;
    final placeService = await PlaceService.create();
    switch (locationType) {
      case _LocationType.country:
        selectedValue = _country;
        onChange = (country) => setState(() {
              _country = country;
              _region = null;
              _city = null;
            });
        onFind = (filter) => placeService.getCountries(name: filter);
        hintText = 'Страна';
        label = 'Выбрать страну';
        break;
      case _LocationType.region:
        selectedValue = _region;
        onChange = (region) => setState(() {
              _region = region;
              _city = null;
            });
        onFind = (filter) =>
            placeService.getRegions(name: filter, countryIso: _country.iso);
        hintText = 'Регион';
        label = 'Выбрать регион';
        break;
      case _LocationType.city:
        selectedValue = _city;
        onChange = (city) => setState(() => _city = city);
        onFind = (filter) => placeService.getCities(
              name: filter,
              countryIso: _country.iso,
              regionId: _region.id,
            );
        hintText = 'Населённый пункт';
        label = 'Выбрать населённый пункт';
        itemBuilder = (context, city, selected) => ListTile(
              selected: selected,
              title: Text(city.toString()),
              subtitle: city.area != null ? Text(city.area) : null,
            );
        break;
    }
    SelectDialog.showModal(
      context,
      label: label,
      selectedValue: selectedValue,
      onFind: onFind,
      onChange: onChange,
      searchBoxDecoration: InputDecoration(hintText: hintText),
      loadingBuilder: (context) => Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      ),
      itemBuilder: itemBuilder,
      errorBuilder: (context, e) => Center(
        child: Text('Произошла ошибка при загрузке данных: $e'),
      ),
      emptyBuilder: (context) => Center(child: Text('Не найдено')),
    );
  }

  Future<void> _onSaveButtonPressed(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Не все поля заполнены без ошибок!',
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (_passportImage == null || _characterImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Вы не загрузили все скриншоты!',
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    setState(() => _inAsyncCall = true);
    try {
      if (_uploadedPassportImage) {
        await FirebaseStorageService.uploadPhoto(
          FirebaseStoragePath.passport(
            Provider.of<User>(context, listen: false).uid,
          ),
          await _passportImage.readAsBytes(),
        );
      }
      if (_uploadedCharacterImage) {
        await FirebaseStorageService.uploadPhoto(
          FirebaseStoragePath.character(
            Provider.of<User>(context, listen: false).uid,
          ),
          await _characterImage.readAsBytes(),
        );
      }
      await FirestoreDatabase.createProfile(
        userId: Provider.of<User>(context, listen: false).uid,
        profile: Profile(
          character: Character(
            gender: _characterGender,
            nickname: _nicknameController.text.trim(),
            searchNickname: _searchNicknameController.text.trim().toLowerCase(),
            id: int.tryParse(_idController.text.trim()),
            level: int.tryParse(_levelController.text.trim()),
            imagePoints: int.tryParse(_imagePointsController.text.trim()),
            comfortPoints: int.tryParse(_comfortPointsController.text.trim()),
          ),
          player: Player(
            gender: _playerGender,
            name: _nameController.text.isNotEmpty
                ? _nameController.text.trim()
                : null,
            age: _ageController.text.isNotEmpty
                ? int.tryParse(_ageController.text.trim())
                : null,
            description: _descriptionController.text.trim(),
            contacts: _contactsContoller.text.trim(),
            address: Address(
              country: _country,
              region: _region,
              city: _city,
            ),
          ),
        ),
      );
      if (widget.existingProfile != null) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _inAsyncCall = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Произошла ошибка при загрузке: $e',
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

enum _LocationType { country, region, city }
