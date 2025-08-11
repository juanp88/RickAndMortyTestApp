import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rick_and_morty_app/Presentation/widgets/form_widget.dart';
import 'package:rick_and_morty_app/Presentation/widgets/new_characters_listview.dart';
import 'package:rick_and_morty_app/Presentation/widgets/animated_background.dart';
import 'package:rick_and_morty_app/Presentation/widgets/glass_card.dart';
import 'package:rick_and_morty_app/Presentation/widgets/gradient_button.dart';

import '../viewmodels/new_character_screen_viewmodel.dart';

class NewCharacterScreen extends ConsumerStatefulWidget {
  const NewCharacterScreen({super.key});

  @override
  ConsumerState<NewCharacterScreen> createState() => _NewCharacterScreenState();
}

class _NewCharacterScreenState extends ConsumerState<NewCharacterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _species = '';
  String _status = '';
  String? _imageUrl;
  bool _isImageUploading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Character created successfully!'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }

        // Clear form
        _formKey.currentState!.reset();
        setState(() {
          _name = '';
          _species = '';
          _status = '';
          _imageUrl = null;
        });

        // Switch to the list tab to show the new character
        _tabController.animateTo(1);
      } catch (e) {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Failed to create character: $e')),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModelState = ref.watch(newCharacterViewModelProvider);
    final theme = Theme.of(context);

    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Animated header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                        'Create Your',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3748),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.2, end: 0),
                  Text(
                        'Dream Character',
                        style: theme.textTheme.headlineSmall?.copyWith(
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

            // Tab bar with glassmorphism
            Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: GlassCard(
                    padding: const EdgeInsets.all(4),
                    borderRadius: 16,
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6BE9F8), Color(0xFF7185F6)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6BE9F8).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.add_circle_outline),
                          text: 'Create',
                        ),
                        Tab(
                          icon: Icon(Icons.auto_awesome),
                          text: 'My Characters',
                        ),
                      ],
                    ),
                  ),
                )
                .animate(delay: 400.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0),

            // Tab views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Create character tab
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Image picker section with glassmorphism
                        GlassCard(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF6BE9F8),
                                              Color(0xFF7185F6),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.photo_camera,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Character Image',
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  GestureDetector(
                                        onTap: _pickImage,
                                        child: Container(
                                          height: 180,
                                          width: 180,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            gradient: _imageUrl != null
                                                ? null
                                                : LinearGradient(
                                                    colors: [
                                                      Colors.white.withOpacity(
                                                        0.1,
                                                      ),
                                                      Colors.white.withOpacity(
                                                        0.05,
                                                      ),
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.3,
                                              ),
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 20,
                                                offset: const Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: _isImageUploading
                                              ? Center(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          20,
                                                        ),
                                                    decoration:
                                                        const BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                    0xFF6BE9F8,
                                                                  ),
                                                                  Color(
                                                                    0xFF7185F6,
                                                                  ),
                                                                ],
                                                              ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                    child: const CircularProgressIndicator(
                                                      strokeWidth: 3,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(Colors.white),
                                                    ),
                                                  ),
                                                )
                                              : _imageUrl != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                  child: Image.network(
                                                    _imageUrl!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            16,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            const LinearGradient(
                                                              colors: [
                                                                Color(
                                                                  0xFF6BE9F8,
                                                                ),
                                                                Color(
                                                                  0xFF7185F6,
                                                                ),
                                                              ],
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: const Icon(
                                                        Icons
                                                            .add_photo_alternate,
                                                        size: 32,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Text(
                                                      'Tap to add image',
                                                      style: theme
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                    Text(
                                                      'Make it awesome!',
                                                      style: theme
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            color: theme
                                                                .colorScheme
                                                                .onSurfaceVariant,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      )
                                      .animate()
                                      .scale(duration: 600.ms)
                                      .then()
                                      .shimmer(
                                        duration: 2000.ms,
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                  const SizedBox(height: 20),
                                  if (_imageUrl == null)
                                    GradientButton(
                                      text: 'Upload Image',
                                      icon: Icons.cloud_upload,
                                      onPressed: _isImageUploading
                                          ? null
                                          : _pickImage,
                                      isLoading: _isImageUploading,
                                    ),
                                ],
                              ),
                            )
                            .animate(delay: 600.ms)
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                        const SizedBox(height: 20),

                        // Form section
                        FormWidget(
                              formKey: _formKey,
                              onNameChanged: (value) => _name = value,
                              onSpeciesChanged: (value) => _species = value,
                              onStatusChanged: (value) => _status = value,
                              onSubmit: _submitCharacter,
                              isLoading: viewModelState.isLoading,
                            )
                            .animate(delay: 800.ms)
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                      ],
                    ),
                  ),

                  // My characters tab
                  const NewCharactersListView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
