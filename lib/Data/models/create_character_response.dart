import 'package:json_annotation/json_annotation.dart';

part 'create_character_response.g.dart';

@JsonSerializable()
class CreateCharacterResponse {
  final String message;
  final String characterId;

  const CreateCharacterResponse({
    required this.message,
    required this.characterId,
  });

  factory CreateCharacterResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateCharacterResponseFromJson(json);
}
