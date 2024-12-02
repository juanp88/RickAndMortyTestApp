import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_app/Core/utils/colors.dart';
import 'package:rick_and_morty_app/Presentation/widgets/custom_text_button.dart';
import 'package:rick_and_morty_app/Presentation/widgets/form_widget.dart';
import 'package:rick_and_morty_app/Presentation/widgets/new_characters_listview.dart';

import '../viewmodels/new_character_screen_viewmodel.dart';

class NewCharacterScreen extends ConsumerStatefulWidget {
  const NewCharacterScreen({super.key});

  @override
  ConsumerState<NewCharacterScreen> createState() => _NewCharacterScreenState();
}

class _NewCharacterScreenState extends ConsumerState<NewCharacterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _species = '';
  String _status = '';
  String? _imageUrl;
  bool _isImageUploading = false;

  void _pickImage() async {
    setState(() {
      _isImageUploading = true;
    });

    final viewModel = ref.read(newCharacterViewModelProvider.notifier);
    final uploadedImageUrl = await viewModel.pickAndUploadImage();

    setState(() {
      _imageUrl = uploadedImageUrl;
      _isImageUploading = false;
    });
  }

  void _submitCharacter() async {
    if (_formKey.currentState!.validate()) {
      try {
        final viewModel = ref.read(newCharacterViewModelProvider.notifier);

        await viewModel.submitCharacter(
          name: _name,
          species: _species,
          status: _status,
          imageUrl: _imageUrl,
        );

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Character submitted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Clear form or navigate away
        _formKey.currentState!.reset();
        setState(() {
          _name = '';
          _species = '';
          _status = '';
          _imageUrl = null;
        });
      } catch (e) {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit character: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModelState = ref.watch(newCharacterViewModelProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                height: 200,
                width: 200,
                color: AppColors.secondaryDark,
                child: _isImageUploading
                    ? const Center(child: CircularProgressIndicator())
                    : _imageUrl != null
                        ? Image.network(_imageUrl!, fit: BoxFit.cover)
                        : const Icon(Icons.image, size: 100),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextButton(
              text: "Pick an image",
              action: _pickImage,
              // isLoading: _isImageUploading,
            ),
            FormWidget(
              formKey: _formKey,
              onNameChanged: (value) => _name = value,
              onSpeciesChanged: (value) => _species = value,
              onStatusChanged: (value) => _status = value,
              onSubmit: _submitCharacter,
              isLoading: viewModelState.isLoading,
            ),
            const NewCharactersListView()
          ],
        ),
      ),
    );
  }
}
