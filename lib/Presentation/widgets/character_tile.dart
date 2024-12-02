import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rick_and_morty_app/Core/utils/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../Domain/entities/character.dart';

class CharacterTile extends StatelessWidget {
  final Character character;
  final int index;

  const CharacterTile(
      {super.key, required this.character, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 5.0,
        shadowColor: (character.species == 'Human')
            ? AppColors.secondary
            : AppColors.secondaryDark,
        child: ListTile(
          style: ListTileStyle.drawer,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: character.image,
              placeholder: (context, url) => Skeletonizer(
                  enabled: character.name.isEmpty,
                  child: const Placeholder(
                    child: Icon(Icons.image),
                  )),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          title: Text(character.name),
          subtitle: Text(character.species),
        )
            .animate()
            .fadeIn(duration: 300.ms)
            .slideY(begin: 0.1, end: 0, duration: (200 + index * 100).ms),
      ), // Fade and Slide animation for each item
    );
  }
}
