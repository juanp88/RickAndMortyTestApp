import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../Core/providers/providers.dart';
import '../../Domain/entities/character.dart';

part 'character_screen_viewmodel.g.dart';

@riverpod
class CharacterViewModel extends _$CharacterViewModel {
  final int pageSize = 20;
  List<Character> allCharacters = [];
  List<Character> filteredCharacters = [];
  String _currentSearchQuery = '';
  final Set<int> _fetchedPages = {}; // Track fetched pages

  @override
  FutureOr<List<Character>> build() async {
    return allCharacters;
  }

  Future<List<Character>> fetchCharacters({int page = 1}) async {
    try {
      debugPrint('Attempting to fetch page: $page');
      debugPrint('Previously fetched pages: $_fetchedPages');

      // Prevent duplicate page fetches
      if (_fetchedPages.contains(page)) {
        debugPrint('Page $page already fetched, returning existing characters');
        return _currentSearchQuery.isNotEmpty
            ? filteredCharacters
            : allCharacters
                .where((character) =>
                    allCharacters.indexOf(character) >= (page - 1) * pageSize &&
                    allCharacters.indexOf(character) < page * pageSize)
                .toList();
      }

      final fetchCharactersUseCase = ref.read(fetchCharactersUseCaseProvider);

      // Call use case to fetch characters for the specified page
      final characters = await fetchCharactersUseCase.call(page: page);

      debugPrint('Fetched characters for page $page: ${characters.length}');

      // Add new characters to the allCharacters list
      if (page == 1) {
        allCharacters = characters;
      } else {
        allCharacters.addAll(characters);
      }

      // Mark page as fetched
      _fetchedPages.add(page);

      // Apply current search filter if any
      if (_currentSearchQuery.isNotEmpty) {
        filterCharacters(_currentSearchQuery);
        return filteredCharacters;
      } else {
        filteredCharacters = List.from(allCharacters);
        return characters;
      }
    } catch (e) {
      debugPrint('Error fetching characters for page $page: $e');
      rethrow;
    }
  }

  void filterCharacters(String query) {
    _currentSearchQuery = query.toLowerCase();

    if (_currentSearchQuery.isEmpty) {
      filteredCharacters = List.from(allCharacters);
      return;
    }

    filteredCharacters = allCharacters.where((character) {
      return character.name.toLowerCase().contains(_currentSearchQuery) ||
          character.species.toLowerCase().contains(_currentSearchQuery) ||
          character.status.toLowerCase().contains(_currentSearchQuery);
    }).toList();
  }

  List<Character> getPaginatedCharacters() {
    return _currentSearchQuery.isNotEmpty ? filteredCharacters : allCharacters;
  }
}
