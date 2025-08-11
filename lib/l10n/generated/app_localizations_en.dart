// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get charactersListTitle => 'Characters list';

  @override
  String get createCharacterTitle => 'Create a character';

  @override
  String get character => 'Character';

  @override
  String get newCharacter => 'New character';

  @override
  String get pickImage => 'Pick an image';

  @override
  String get submit => 'Submit';

  @override
  String get noCharactersFound =>
      'No characters found, please create a new one.';

  @override
  String errorOccurred(String error) {
    return 'An error occurred: $error';
  }
}
