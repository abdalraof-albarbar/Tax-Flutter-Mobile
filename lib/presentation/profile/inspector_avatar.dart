import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/theme.dart';

class InspectorAvatar extends StatelessWidget {
  const InspectorAvatar({
    super.key,
    this.photo,
    this.size = Space.avatar,
    this.hero = false,
  });
  final Uint8List? photo;
  final double size;
  final bool hero;
  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Palette.mint,
        border: Border.all(color: Palette.white, width: Space.xs),
      ),
      child: ClipOval(
        child: photo == null
            ? Icon(
                Icons.person_outline_rounded,
                color: Palette.deepTeal,
                size: size / 2,
              )
            : Image.memory(
                photo!,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                errorBuilder: (_, _, _) => Icon(
                  Icons.person_outline_rounded,
                  color: Palette.deepTeal,
                  size: size / 2,
                ),
              ),
      ),
    );
    return ExcludeSemantics(
      child: hero
          ? HeroMode(
              enabled: !MediaQuery.disableAnimationsOf(context),
              child: Hero(tag: 'inspector-avatar', child: avatar),
            )
          : avatar,
    );
  }
}
