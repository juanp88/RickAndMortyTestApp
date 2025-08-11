import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rick_and_morty_app/Domain/entities/character.dart';
import 'package:rick_and_morty_app/Presentation/widgets/character_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../viewmodels/character_screen_viewmodel.dart';
import '../widgets/error_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/animated_background.dart';

class CharacterScreen extends ConsumerStatefulWidget {
  const CharacterScreen({super.key});

  @override
  CharacterScreenState createState() => CharacterScreenState();
}

class CharacterScreenState extends ConsumerState<CharacterScreen> {
  final PagingController<int, Character> _pagingController = PagingController(
    firstPageKey: 1,
  );

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
      final newCharacters = await characterViewModel.fetchCharacters(
        page: pageKey,
      );

      // debugPrint characters for debugging
      debugPrint(
        'Fetched characters for page $pageKey: ${newCharacters.length}',
      );
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
    return AnimatedBackground(
      child: RefreshIndicator(
        onRefresh: () async {
          _pagingController.refresh();
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Animated header
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                          'Discover',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D3748),
                              ),
                        )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideX(begin: -0.2, end: 0),
                    Text(
                          'Amazing Characters',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: const Color(0xFF6BE9F8),
                                fontWeight: FontWeight.w600,
                              ),
                        )
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 600.ms)
                        .slideX(begin: -0.2, end: 0),
                  ],
                ),
              ),
            ),

            // Search bar in a sliver
            SliverToBoxAdapter(
              child: CharacterSearchBar(onChanged: _onSearchChanged)
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0),
            ),

            // Characters list
            ref
                .watch(characterViewModelProvider)
                .when(
                  data: (characters) => SliverPadding(
                    padding: const EdgeInsets.only(bottom: 100),
                    sliver: PagedSliverList<int, Character>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<Character>(
                        itemBuilder: (context, character, index) {
                          return Skeletonizer(
                            enabled: character.name.isEmpty,
                            child: CharacterTile(
                              character: character,
                              index: index,
                            ),
                          );
                        },
                        firstPageErrorIndicatorBuilder: (context) => Padding(
                          padding: const EdgeInsets.all(32),
                          child: ErrorIndicator(
                            error: _pagingController.error,
                            onTryAgain: () => _pagingController.refresh(),
                          ),
                        ),
                        noItemsFoundIndicatorBuilder: (context) => Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF6BE9F8),
                                          Color(0xFF7185F6),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.search_off,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                  )
                                  .animate()
                                  .scale(duration: 600.ms)
                                  .then()
                                  .shake(duration: 300.ms),
                              const SizedBox(height: 24),
                              Text(
                                'No characters found',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                              const SizedBox(height: 8),
                              Text(
                                'Try adjusting your search terms',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
                            ],
                          ),
                        ),
                        firstPageProgressIndicatorBuilder: (context) =>
                            const SizedBox.shrink(),
                        newPageProgressIndicatorBuilder: (context) => Padding(
                          padding: const EdgeInsets.all(16),
                          child:
                              Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                      ),
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 300.ms)
                                  .scale(begin: const Offset(0.8, 0.8)),
                        ),
                      ),
                    ),
                  ),
                  loading: () => SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6BE9F8),
                                      Color(0xFF7185F6),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF6BE9F8,
                                      ).withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              .animate()
                              .scale(duration: 800.ms)
                              .then()
                              .shimmer(duration: 1200.ms, color: Colors.white),
                          const SizedBox(height: 24),
                          Text(
                            'Loading amazing characters...',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ).animate(delay: 400.ms).fadeIn(duration: 600.ms),
                        ],
                      ),
                    ),
                  ),
                  error: (error, stack) => SliverFillRemaining(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: ErrorIndicator(
                        error: error,
                        onTryAgain: () => _pagingController.refresh(),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
