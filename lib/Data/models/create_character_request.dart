import 'package:json_annotation/json_annotation.dart';

part 'create_character_request.g.dart';

@JsonSerializable()
class CreateCharacterRequest {
  final String name;
  final String image;
  final String status;
  final String species;

  CreateCharacterRequest({
    required this.name,
    required this.image,
    required this.status,
    required this.species,
  });

  factory CreateCharacterRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCharacterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateCharacterRequestToJson(this);
}
