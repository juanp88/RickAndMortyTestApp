import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_app/Core/utils/colors.dart';
import 'characters_screen.dart';
import 'new_character_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      AppLocalizations.of(context)?.charactersListTitle ?? "",
      AppLocalizations.of(context)?.createCharacterTitle ?? "",
      // S.of(context).createCharacterTitle, // Title for the New Character tab
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
      ),
      body: _tabs[_currentIndex], // Display the screen based on the index
      bottomNavigationBar: BottomBarInspiredOutside(
        items: const [
          TabItem(icon: Icons.home, title: 'Characters'),
          TabItem(icon: Icons.favorite, title: 'New Character'),
        ],
        top: -28,
        itemStyle: ItemStyle.circle,
        chipStyle: const ChipStyle(background: AppColors.third),
        backgroundColor: AppColors.third,
        color: AppColors.primary,
        colorSelected: AppColors.primary,
        indexSelected: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Change the screen based on selected tab
          });
        },
      ),
    );
  }
}
