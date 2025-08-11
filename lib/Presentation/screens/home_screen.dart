import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'characters_screen.dart';
import 'new_character_screen.dart';
import '../../l10n/generated/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const CharacterScreen(),
    const NewCharacterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      AppLocalizations.of(context)?.charactersListTitle ?? "Characters",
      AppLocalizations.of(context)?.createCharacterTitle ?? "Create Character",
    ];

    final List<NavigationDestination> destinations = [
      const NavigationDestination(
        icon: Icon(Icons.people_outline),
        selectedIcon: Icon(Icons.people),
        label: 'Characters',
      ),
      const NavigationDestination(
        icon: Icon(Icons.add_circle_outline),
        selectedIcon: Icon(Icons.add_circle),
        label: 'Create',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: destinations,
        elevation: 0,
        height: 80,
      ),
    );
  }
}
