// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      id: (json['id'] as num?)?.toInt(),
      stringId: json['stringId'] as String?,
      name: json['name'] as String,
      image: json['image'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'id': instance.id,
      'stringId': instance.stringId,
      'name': instance.name,
      'image': instance.image,
      'status': instance.status,
      'species': instance.species,
      'type': instance.type,
    };
