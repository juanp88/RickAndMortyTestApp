import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rick_and_morty_app/Domain/entities/character.dart';
import 'package:rick_and_morty_app/Presentation/widgets/character_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../viewmodels/character_screen_viewmodel.dart';
import '../widgets/error_widget.dart';
import '../widgets/search_bar_widget.dart';

class CharacterScreen extends ConsumerStatefulWidget {
  const CharacterScreen({super.key});

  @override
  CharacterScreenState createState() => CharacterScreenState();
}

class CharacterScreenState extends ConsumerState<CharacterScreen> {
  final PagingController<int, Character> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final characterViewModel = ref.read(characterViewModelProvider.notifier);

      // Fetch characters for the specific page
      final newCharacters =
          await characterViewModel.fetchCharacters(page: pageKey);

      // debugPrint characters for debugging
      debugPrint(
          'Fetched characters for page $pageKey: ${newCharacters.length}');
      debugPrint('Characters: ${newCharacters.map((c) => c.name).toList()}');

      // Check if there are more pages
      final isLastPage = newCharacters.length < characterViewModel.pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newCharacters);
      } else {
        _pagingController.appendPage(newCharacters, pageKey + 1);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _onSearchChanged(String query) {
    final characterViewModel = ref.read(characterViewModelProvider.notifier);
    characterViewModel.filterCharacters(query);
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CharacterSearchBar(
          onChanged: _onSearchChanged,
        ),
        Expanded(
          child: ref.watch(characterViewModelProvider).when(
                data: (characters) => PagedListView<int, Character>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Character>(
                    itemBuilder: (context, character, index) {
                      debugPrint(
                          'Building tile for character: ${character.name}'); // Debug debugPrint
                      return Skeletonizer(
                          enabled: character.name.isEmpty,
                          child: CharacterTile(
                              character: character, index: index));
                    },
                    firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
                      error: _pagingController.error,
                      onTryAgain: () => _pagingController.refresh(),
                    ),
                    noItemsFoundIndicatorBuilder: (context) => const Center(
                      child: Text('No characters found'),
                    ),
                    firstPageProgressIndicatorBuilder: (context) =>
                        const SizedBox.shrink(),
                    newPageProgressIndicatorBuilder: (context) =>
                        const SizedBox.shrink(),
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => ErrorIndicator(
                  error: error,
                  onTryAgain: () => _pagingController.refresh(),
                ),
              ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
