import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable()
class Character {
  final int? id;
  final String? stringId;
  final String name;
  final String image;
  final String status;
  final String species;
  String? type = "";

  Character({
    this.id,
    this.stringId,
    required this.name,
    required this.image,
    required this.status,
    required this.species,
    this.type,
  });

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}
