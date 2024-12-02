// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_character_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCharacterRequest _$CreateCharacterRequestFromJson(
        Map<String, dynamic> json) =>
    CreateCharacterRequest(
      name: json['name'] as String,
      image: json['image'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
    );

Map<String, dynamic> _$CreateCharacterRequestToJson(
        CreateCharacterRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'status': instance.status,
      'species': instance.species,
    };
