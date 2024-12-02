import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_app/Presentation/screens/home_screen.dart';

import '../viewmodels/character_screen_viewmodel.dart';
import '../widgets/fade_transition.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Preload data
    await ref
        .read(characterViewModelProvider.notifier)
        .fetchCharacters(page: 1);
    FlutterNativeSplash.remove();

    // Navigate to the main screen with a fade transition
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          FadeTransitionPage(page: const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Keep this empty since the native splash screen handles the visuals.
    return const SizedBox.shrink();
  }
}
