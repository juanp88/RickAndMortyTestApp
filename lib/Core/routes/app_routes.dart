import 'package:flutter/material.dart';

import '../../Presentation/screens/characters_screen.dart';
import '../../Presentation/screens/new_character_screen.dart';
import '../../Presentation/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String characters = '/characters';
  static const String newCharacter = '/characters/new';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case characters:
        return MaterialPageRoute(builder: (_) => const CharacterScreen());
      case newCharacter:
        return MaterialPageRoute(builder: (_) => const NewCharacterScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
