// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_character_screen_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(NewCharacterViewModel)
const newCharacterViewModelProvider = NewCharacterViewModelProvider._();

final class NewCharacterViewModelProvider
    extends $AsyncNotifierProvider<NewCharacterViewModel, void> {
  const NewCharacterViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newCharacterViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newCharacterViewModelHash();

  @$internal
  @override
  NewCharacterViewModel create() => NewCharacterViewModel();
}

String _$newCharacterViewModelHash() =>
    r'60cc78410fc436e085a33d461723eb6f09c89eeb';

abstract class _$NewCharacterViewModel extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
