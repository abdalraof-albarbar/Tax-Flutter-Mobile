class BilingualText {
  const BilingualText(this.arabic, this.english);
  final String arabic, english;
  String text(bool arabicLocale) => arabicLocale ? arabic : english;
}

class GuideStep {
  const GuideStep(this.title, this.description, this.image);
  final BilingualText title, description;
  final String image;
}

class HelpArticle {
  const HelpArticle(this.id, this.question, this.answer);
  final String id;
  final BilingualText question, answer;
}

class DemoNotification {
  const DemoNotification(this.id, this.title, this.description);
  final String id;
  final BilingualText title, description;
}
