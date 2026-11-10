/// Data model for a single Bhagavad Gita shloka (verse).
class Shloka {
  final String id; // e.g. "2.47"
  final int chapter;
  final int verse;
  final String sanskritText;
  final String transliteration;
  final String hindiTranslation;
  final String englishTranslation;
  final String explanation;
  final String context;
  final List<String> topics;
  final List<String> relatedVerseIds;
  final String translationAttribution;
  final List<WordMeaning> wordMeanings;

  const Shloka({
    required this.id,
    required this.chapter,
    required this.verse,
    required this.sanskritText,
    required this.transliteration,
    required this.hindiTranslation,
    required this.englishTranslation,
    required this.explanation,
    required this.context,
    required this.topics,
    required this.relatedVerseIds,
    required this.translationAttribution,
    required this.wordMeanings,
  });

  String get chapterVerse => '$chapter.$verse';

  factory Shloka.fromJson(Map<String, dynamic> json) {
    return Shloka(
      id: json['id'] as String? ?? '${json['chapter']}.${json['verse']}',
      chapter: json['chapter'] as int? ?? 1,
      verse: json['verse'] as int? ?? 1,
      sanskritText: json['sanskrit_text'] as String? ?? json['sanskritText'] as String? ?? '',
      transliteration: json['transliteration'] as String? ?? '',
      hindiTranslation: json['hindi_translation'] as String? ?? json['hindiTranslation'] as String? ?? '',
      englishTranslation: json['english_translation'] as String? ?? json['englishTranslation'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      context: json['context'] as String? ?? '',
      topics: (json['topics'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      relatedVerseIds: (json['related_verse_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      translationAttribution: json['translation_attribution'] as String? ?? json['translationAttribution'] as String? ?? '',
      wordMeanings: (json['word_meanings'] as List<dynamic>?)
              ?.map((e) => WordMeaning.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'chapter': chapter,
        'verse': verse,
        'sanskrit_text': sanskritText,
        'transliteration': transliteration,
        'hindi_translation': hindiTranslation,
        'english_translation': englishTranslation,
        'explanation': explanation,
        'context': context,
        'topics': topics,
        'related_verse_ids': relatedVerseIds,
        'translation_attribution': translationAttribution,
        'word_meanings': wordMeanings.map((e) => e.toJson()).toList(),
      };
}

/// A single word-by-word meaning entry.
class WordMeaning {
  final String sanskrit;
  final String meaning;

  const WordMeaning({
    required this.sanskrit,
    required this.meaning,
  });

  factory WordMeaning.fromJson(Map<String, dynamic> json) {
    return WordMeaning(
      sanskrit: json['sanskrit'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'sanskrit': sanskrit,
        'meaning': meaning,
      };
}

/// Data model for a Bhagavad Gita chapter.
class GeetaChapter {
  final int number;
  final String titleSanskrit;
  final String titleHindi;
  final String titleEnglish;
  final String description;
  final int verseCount;
  final double readingProgress; // 0.0 to 1.0

  const GeetaChapter({
    required this.number,
    required this.titleSanskrit,
    required this.titleHindi,
    required this.titleEnglish,
    required this.description,
    required this.verseCount,
    this.readingProgress = 0.0,
  });

  factory GeetaChapter.fromJson(Map<String, dynamic> json) {
    return GeetaChapter(
      number: json['number'] as int? ?? 1,
      titleSanskrit: json['title_sanskrit'] as String? ?? json['titleSanskrit'] as String? ?? '',
      titleHindi: json['title_hindi'] as String? ?? json['titleHindi'] as String? ?? '',
      titleEnglish: json['title_english'] as String? ?? json['titleEnglish'] as String? ?? '',
      description: json['description'] as String? ?? '',
      verseCount: json['verse_count'] as int? ?? json['verseCount'] as int? ?? 0,
      readingProgress: (json['reading_progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'title_sanskrit': titleSanskrit,
        'title_hindi': titleHindi,
        'title_english': titleEnglish,
        'description': description,
        'verse_count': verseCount,
        'reading_progress': readingProgress,
      };
}

/// A topic tag for discovery and filtering.
class GeetaTopic {
  final String id;
  final String nameEnglish;
  final String nameHindi;
  final String description;

  const GeetaTopic({
    required this.id,
    required this.nameEnglish,
    required this.nameHindi,
    required this.description,
  });

  factory GeetaTopic.fromJson(Map<String, dynamic> json) {
    return GeetaTopic(
      id: json['id'] as String? ?? '',
      nameEnglish: json['name_english'] as String? ?? json['nameEnglish'] as String? ?? '',
      nameHindi: json['name_hindi'] as String? ?? json['nameHindi'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_english': nameEnglish,
        'name_hindi': nameHindi,
        'description': description,
      };
}

/// A single chat message in the study assistant.
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime? timestamp;
  final List<SourceReference>? sources;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    this.timestamp,
    this.sources,
  });
}

/// A source reference for an AI response.
class SourceReference {
  final String title;
  final String author;
  final String verseRef;
  final String language;

  const SourceReference({
    required this.title,
    required this.author,
    required this.verseRef,
    required this.language,
  });
}

/// Subscription tier model.
class SubscriptionPlan {
  final String id;
  final String name;
  final int monthlyPriceINR;
  final int annualPriceINR;
  final List<String> features;
  final bool isPopular;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.monthlyPriceINR,
    required this.annualPriceINR,
    required this.features,
    this.isPopular = false,
  });
}
