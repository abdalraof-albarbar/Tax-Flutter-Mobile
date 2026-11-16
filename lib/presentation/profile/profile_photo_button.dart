import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/localization.dart';
import '../../core/profile_style.dart';
import '../../core/theme.dart';
import 'inspector_avatar.dart';

class ProfilePhotoButton extends StatefulWidget {
  const ProfilePhotoButton({super.key, this.photo, this.onPressed});
  final Uint8List? photo;
  final VoidCallback? onPressed;
  @override
  State<ProfilePhotoButton> createState() => _ProfilePhotoButtonState();
}

class _ProfilePhotoButtonState extends State<ProfilePhotoButton> {
  bool pressed = false, focused = false;
  @override
  Widget build(BuildContext context) => Material(
    color: ProfileTokens.clear,
    child: InkWell(
      onTap: widget.onPressed,
      onHighlightChanged: (value) => setState(() => pressed = value),
      onFocusChange: (value) => setState(() => focused = value),
      borderRadius: BorderRadius.circular(Space.controlRadius),
      splashColor: ProfileTokens.splash,
      child: AnimatedScale(
        scale: pressed && !MediaQuery.disableAnimationsOf(context)
            ? ProfileTokens.pressScale
            : 1,
        duration: ProfileTokens.duration(context),
        curve: ProfileTokens.curve,
        child: Padding(
          padding: const EdgeInsets.all(Space.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: ProfileTokens.duration(context),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (focused)
                      const BoxShadow(
                        color: Palette.deepTeal,
                        spreadRadius: ProfileTokens.focusSpread,
                      ),
                  ],
                ),
                child: Stack(
                  children: [
                    InspectorAvatar(
                      photo: widget.photo,
                      size: ProfileTokens.avatarSize,
                      hero: true,
                    ),
                    PositionedDirectional(
                      end: 0,
                      bottom: 0,
                      child: ExcludeSemantics(
                        child: Container(
                          width: ProfileTokens.cameraBadge,
                          height: ProfileTokens.cameraBadge,
                          decoration: BoxDecoration(
                            color: widget.onPressed == null
                                ? Palette.muted
                                : Palette.deepTeal,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Palette.white,
                              width: ProfileTokens.focusWidth,
                            ),
                          ),
                          child: const Icon(
                            Icons.photo_camera_outlined,
                            color: Palette.white,
                            size: ProfileTokens.cameraIcon,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Space.sm),
              Text(
                context.tr('تغيير الصورة', 'Change photo'),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: widget.onPressed == null
                      ? Palette.muted
                      : Palette.deepTeal,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
