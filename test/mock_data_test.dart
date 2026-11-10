import 'package:flutter_test/flutter_test.dart';
import 'package:scrollgeets/data/mock_data.dart';
import 'package:scrollgeets/shared/models/models.dart';

void main() {
  group('MockData Scripture Dataset Audit Tests', () {
    test('Dataset contains exactly 12 shlokas', () {
      expect(MockData.shlokas.length, 12);
    });

    test('All shlokas have valid unique IDs matching chapter.verse pattern', () {
      final ids = <String>{};
      for (final shloka in MockData.shlokas) {
        expect(ids.contains(shloka.id), isFalse, reason: 'Duplicate ID: ${shloka.id}');
        ids.add(shloka.id);
        expect(shloka.id, '${shloka.chapter}.${shloka.verse}');
        expect(shloka.chapter, inInclusiveRange(1, 18));
        expect(shloka.verse, greaterThan(0));
      }
    });

    test('All shlokas have verified non-empty textual content and attribution', () {
      for (final s in MockData.shlokas) {
        expect(s.sanskritText.trim().isNotEmpty, isTrue, reason: '${s.id} sanskritText empty');
        expect(s.transliteration.trim().isNotEmpty, isTrue, reason: '${s.id} transliteration empty');
        expect(s.englishTranslation.trim().isNotEmpty, isTrue, reason: '${s.id} englishTranslation empty');
        expect(s.hindiTranslation.trim().isNotEmpty, isTrue, reason: '${s.id} hindiTranslation empty');
        expect(s.explanation.trim().isNotEmpty, isTrue, reason: '${s.id} explanation empty');
        expect(s.context.trim().isNotEmpty, isTrue, reason: '${s.id} context empty');
        expect(s.translationAttribution.isNotEmpty, isTrue, reason: '${s.id} attribution empty');
        expect(s.wordMeanings, isNotEmpty, reason: '${s.id} has no word meanings');
      }
    });

    test('All 18 chapters are enumerated with metadata', () {
      expect(MockData.chapters.length, 18);
      final numbers = MockData.chapters.map((c) => c.number).toList();
      expect(numbers, List.generate(18, (i) => i + 1));

      for (final ch in MockData.chapters) {
        expect(ch.titleSanskrit.isNotEmpty, isTrue);
        expect(ch.titleEnglish.isNotEmpty, isTrue);
        expect(ch.description.isNotEmpty, isTrue);
        expect(ch.verseCount, greaterThan(0));
      }
    });

    test('findShloka returns correct verse or null', () {
      final s247 = MockData.findShloka('2.47');
      expect(s247, isNotNull);
      expect(s247!.chapter, 2);
      expect(s247.verse, 47);

      final nonExistent = MockData.findShloka('99.99');
      expect(nonExistent, isNull);
    });

    test('shlokasByChapter filters correctly', () {
      final ch2 = MockData.shlokasByChapter(2);
      expect(ch2.length, 4);
      for (final s in ch2) {
        expect(s.chapter, 2);
      }

      final ch1 = MockData.shlokasByChapter(1);
      expect(ch1, isEmpty, reason: 'Chapter 1 has 0 sample verses');
    });

    test('shlokasByTopic filters correctly', () {
      final karmaVerses = MockData.shlokasByTopic('karma');
      expect(karmaVerses, isNotEmpty);
      for (final s in karmaVerses) {
        expect(s.topics, contains('karma'));
      }
    });

    test('Shloka and GeetaChapter JSON serialization roundtrips successfully', () {
      final sample = MockData.shlokas.first;
      final jsonMap = sample.toJson();
      final fromJson = Shloka.fromJson(jsonMap);

      expect(fromJson.id, sample.id);
      expect(fromJson.chapter, sample.chapter);
      expect(fromJson.verse, sample.verse);
      expect(fromJson.sanskritText, sample.sanskritText);
      expect(fromJson.englishTranslation, sample.englishTranslation);
      expect(fromJson.wordMeanings.length, sample.wordMeanings.length);

      final chapter = MockData.chapters.first;
      final chMap = chapter.toJson();
      final chFromJson = GeetaChapter.fromJson(chMap);
      expect(chFromJson.number, chapter.number);
      expect(chFromJson.titleEnglish, chapter.titleEnglish);
      expect(chFromJson.titleSanskrit, chapter.titleSanskrit);
    });
  });
}
