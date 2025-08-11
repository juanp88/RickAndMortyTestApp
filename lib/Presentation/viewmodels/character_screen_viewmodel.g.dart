// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_screen_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(CharacterViewModel)
const characterViewModelProvider = CharacterViewModelProvider._();

final class CharacterViewModelProvider
    extends $AsyncNotifierProvider<CharacterViewModel, List<Character>> {
  const CharacterViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'characterViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$characterViewModelHash();

  @$internal
  @override
  CharacterViewModel create() => CharacterViewModel();
}

String _$characterViewModelHash() =>
    r'20460023dfc37fa73bc73f4d9d1246cdb26be0e0';

abstract class _$CharacterViewModel extends $AsyncNotifier<List<Character>> {
  FutureOr<List<Character>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Character>>, List<Character>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Character>>, List<Character>>,
              AsyncValue<List<Character>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
