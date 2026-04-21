class WordBuilderWord {
  final String word;
  final String phonetic;
  final String category;

  const WordBuilderWord({
    required this.word,
    required this.phonetic,
    required this.category,
  });
}

const List<WordBuilderWord> kWordBuilderWords = [
  WordBuilderWord(word: 'water', phonetic: 'waw-ter', category: 'water'),
  WordBuilderWord(word: 'clean', phonetic: 'kleen', category: 'water'),
  WordBuilderWord(word: 'filter', phonetic: 'fil-ter', category: 'action'),
  WordBuilderWord(word: 'boil', phonetic: 'boyl', category: 'action'),
  WordBuilderWord(word: 'safe', phonetic: 'sayf', category: 'health'),
  WordBuilderWord(word: 'dirty', phonetic: 'dur-tee', category: 'water'),
  WordBuilderWord(word: 'river', phonetic: 'riv-er', category: 'water'),
  WordBuilderWord(word: 'pond', phonetic: 'pond', category: 'water'),
  WordBuilderWord(word: 'germs', phonetic: 'jurmz', category: 'health'),
  WordBuilderWord(word: 'drink', phonetic: 'dringk', category: 'action'),
  WordBuilderWord(word: 'treat', phonetic: 'treet', category: 'action'),
  WordBuilderWord(word: 'clear', phonetic: 'kleer', category: 'water'),
  WordBuilderWord(word: 'muddy', phonetic: 'mud-ee', category: 'water'),
  WordBuilderWord(word: 'pump', phonetic: 'pump', category: 'tool'),
  WordBuilderWord(word: 'flow', phonetic: 'floh', category: 'water'),
  WordBuilderWord(word: 'bucket', phonetic: 'buck-it', category: 'tool'),
  WordBuilderWord(word: 'health', phonetic: 'helth', category: 'health'),
  WordBuilderWord(word: 'wash', phonetic: 'wahsh', category: 'action'),
  WordBuilderWord(word: 'pure', phonetic: 'pyur', category: 'health'),
  WordBuilderWord(word: 'tap', phonetic: 'tap', category: 'source'),
  WordBuilderWord(word: 'soap', phonetic: 'sohp', category: 'health'),
  WordBuilderWord(word: 'store', phonetic: 'stor', category: 'action'),
  WordBuilderWord(word: 'cover', phonetic: 'kuv-er', category: 'action'),
  WordBuilderWord(word: 'rinse', phonetic: 'rins', category: 'action'),
];
