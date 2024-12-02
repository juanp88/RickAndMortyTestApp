import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_app/Presentation/viewmodels/new_character_screen_viewmodel.dart';
import 'package:rick_and_morty_app/Presentation/widgets/character_tile.dart';

class NewCharactersListView extends ConsumerStatefulWidget {
  const NewCharactersListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewCharactersListViewState();
}

class _NewCharactersListViewState extends ConsumerState<NewCharactersListView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(newCharacterViewModelProvider);
    final characters =
        ref.read(newCharacterViewModelProvider.notifier).submittedCharacters;

    return viewModel.when(
      data: (_) {
        if (characters.isEmpty) {
          return const Center(
            child: Text(
              'No characters found, please create a new one.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) => CharacterTile(
                character: characters[index],
                index: index,
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}
