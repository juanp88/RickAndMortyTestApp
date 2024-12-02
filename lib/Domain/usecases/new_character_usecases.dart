import 'dart:io';

import 'package:rick_and_morty_app/Data/models/create_character_response.dart';

import '../../Data/models/create_character_request.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

class NewCharacterUsecases {
  final CharacterRepository repository;

  NewCharacterUsecases(this.repository);
  Future<CreateCharacterResponse> submitCharacter({
    required String name,
    required String species,
    required String status,
    String? image,
  }) async {
    return await repository.submitCharacter(
      CreateCharacterRequest(
        name: name,
        species: species,
        status: status,
        image: image ?? '',
      ),
    );
  }

  Future<List<Character>> fetchSubmittedCharacters() async {
    return await repository.getSubmittedCharacters();
  }

  Future<String> submitImage(String uploadUrl, File imageFile) async {
    return await repository.submitImage(uploadUrl, imageFile);
  }

  Future<String> getImageUploadUrl({required String fileName}) async {
    return await repository.getImageUploadUrl(fileName: fileName);
  }
}
