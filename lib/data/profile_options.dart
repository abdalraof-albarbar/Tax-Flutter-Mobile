import '../domain/visit.dart';

class TextSizeOption {
  const TextSizeOption(this.scale, this.arabic, this.english);
  final double scale;
  final String arabic, english;
}

abstract final class ProfileOptions {
  static const languages = <NamedOption>[
    NamedOption('ar', 'العربية', 'Arabic'),
    NamedOption('en', 'الإنجليزية', 'English'),
  ];
  static const textSizes = <TextSizeOption>[
    TextSizeOption(1, 'عادي', 'Standard'),
    TextSizeOption(1.15, 'مريح', 'Comfortable'),
    TextSizeOption(1.3, 'كبير', 'Large'),
  ];
}
