import '../entities/character.dart';
import '../repositories/character_repository.dart';

class FetchCharactersUseCase {
  final CharacterRepository repository;

  FetchCharactersUseCase(this.repository);

  Future<List<Character>> call({int page = 1}) async {
    return await repository.fetchCharacters(page: page);
  }
}
