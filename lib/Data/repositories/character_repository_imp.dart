import 'dart:io';
import 'package:rick_and_morty_app/Core/utils/constants.dart';
import 'package:rick_and_morty_app/Data/models/create_character_request.dart';
import 'package:rick_and_morty_app/Data/models/create_character_response.dart';
import '../../Domain/entities/character.dart';
import '../../Domain/repositories/character_repository.dart';
import '../remote/api_service.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final ApiService api;

  CharacterRepositoryImpl(this.api);

  @override
  Future<List<Character>> fetchCharacters({int page = 1}) async {
    final response =
        await api.request(endpoint: '${Constants.charactersEndpoint}$page');
    final results = response['results'] as List;
    return results.map((json) => Character.fromJson(json)).toList();
  }

  @override
  Future<CreateCharacterResponse> submitCharacter(
      CreateCharacterRequest request) async {
    final response = await api.request(
      endpoint: Constants.newCharactersEndpoint,
      method: 'POST',
      body: request.toJson(),
    );
    var responseObj = CreateCharacterResponse.fromJson(response);
    return responseObj;
  }

  @override
  Future<List<Character>> getSubmittedCharacters() async {
    final response =
        await api.request(endpoint: Constants.newCharactersEndpoint);
    final results = response['characters'] as List;
    return results.map((json) => Character.fromJson(json)).toList();
  }

  @override
  Future<String> submitImage(String uploadUrl, File imageFile) async {
    try {
      final response = await api.request(
        customUrl: uploadUrl,
        endpoint: "",
        method: 'PUT',
        body: await imageFile.readAsBytes(),
        headers: {'Content-Type': 'image/jpeg'},
      );

      if (response.isEmpty) {
        // Assuming an empty response for successful PUT
        return uploadUrl.split('?').first; // Strip query params for public URL
      } else {
        throw Exception("Unexpected response from S3 upload");
      }
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  @override
  Future<String> getImageUploadUrl({required String fileName}) async {
    final response = await api
        .request(endpoint: Constants.uploadImageEndpoint, queryParameters: {
      'fileName': fileName,
    });
    return response['uploadUrl'];
  }
}
