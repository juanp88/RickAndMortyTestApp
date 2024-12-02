import 'dart:io';

import 'package:rick_and_morty_app/Data/models/create_character_request.dart';
import 'package:rick_and_morty_app/Data/models/create_character_response.dart';
import 'package:rick_and_morty_app/Domain/entities/character.dart';

abstract class CharacterRepository {
  Future<List<Character>> fetchCharacters({int page = 1});
  Future<CreateCharacterResponse> submitCharacter(
      CreateCharacterRequest request);
  Future<List<Character>> getSubmittedCharacters();
  Future<String> getImageUploadUrl({required String fileName});
  Future<String> submitImage(String uploadUrl, File imageFile);
}
