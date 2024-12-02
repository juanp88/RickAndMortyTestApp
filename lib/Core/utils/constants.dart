import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static final baseUrl = dotenv.env['BASE_URL'];
  static const charactersEndpoint = "/characters?page=";
  static const newCharactersEndpoint = "/newCharacter";
  static const uploadImageEndpoint = "/images";
  static final letterPattern = RegExp(r'^[a-zA-Z]+$');
  static const bucketName = 'new-characters-images';
}
