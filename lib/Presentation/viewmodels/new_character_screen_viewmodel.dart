import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../Core/providers/providers.dart';
import '../../Domain/entities/character.dart';
import 'package:path/path.dart' as path;

part 'new_character_screen_viewmodel.g.dart';

@riverpod
class NewCharacterViewModel extends _$NewCharacterViewModel {
  String imageUrl = "";
  List<Character> submittedCharacters = [];

  @override
  FutureOr<void> build() {
    fetchSubmittedCharacters();
  }

  Future<String?> pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      final newCharacterUseCase = ref.read(newCharacterUsecasesProvider);

      // Get pre-signed URL for upload
      final uploadUrl = await newCharacterUseCase.getImageUploadUrl(
        fileName: path.basename(image.path),
      );

      // Upload the image to S3
      imageUrl =
          await newCharacterUseCase.submitImage(uploadUrl, File(image.path));

      return imageUrl;
    } catch (error) {
      if (kDebugMode) {
        print('Error picking and uploading image: $error');
      }
      return null;
    }
  }

  Future<void> submitCharacter({
    required String name,
    required String species,
    required String status,
    String? imageUrl,
  }) async {
    state = const AsyncValue.loading();

    try {
      final newCharacterUseCase = ref.read(newCharacterUsecasesProvider);

      // Submit character with image URL
      await newCharacterUseCase.submitCharacter(
        name: name,
        species: species,
        status: status,
        image: imageUrl ?? '',
      );

      // Refresh the character list after submission
      await fetchSubmittedCharacters();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);

      if (kDebugMode) {
        print('Error submitting character: $error');
      }

      rethrow;
    }
  }

  Future<void> fetchSubmittedCharacters() async {
    state = const AsyncValue.loading(); // Set loading state
    try {
      final newCharacterUseCase = ref.read(newCharacterUsecasesProvider);
      final fetchedCharacters =
          await newCharacterUseCase.fetchSubmittedCharacters();

      submittedCharacters = fetchedCharacters; // Update the list of characters
      state = const AsyncValue.data(null); // Notify listeners of success
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace); // Notify listeners of error
    }
  }
}
