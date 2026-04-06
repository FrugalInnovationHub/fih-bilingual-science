class LessonCard {
  final String textEn;
  final String textEs;
  final String imageAssetPath;

  const LessonCard({
    required this.textEn,
    required this.textEs,
    required this.imageAssetPath,
  });
}

class Lesson {
  final int id;
  final String titleEn;
  final String titleEs;
  // Typo fixed here: was 'cover assetPath'
  final String coverAssetPath;
  final List<LessonCard> cards;

  const Lesson({
    required this.id,
    required this.titleEn,
    required this.titleEs,
    required this.coverAssetPath,
    required this.cards,
  });
}