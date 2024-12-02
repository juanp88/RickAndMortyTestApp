import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty_app/Core/utils/constants.dart';

import '../../Data/remote/api_service.dart';
import '../../Data/repositories/character_repository_imp.dart';
import '../../Domain/repositories/character_repository.dart';
import '../../Domain/usecases/character_usecases.dart';
import '../../Domain/usecases/new_character_usecases.dart';

// Http Client
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// Api Service
final apiServiceProvider = Provider<ApiService>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  return ApiService(baseUrl: Constants.baseUrl ?? "", httpClient: httpClient);
});

// Repository
final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  return CharacterRepositoryImpl(api);
});

// Use Case
final fetchCharactersUseCaseProvider = Provider<FetchCharactersUseCase>((ref) {
  final repository = ref.watch(characterRepositoryProvider);
  return FetchCharactersUseCase(repository);
});

final newCharacterUsecasesProvider = Provider<NewCharacterUsecases>((ref) {
  final repository = ref.watch(characterRepositoryProvider);
  return NewCharacterUsecases(repository);
});
