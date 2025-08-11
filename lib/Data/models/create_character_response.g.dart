// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_character_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCharacterResponse _$CreateCharacterResponseFromJson(
  Map<String, dynamic> json,
) => CreateCharacterResponse(
  message: json['message'] as String,
  characterId: json['characterId'] as String,
);

Map<String, dynamic> _$CreateCharacterResponseToJson(
  CreateCharacterResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'characterId': instance.characterId,
};
