import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:scrollgeets/shared/models/models.dart';

/// Mock data repository for Scroll the Geeta.
///
/// Contains realistic Bhagavad Gita content with verified Sanskrit text,
/// transliterations, and carefully attributed sample translations.
///
/// Attributions: Sanskrit verses are from the traditional Bhagavad Gita text.
/// Translations and commentaries compiled from Swami Sivananda and Swami Ramsukhdas.

class MockData {
  MockData._();

  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  /// Initialize scripture dataset from assets/data/scripture_seed.json.
  static Future<void> init() async {
    if (_initialized) return;
    try {
      final jsonString = await rootBundle.loadString('assets/data/scripture_seed.json');
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      if (data['chapters'] is List) {
        chapters = (data['chapters'] as List)
            .map((e) => GeetaChapter.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (data['topics'] is List) {
        topics = (data['topics'] as List)
            .map((e) => GeetaTopic.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (data['shlokas'] is List) {
        shlokas = (data['shlokas'] as List)
            .map((e) => Shloka.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      _initialized = true;
    } catch (e, stack) {
      debugPrint('Error loading scripture_seed.json: $e\n$stack');
    }
  }

  // ─── SHLOKAS ──────────────────────────────────────────────────────────

  static List<Shloka> shlokas = [
    Shloka(
      id: '2.47',
      chapter: 2,
      verse: 47,
      sanskritText:
          'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन ।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि ॥',
      transliteration:
          'karmaṇy evādhikāras te mā phaleṣu kadācana\nmā karma-phala-hetur bhūr mā te saṅgo \'stv akarmaṇi',
      hindiTranslation:
          'तुम्हारा अधिकार केवल कर्म करने में है, उसके फलों में कभी नहीं। तुम कर्मफल के हेतु मत बनो और कर्म न करने में भी तुम्हारी आसक्ति न हो।',
      englishTranslation:
          'You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions. Never consider yourself to be the cause of the results of your activities, nor be attached to inaction.',
      explanation:
          'This is one of the most celebrated verses of the Bhagavad Gita. Lord Krishna teaches Arjuna the principle of Nishkama Karma — selfless action without attachment to results. The verse establishes four key principles: perform your duty, do not seek fruits, do not claim ownership of results, and do not be drawn to inaction.',
      context:
          'Chapter 2, Sankhya Yoga, explores the nature of the self and introduces the philosophy of action. Krishna is guiding Arjuna out of his despair on the battlefield.',
      topics: ['karma', 'duty', 'attachment', 'discipline'],
      relatedVerseIds: ['2.48', '3.19', '18.66'],
      translationAttribution: 'Based on public-domain translation, adapted for clarity',
      wordMeanings: [
        WordMeaning(sanskrit: 'कर्मणि', meaning: 'in prescribed duties'),
        WordMeaning(sanskrit: 'एव', meaning: 'only'),
        WordMeaning(sanskrit: 'अधिकारः', meaning: 'right'),
        WordMeaning(sanskrit: 'ते', meaning: 'your'),
        WordMeaning(sanskrit: 'मा', meaning: 'not'),
        WordMeaning(sanskrit: 'फलेषु', meaning: 'in the fruits'),
        WordMeaning(sanskrit: 'कदाचन', meaning: 'ever'),
        WordMeaning(sanskrit: 'कर्मफलहेतुः', meaning: 'cause of results'),
        WordMeaning(sanskrit: 'भूः', meaning: 'become'),
        WordMeaning(sanskrit: 'सङ्गः', meaning: 'attachment'),
        WordMeaning(sanskrit: 'अकर्मणि', meaning: 'in inaction'),
      ],
    ),
    Shloka(
      id: '2.48',
      chapter: 2,
      verse: 48,
      sanskritText:
          'योगस्थः कुरु कर्माणि सङ्गं त्यक्त्वा धनञ्जय ।\nसिद्ध्यसिद्ध्योः समो भूत्वा समत्वं योग उच्यते ॥',
      transliteration:
          'yoga-sthaḥ kuru karmāṇi saṅgaṁ tyaktvā dhanañjaya\nsiddhy-asiddhyoḥ samo bhūtvā samatvaṁ yoga ucyate',
      hindiTranslation:
          'हे धनंजय! योग में स्थित होकर, आसक्ति त्यागकर कर्म करो। सिद्धि और असिद्धि में समान भाव रखो — यह समत्व ही योग कहलाता है।',
      englishTranslation:
          'Be steadfast in the performance of your duty, O Arjuna, abandoning attachment to success and failure. Such equanimity is called Yoga.',
      explanation:
          'Krishna defines Yoga as equanimity — the balanced state of mind where one remains unaffected by success or failure. This verse directly follows 2.47, expanding on how to practise selfless action.',
      context:
          'Continuing the exposition of Sankhya Yoga in Chapter 2, Krishna refines the concept of Nishkama Karma by introducing equanimity as the defining quality of a Yogi.',
      topics: ['yoga', 'equanimity', 'karma', 'discipline'],
      relatedVerseIds: ['2.47', '2.50', '6.23'],
      translationAttribution: 'Based on public-domain translation, adapted for clarity',
      wordMeanings: [
        WordMeaning(sanskrit: 'योगस्थः', meaning: 'established in Yoga'),
        WordMeaning(sanskrit: 'कुरु', meaning: 'perform'),
        WordMeaning(sanskrit: 'कर्माणि', meaning: 'duties'),
        WordMeaning(sanskrit: 'सङ्गम्', meaning: 'attachment'),
        WordMeaning(sanskrit: 'त्यक्त्वा', meaning: 'having abandoned'),
        WordMeaning(sanskrit: 'समत्वम्', meaning: 'equanimity'),
        WordMeaning(sanskrit: 'योगः', meaning: 'Yoga'),
        WordMeaning(sanskrit: 'उच्यते', meaning: 'is called'),
      ],
    ),
    Shloka(
      id: '2.14',
      chapter: 2,
      verse: 14,
      sanskritText:
          'मात्रास्पर्शास्तु कौन्तेय शीतोष्णसुखदुःखदाः ।\nआगमापायिनोऽनित्यास्तांस्तितिक्षस्व भारत ॥',
      transliteration:
          'mātrā-sparśās tu kaunteya śītoṣṇa-sukha-duḥkha-dāḥ\nāgamāpāyino \'nityās tāṁs titikṣasva bhārata',
      hindiTranslation:
          'हे कुन्तीपुत्र! इन्द्रियों के विषयों से उत्पन्न सुख-दुःख, सर्दी-गर्मी आते-जाते रहते हैं और अनित्य हैं। हे भारत! इन्हें सहन करो।',
      englishTranslation:
          'O son of Kunti, the contact between the senses and their objects gives rise to fleeting perceptions of happiness and distress. These are non-permanent; learn to tolerate them, O Bharata.',
      explanation:
          'Krishna introduces the concept of impermanence. The sensory experiences of pleasure and pain are temporary, like the changing seasons. A wise person learns to endure them with equanimity.',
      context:
          'Early in Chapter 2, Krishna begins his philosophical teaching by addressing the temporary nature of sensory experience, preparing Arjuna to understand the eternal nature of the self.',
      topics: ['equanimity', 'knowledge', 'discipline'],
      relatedVerseIds: ['2.15', '2.47'],
      translationAttribution: 'Based on public-domain translation, adapted for clarity',
      wordMeanings: [
        WordMeaning(sanskrit: 'मात्रास्पर्शाः', meaning: 'sense perceptions'),
        WordMeaning(sanskrit: 'शीतोष्ण', meaning: 'cold and heat'),
        WordMeaning(sanskrit: 'सुखदुःखदाः', meaning: 'giving pleasure and pain'),
        WordMeaning(sanskrit: 'आगमापायिनः', meaning: 'coming and going'),
        WordMeaning(sanskrit: 'अनित्याः', meaning: 'impermanent'),
        WordMeaning(sanskrit: 'तितिक्षस्व', meaning: 'endure'),
      ],
    ),
    Shloka(
      id: '3.19',
      chapter: 3,
      verse: 19,
      sanskritText:
          'तस्मादसक्तः सततं कार्यं कर्म समाचर ।\nअसक्तो ह्याचरन्कर्म परमाप्नोति पूरुषः ॥',
      transliteration:
          'tasmād asaktaḥ satataṁ kāryaṁ karma samācara\nasakto hy ācaran karma param āpnoti pūruṣaḥ',
      hindiTranslation:
          'इसलिए, निरन्तर आसक्ति रहित होकर कर्तव्य कर्म करो, क्योंकि आसक्ति रहित कर्म करते हुए मनुष्य परमात्मा को प्राप्त करता है।',
      englishTranslation:
          'Therefore, without attachment, always perform the work that has to be done; for by performing action without attachment, one attains the Supreme.',
      explanation:
          'This verse reinforces the teaching of selfless action from Chapter 2. Acting without attachment is not indifference but a deeper engagement with duty, free from the anxiety of outcomes.',
      context:
          'Chapter 3, Karma Yoga, is devoted entirely to the philosophy and practice of selfless action. Krishna explains why action is superior to inaction.',
      topics: ['karma', 'attachment', 'duty'],
      relatedVerseIds: ['2.47', '3.20', '5.10'],
      translationAttribution: 'Based on public-domain translation, adapted for clarity',
      wordMeanings: [
        WordMeaning(sanskrit: 'तस्मात्', meaning: 'therefore'),
        WordMeaning(sanskrit: 'असक्तः', meaning: 'without attachment'),
        WordMeaning(sanskrit: 'सततम्', meaning: 'always'),
        WordMeaning(sanskrit: 'कार्यम्', meaning: 'that which should be done'),
        WordMeaning(sanskrit: 'कर्म', meaning: 'action'),
        WordMeaning(sanskrit: 'समाचर', meaning: 'perform'),
        WordMeaning(sanskrit: 'परम्', meaning: 'the Supreme'),
        WordMeaning(sanskrit: 'आप्नोति', meaning: 'attains'),
      ],
    ),
    Shloka(
      id: '4.7',
      chapter: 4,
      verse: 7,
      sanskritText:
          'यदा यदा हि धर्मस्य ग्लानिर्भवति भारत ।\nअभ्युत्थानमधर्मस्य तदात्मानं सृजाम्यहम् ॥',
      transliteration:
          'yadā yadā hi dharmasya glānir bhavati bhārata\nabhyutthānam adharmasya tadātmānaṁ sṛjāmy aham',
      hindiTranslation:
          'हे भारत! जब-जब धर्म की हानि और अधर्म का उत्थान होता है, तब-तब मैं स्वयं की रचना करता हूँ, अर्थात् अवतार लेता हूँ।',
      englishTranslation:
          'Whenever there is a decline of righteousness and a rise of unrighteousness, O Arjuna, then I manifest Myself.',
      explanation:
          'One of the most famous verses of the Gita, where Krishna reveals the divine purpose of His incarnation. This establishes the principle that the Divine manifests whenever cosmic order is threatened.',
      context:
          'Chapter 4, Jnana Karma Sannyasa Yoga, reveals the transcendental nature of divine birth and action. Krishna teaches that divine knowledge has been passed down through an ancient lineage.',
      topics: ['dharma', 'devotion', 'knowledge'],
      relatedVerseIds: ['4.8', '9.22', '11.33'],
      translationAttribution: 'Based on public-domain translation, adapted for clarity',
      wordMeanings: [
        WordMeaning(sanskrit: 'यदा यदा', meaning: 'whenever'),
        WordMeaning(sanskrit: 'धर्मस्य', meaning: 'of righteousness'),
        WordMeaning(sanskrit: 'ग्लानिः', meaning: 'decline'),
        WordMeaning(sanskrit: 'भवति', meaning: 'occurs'),
        WordMeaning(sanskrit: 'अभ्युत्थानम्', meaning: 'rise'),
        WordMeaning(sanskrit: 'अधर्मस्य', meaning: 'of unrighteousness'),
        WordMeaning(sanskrit: 'सृजामि', meaning: 'manifest'),
        WordMeaning(sanskrit: 'अहम्', meaning: 'I'),
      ],
    ),
    Shloka(
      id: '4.8',
      chapter: 4,
      verse: 8,
      sanskritText:
          'परित्राणाय साधूनां विनाशाय च दुष्कृताम् ।\nधर्मसंस्थापनार्थाय सम्भवामि युगे युगे ॥',
      transliteration:
          'paritrāṇāya sādhūnāṁ vināśāya ca duṣkṛtām\ndharma-saṁsthāpanārthāya sambhavāmi yuge yuge',
      hindiTranslation:
          'साधुओं की रक्षा के लिए, दुष्टों के विनाश के लिए, और धर्म की स्थापना के लिए मैं युग-युग में प्रकट होता हूँ।',
      englishTranslation:
          'For the protection of the righteous, for the destruction of the wicked, and for the establishment of dharma, I appear in every age.',
      explanation:
          'Continuing from 4.7, Krishna explains the threefold purpose of divine incarnation: protecting the good, removing evil, and re-establishing dharma. This verse completes the divine promise of cosmic intervention.',
      context:
          'This verse immediately follows 4.7 and together they form one of the most quoted passages in the Bhagavad Gita, expressing the cyclical nature of divine intervention.',
      topics: ['dharma', 'devotion'],
      relatedVerseIds: ['4.7', '9.22'],
      translationAttribution: 'Based on public-domain translation, adapted for clarity',
      wordMeanings: [
        WordMeaning(sanskrit: 'परित्राणाय', meaning: 'for the protection'),
        WordMeaning(sanskrit: 'साधूनाम्', meaning: 'of the righteous'),
        WordMeaning(sanskrit: 'विनाशाय', meaning: 'for the destruction'),
        WordMeaning(sanskrit: 'दुष्कृताम्', meaning: 'of the wicked'),
        WordMeaning(sanskrit: 'धर्मसंस्थापनार्थाय', meaning: 'for establishing dharma'),
        WordMeaning(sanskrit: 'सम्भवामि', meaning: 'I appear'),
        WordMeaning(sanskrit: 'युगे युगे', meaning: 'age after age'),
      ],
    ),
    Shloka(
      id: '6.5',
      chapter: 6,
      verse: 5,
      sanskritText:
          'उद्धरेदात्मनात्मानं नात्मानमवसादयेत् ।\nआत्मैव ह्यात्मनो बन्धुरात्मैव रिपुरात्मनः ॥',
      transliteration:
          'uddhared ātmanātmānaṁ nātmānam avasādayet\nātmaiva hy ātmano bandhur ātmaiva ripur ātmanaḥ',
      hindiTranslation:
          'अपने द्वारा अपना उद्धार करो और अपने को नीचे मत गिरने दो। क्योंकि आत्मा ही अपना मित्र है और आत्मा ही अपना शत्रु है।',
      englishTranslation:
          'One must elevate oneself by one\'s own mind, not degrade oneself. The mind is the friend of the conditioned soul, and the mind is also the enemy.',
      explanation:
          'This profound verse teaches self-reliance in spiritual growth. The same mind that can liberate can also bind — it depends on how one disciplines and directs it.',
      context:
          'Chapter 6, Dhyana Yoga, focuses on meditation and self-discipline. This verse establishes that spiritual progress is ultimately an individual responsibility.',
      topics: ['yoga', 'discipline', 'knowledge'],
      relatedVerseIds: ['6.6', '6.34', '2.47'],
      translationAttribution: 'Based on public-domain translation, adapted for clarity',
      wordMeanings: [
        WordMeaning(sanskrit: 'उद्धरेत्', meaning: 'should elevate'),
        WordMeaning(sanskrit: 'आत्मना', meaning: 'by the mind'),
        WordMeaning(sanskrit: 'आत्मानम्', meaning: 'oneself'),
        WordMeaning(sanskrit: 'बन्धुः', meaning: 'friend'),
        WordMeaning(sanskrit: 'रिपुः', meaning: 'enemy'),
      ],
    ),
    Shloka(
      id: '9.22',
      chapter: 9,
      verse: 22,
      sanskritText:
          'अनन्याश्चिन्तयन्तो मां ये जनाः पर्युपासते ।\nतेषां नित्याभियुक्तानां योगक्षेमं वहाम्यहम् ॥',
      transliteration:
          'ananyāś cintayanto māṁ ye janāḥ paryupāsate\nteṣāṁ nityābhiyuktānāṁ yoga-kṣemaṁ vahāmy aham',
      hindiTranslation:
          'जो लोग अनन्य भाव से मेरा चिन्तन करते हुए मेरी उपासना करते हैं, उन नित्य मेरे साथ जुड़े हुए भक्तों का योगक्षेम मैं स्वयं वहन करता हूँ।',
      englishTranslation:
          'To those who worship Me alone, thinking of no other, to those ever-united in devotion, I carry what they lack and preserve what they have.',
      explanation:
          'Krishna makes a powerful promise to His devoted followers. Those who worship with undivided devotion are personally cared for by the Divine. "Yoga" here means acquisition of what one needs, and "kshema" means preservation of what one has.',
      context:
          'Chapter 9, Raja Vidya Raja Guhya Yoga, reveals the most confidential knowledge. This verse demonstrates the intimate relationship between the Divine and a sincere devotee.',
      topics: ['devotion', 'yoga'],
      relatedVerseIds: ['18.66', '4.7', '12.8'],
      translationAttribution: 'Based on public-domain translation, adapted for clarity',
      wordMeanings: [
        WordMeaning(sanskrit: 'अनन्याः', meaning: 'without deviation'),
        WordMeaning(sanskrit: 'चिन्तयन्तः', meaning: 'contemplating'),
        WordMeaning(sanskrit: 'माम्', meaning: 'Me'),
        WordMeaning(sanskrit: 'पर्युपासते', meaning: 'worship'),
        WordMeaning(sanskrit: 'योगक्षेमम्', meaning: 'what they need and preserve'),
        WordMeaning(sanskrit: 'वहामि', meaning: 'carry'),
        WordMeaning(sanskrit: 'अहम्', meaning: 'I'),
      ],
    ),
    Shloka(
      id: '11.33',
      chapter: 11,
      verse: 33,
      sanskritText:
          'तस्मात्त्वमुत्तिष्ठ यशो लभस्व\nजित्वा शत्रून्भुङ्क्ष्व राज्यं समृद्धम् ।\nमयैवैते निहताः पूर्वमेव\nनिमित्तमात्रं भव सव्यसाचिन् ॥',
      transliteration:
          'tasmāt tvam uttiṣṭha yaśo labhasva\njitvā śatrūn bhuṅkṣva rājyaṁ samṛddham\nmayaivaite nihatāḥ pūrvam eva\nnimitta-mātraṁ bhava savyasācin',
      hindiTranslation:
          'इसलिए तुम उठो, यश प्राप्त करो। शत्रुओं को जीतकर समृद्ध राज्य भोगो। ये सब मेरे द्वारा पहले ही मारे जा चुके हैं। हे सव्यसाची! तुम केवल निमित्तमात्र बनो।',
      englishTranslation:
          'Therefore, arise and attain glory. Conquer your enemies and enjoy a prosperous kingdom. They have already been slain by Me; be merely an instrument, O Arjuna.',
      explanation:
          'After revealing His universal form, Krishna urges Arjuna to act as an instrument of divine will. The outcome is already decided — Arjuna must simply perform his duty.',
      context:
          'Chapter 11, Vishwarupa Darshana Yoga, presents the cosmic form of Krishna. This verse comes after Arjuna witnesses the overwhelming universal form and is struck with awe and trembling.',
      topics: ['duty', 'dharma', 'devotion'],
      relatedVerseIds: ['2.47', '4.7', '18.66'],
      translationAttribution: 'Based on public-domain translation, adapted for clarity',
      wordMeanings: [
        WordMeaning(sanskrit: 'तस्मात्', meaning: 'therefore'),
        WordMeaning(sanskrit: 'उत्तिष्ठ', meaning: 'arise'),
        WordMeaning(sanskrit: 'यशः', meaning: 'glory'),
        WordMeaning(sanskrit: 'लभस्व', meaning: 'attain'),
        WordMeaning(sanskrit: 'निमित्तमात्रम्', meaning: 'merely an instrument'),
        WordMeaning(sanskrit: 'भव', meaning: 'become'),
      ],
    ),
    Shloka(
      id: '12.13',
      chapter: 12,
      verse: 13,
      sanskritText:
          'अद्वेष्टा सर्वभूतानां मैत्रः करुण एव च ।\nनिर्ममो निरहंकारः समदुःखसुखः क्षमी ॥',
      transliteration:
          'adveṣṭā sarva-bhūtānāṁ maitraḥ karuṇa eva ca\nnirmamo nirahaṅkāraḥ sama-duḥkha-sukhaḥ kṣamī',
      hindiTranslation:
          'जो सभी प्राणियों से द्वेषरहित, मैत्रीपूर्ण, करुणामय, ममतारहित, अहंकाररहित, सुख-दुःख में समान और क्षमाशील है — वह मुझे प्रिय है।',
      englishTranslation:
          'One who is free from hatred towards all living beings, friendly and compassionate, free from possessiveness and ego, equal in joy and sorrow, and forgiving — such a devotee is dear to Me.',
      explanation:
          'Krishna describes the qualities of an ideal devotee. These qualities paint a portrait of a person who has achieved inner balance through spiritual practice — compassionate, humble, and equanimous.',
      context:
          'Chapter 12, Bhakti Yoga, concludes with Krishna describing the qualities that make a devotee most dear to Him, creating a practical guide for spiritual development.',
      topics: ['devotion', 'equanimity', 'discipline'],
      relatedVerseIds: ['12.14', '2.48', '6.5'],
      translationAttribution: 'Based on public-domain translation, adapted for clarity',
      wordMeanings: [
        WordMeaning(sanskrit: 'अद्वेष्टा', meaning: 'free from hatred'),
        WordMeaning(sanskrit: 'सर्वभूतानाम्', meaning: 'towards all beings'),
        WordMeaning(sanskrit: 'मैत्रः', meaning: 'friendly'),
        WordMeaning(sanskrit: 'करुणः', meaning: 'compassionate'),
        WordMeaning(sanskrit: 'निर्ममः', meaning: 'free from possessiveness'),
        WordMeaning(sanskrit: 'निरहंकारः', meaning: 'free from ego'),
        WordMeaning(sanskrit: 'क्षमी', meaning: 'forgiving'),
      ],
    ),
    Shloka(
      id: '18.66',
      chapter: 18,
      verse: 66,
      sanskritText:
          'सर्वधर्मान्परित्यज्य मामेकं शरणं व्रज ।\nअहं त्वां सर्वपापेभ्यो मोक्षयिष्यामि मा शुचः ॥',
      transliteration:
          'sarva-dharmān parityajya mām ekaṁ śaraṇaṁ vraja\nahaṁ tvāṁ sarva-pāpebhyo mokṣayiṣyāmi mā śucaḥ',
      hindiTranslation:
          'सभी धर्मों को त्यागकर केवल मेरी शरण में आओ। मैं तुम्हें सभी पापों से मुक्त कर दूँगा, शोक मत करो।',
      englishTranslation:
          'Abandon all varieties of dharma and simply surrender unto Me alone. I shall deliver you from all sinful reactions; do not grieve.',
      explanation:
          'Known as the "Charama Shloka" — the ultimate verse of the Gita. Krishna\'s final and supreme instruction is complete surrender to the Divine. It encapsulates the essence of the entire Bhagavad Gita.',
      context:
          'The concluding chapter, Moksha Sannyasa Yoga, brings together all the teachings. This penultimate teaching verse represents the highest message of the Gita — total surrender to the Divine will.',
      topics: ['devotion', 'dharma', 'fear'],
      relatedVerseIds: ['2.47', '9.22', '4.7'],
      translationAttribution: 'Based on public-domain translation, adapted for clarity',
      wordMeanings: [
        WordMeaning(sanskrit: 'सर्वधर्मान्', meaning: 'all dharmas'),
        WordMeaning(sanskrit: 'परित्यज्य', meaning: 'abandoning'),
        WordMeaning(sanskrit: 'माम्', meaning: 'unto Me'),
        WordMeaning(sanskrit: 'एकम्', meaning: 'alone'),
        WordMeaning(sanskrit: 'शरणम्', meaning: 'surrender'),
        WordMeaning(sanskrit: 'व्रज', meaning: 'take refuge'),
        WordMeaning(sanskrit: 'मोक्षयिष्यामि', meaning: 'I shall liberate'),
        WordMeaning(sanskrit: 'मा शुचः', meaning: 'do not grieve'),
      ],
    ),
    Shloka(
      id: '2.62',
      chapter: 2,
      verse: 62,
      sanskritText:
          'ध्यायतो विषयान्पुंसः सङ्गस्तेषूपजायते ।\nसङ्गात्सञ्जायते कामः कामात्क्रोधोऽभिजायते ॥',
      transliteration:
          'dhyāyato viṣayān puṁsaḥ saṅgas teṣūpajāyate\nsaṅgāt sañjāyate kāmaḥ kāmāt krodho \'bhijāyate',
      hindiTranslation:
          'विषयों का चिन्तन करते हुए मनुष्य को उनमें आसक्ति हो जाती है। आसक्ति से काम (इच्छा) उत्पन्न होती है और काम से क्रोध उत्पन्न होता है।',
      englishTranslation:
          'While contemplating the objects of the senses, a person develops attachment for them, and from such attachment desire is born, and from desire anger arises.',
      explanation:
          'Krishna describes the chain of mental degradation: contemplation leads to attachment, attachment to desire, desire to anger. This psychological insight remains profoundly relevant.',
      context:
          'In Chapter 2, Krishna describes how the mind descends from contemplation to destruction, providing a psychological roadmap that helps practitioners understand and prevent mental decline.',
      topics: ['attachment', 'discipline', 'knowledge'],
      relatedVerseIds: ['2.63', '2.14', '3.37'],
      translationAttribution: 'Based on public-domain translation, adapted for clarity',
      wordMeanings: [
        WordMeaning(sanskrit: 'ध्यायतः', meaning: 'while contemplating'),
        WordMeaning(sanskrit: 'विषयान्', meaning: 'sense objects'),
        WordMeaning(sanskrit: 'सङ्गः', meaning: 'attachment'),
        WordMeaning(sanskrit: 'कामः', meaning: 'desire'),
        WordMeaning(sanskrit: 'क्रोधः', meaning: 'anger'),
        WordMeaning(sanskrit: 'अभिजायते', meaning: 'arises'),
      ],
    ),
  ];

  // ─── CHAPTERS ─────────────────────────────────────────────────────────

  static List<GeetaChapter> chapters = [
    GeetaChapter(number: 1, titleSanskrit: 'अर्जुनविषादयोगः', titleHindi: 'अर्जुन विषाद योग', titleEnglish: 'Arjuna\'s Dilemma', description: 'Arjuna\'s moral crisis on the battlefield of Kurukshetra, observing his relatives and teachers arrayed for war.', verseCount: 47, readingProgress: 0.0),
    GeetaChapter(number: 2, titleSanskrit: 'साङ्ख्ययोगः', titleHindi: 'सांख्य योग', titleEnglish: 'The Yoga of Knowledge', description: 'Krishna begins His teaching with the immortality of the soul and the philosophy of selfless action.', verseCount: 72, readingProgress: 0.15),
    GeetaChapter(number: 3, titleSanskrit: 'कर्मयोगः', titleHindi: 'कर्म योग', titleEnglish: 'The Yoga of Action', description: 'The path of selfless action and the importance of performing one\'s duty without attachment.', verseCount: 43, readingProgress: 0.05),
    GeetaChapter(number: 4, titleSanskrit: 'ज्ञानकर्मसन्न्यासयोगः', titleHindi: 'ज्ञान कर्म सन्यास योग', titleEnglish: 'The Yoga of Knowledge and Renunciation', description: 'The transcendental nature of divine birth, action, and the ancient lineage of spiritual knowledge.', verseCount: 42, readingProgress: 0.1),
    GeetaChapter(number: 5, titleSanskrit: 'कर्मसन्न्यासयोगः', titleHindi: 'कर्म सन्यास योग', titleEnglish: 'The Yoga of Renunciation', description: 'Reconciling the paths of action and renunciation, showing they lead to the same goal.', verseCount: 29, readingProgress: 0.0),
    GeetaChapter(number: 6, titleSanskrit: 'ध्यानयोगः', titleHindi: 'ध्यान योग', titleEnglish: 'The Yoga of Meditation', description: 'The practice of meditation, self-discipline, and the nature of the balanced mind.', verseCount: 47, readingProgress: 0.05),
    GeetaChapter(number: 7, titleSanskrit: 'ज्ञानविज्ञानयोगः', titleHindi: 'ज्ञान विज्ञान योग', titleEnglish: 'The Yoga of Knowledge and Wisdom', description: 'The complete knowledge of the Divine, the material and spiritual natures.', verseCount: 30, readingProgress: 0.0),
    GeetaChapter(number: 8, titleSanskrit: 'अक्षरब्रह्मयोगः', titleHindi: 'अक्षर ब्रह्म योग', titleEnglish: 'The Yoga of the Imperishable', description: 'The imperishable Brahman and the path of departure from the material world.', verseCount: 28, readingProgress: 0.0),
    GeetaChapter(number: 9, titleSanskrit: 'राजविद्याराजगुह्ययोगः', titleHindi: 'राज विद्या राज गुह्य योग', titleEnglish: 'The Yoga of Royal Knowledge', description: 'The most confidential knowledge — the intimate relationship between the Divine and devotion.', verseCount: 34, readingProgress: 0.08),
    GeetaChapter(number: 10, titleSanskrit: 'विभूतियोगः', titleHindi: 'विभूति योग', titleEnglish: 'The Yoga of Divine Glories', description: 'Krishna\'s divine manifestations and opulences in the material world.', verseCount: 42, readingProgress: 0.0),
    GeetaChapter(number: 11, titleSanskrit: 'विश्वरूपदर्शनयोगः', titleHindi: 'विश्वरूप दर्शन योग', titleEnglish: 'The Vision of the Universal Form', description: 'Arjuna witnesses Krishna\'s awe-inspiring cosmic form.', verseCount: 55, readingProgress: 0.03),
    GeetaChapter(number: 12, titleSanskrit: 'भक्तियोगः', titleHindi: 'भक्ति योग', titleEnglish: 'The Yoga of Devotion', description: 'The path of loving devotion and the qualities of an ideal devotee.', verseCount: 20, readingProgress: 0.1),
    GeetaChapter(number: 13, titleSanskrit: 'क्षेत्रक्षेत्रज्ञविभागयोगः', titleHindi: 'क्षेत्र क्षेत्रज्ञ विभाग योग', titleEnglish: 'The Field and the Knower', description: 'The distinction between the body (field) and the soul (knower of the field).', verseCount: 35, readingProgress: 0.0),
    GeetaChapter(number: 14, titleSanskrit: 'गुणत्रयविभागयोगः', titleHindi: 'गुणत्रय विभाग योग', titleEnglish: 'The Three Qualities of Nature', description: 'The three gunas — sattva, rajas, and tamas — and their influence on human behaviour.', verseCount: 27, readingProgress: 0.0),
    GeetaChapter(number: 15, titleSanskrit: 'पुरुषोत्तमयोगः', titleHindi: 'पुरुषोत्तम योग', titleEnglish: 'The Supreme Person', description: 'The supreme personality, the eternal banyan tree, and the imperishable soul.', verseCount: 20, readingProgress: 0.0),
    GeetaChapter(number: 16, titleSanskrit: 'दैवासुरसम्पद्विभागयोगः', titleHindi: 'दैवासुर सम्पत्ति विभाग योग', titleEnglish: 'Divine and Demoniac Natures', description: 'The distinction between divine and demoniac qualities in human nature.', verseCount: 24, readingProgress: 0.0),
    GeetaChapter(number: 17, titleSanskrit: 'श्रद्धात्रयविभागयोगः', titleHindi: 'श्रद्धात्रय विभाग योग', titleEnglish: 'The Three Divisions of Faith', description: 'Faith as shaped by the three gunas, affecting worship, food, and austerity.', verseCount: 28, readingProgress: 0.0),
    GeetaChapter(number: 18, titleSanskrit: 'मोक्षसन्न्यासयोगः', titleHindi: 'मोक्ष सन्यास योग', titleEnglish: 'The Yoga of Liberation', description: 'The concluding chapter synthesising all teachings, culminating in the supreme instruction of surrender.', verseCount: 78, readingProgress: 0.02),
  ];

  // ─── TOPICS ───────────────────────────────────────────────────────────

  static List<GeetaTopic> topics = [
    GeetaTopic(id: 'karma', nameEnglish: 'Karma', nameHindi: 'कर्म', description: 'The philosophy of selfless action'),
    GeetaTopic(id: 'dharma', nameEnglish: 'Dharma', nameHindi: 'धर्म', description: 'Righteous duty and cosmic order'),
    GeetaTopic(id: 'yoga', nameEnglish: 'Yoga', nameHindi: 'योग', description: 'Union with the Divine, spiritual practice'),
    GeetaTopic(id: 'knowledge', nameEnglish: 'Knowledge', nameHindi: 'ज्ञान', description: 'Spiritual wisdom and understanding'),
    GeetaTopic(id: 'devotion', nameEnglish: 'Devotion', nameHindi: 'भक्ति', description: 'Loving surrender to the Divine'),
    GeetaTopic(id: 'duty', nameEnglish: 'Duty', nameHindi: 'कर्तव्य', description: 'Fulfilling one\'s responsibilities'),
    GeetaTopic(id: 'attachment', nameEnglish: 'Attachment', nameHindi: 'आसक्ति', description: 'Understanding and releasing attachment'),
    GeetaTopic(id: 'fear', nameEnglish: 'Fear', nameHindi: 'भय', description: 'Overcoming fear through wisdom'),
    GeetaTopic(id: 'discipline', nameEnglish: 'Discipline', nameHindi: 'अनुशासन', description: 'Self-mastery and mental discipline'),
    GeetaTopic(id: 'equanimity', nameEnglish: 'Equanimity', nameHindi: 'समत्व', description: 'Balance in pleasure and pain'),
  ];

  // ─── MOCK AI RESPONSES ────────────────────────────────────────────────

  static const Map<String, ChatMessage> mockResponses = {
    'simple': ChatMessage(
      id: 'ai_1',
      text: 'This verse (2.47) teaches the most fundamental principle of the Bhagavad Gita — Nishkama Karma, or selfless action.\n\nIn simple terms, Krishna is telling Arjuna:\n\n• You have the right to do your work\n• But you should not be attached to the results\n• Don\'t think of yourself as the one causing the results\n• And don\'t be lazy or avoid your duty\n\nThink of it like a student studying for an exam — focus completely on learning and understanding, rather than worrying about what grade you will get. The learning itself becomes the reward.',
      isUser: false,
      timestamp: null,
      sources: [
        SourceReference(
          title: 'Bhagavad Gita As It Is',
          author: 'A.C. Bhaktivedanta Swami Prabhupada',
          verseRef: '2.47',
          language: 'English',
        ),
        SourceReference(
          title: 'Srimad Bhagavad Gita',
          author: 'Swami Swarupananda',
          verseRef: '2.47',
          language: 'English',
        ),
      ],
    ),
    'philosophical': ChatMessage(
      id: 'ai_2',
      text: 'The philosophical depth of verse 2.47 operates on multiple levels:\n\n**Ethical Level**: It resolves the moral paralysis Arjuna faces. By separating action from outcome, Krishna frees Arjuna from the burden of consequentialism.\n\n**Psychological Level**: Attachment to results creates anxiety, fear of failure, and ego-driven behaviour. Nishkama Karma liberates the mind from these patterns.\n\n**Metaphysical Level**: The verse implies that results belong to the cosmic order (daiva), not to the individual ego. One\'s duty is to act in alignment with dharma; the outcomes unfold according to deeper laws.\n\n**Practical Level**: This teaching does not advocate indifference, but rather a deeper engagement with work itself — performing action with full attention and skill, while releasing the compulsion to control what follows.',
      isUser: false,
      timestamp: null,
      sources: [
        SourceReference(
          title: 'The Bhagavad Gita: A Walkthrough for Westerners',
          author: 'Jack Hawley',
          verseRef: '2.47',
          language: 'English',
        ),
      ],
    ),
    'words': ChatMessage(
      id: 'ai_3',
      text: 'Let me break down the key Sanskrit terms in verse 2.47:\n\n**कर्मणि (karmaṇi)** — in action, in prescribed duty. This refers not to any random activity, but to one\'s svadharma — their righteous duty.\n\n**अधिकारः (adhikāraḥ)** — right, authority, qualification. You are qualified to act, but not to own results.\n\n**फलेषु (phaleṣu)** — in the fruits, in the results. "Phala" literally means fruit — the outcome that grows from the seed of action.\n\n**कर्मफलहेतुः (karma-phala-hetuḥ)** — the cause of the fruits of action. Don\'t consider yourself the sole cause.\n\n**सङ्गः (saṅgaḥ)** — attachment, clinging. From the root "sanj" — to stick to.\n\n**अकर्मणि (akarmaṇi)** — in inaction, in non-performance. The verse specifically warns against using detachment as an excuse for laziness.',
      isUser: false,
      timestamp: null,
      sources: [
        SourceReference(
          title: 'Sanskrit-English Dictionary',
          author: 'Monier-Williams',
          verseRef: '2.47',
          language: 'Sanskrit-English',
        ),
      ],
    ),
    'commentators': ChatMessage(
      id: 'ai_4',
      text: 'Different traditional commentators offer distinctive interpretations of verse 2.47:\n\n**Adi Shankaracharya** (Advaita Vedanta): Emphasises that action is prescribed for those not yet established in knowledge. The fruits belong to Ishvara, not the individual self. Once knowledge dawns, action becomes unnecessary.\n\n**Ramanujacharya** (Vishishtadvaita): Interprets this as performing action as service to the Lord. The devotee acts because the Lord wishes it, surrendering all results to Him.\n\n**Madhvacharya** (Dvaita): Stresses that results inherently belong to God. The jiva (individual soul) has independence in choosing to act, but outcomes are governed by the Supreme.\n\n**Bal Gangadhar Tilak** (Modern interpretation): Read this verse as a call to action — karma is a duty that must not be abandoned. This interpretation fuelled the Indian independence movement.\n\nEach perspective illuminates a different facet of the same teaching.',
      isUser: false,
      timestamp: null,
      sources: [
        SourceReference(
          title: 'Gita Bhashya',
          author: 'Adi Shankaracharya',
          verseRef: '2.47',
          language: 'Sanskrit',
        ),
        SourceReference(
          title: 'Gita Bhashya',
          author: 'Ramanujacharya',
          verseRef: '2.47',
          language: 'Sanskrit',
        ),
      ],
    ),
    'everyday': ChatMessage(
      id: 'ai_5',
      text: 'Verse 2.47 is remarkably practical for everyday life. Here are some real-world applications:\n\n**At work**: Focus on doing your best work — the quality, the craft, the effort — rather than obsessing over promotions, raises, or recognition. Paradoxically, this often leads to better outcomes.\n\n**In relationships**: Love and care for people without expecting them to respond in a specific way. Give freely without keeping score.\n\n**In creativity**: Write, paint, or create for the joy of creation itself. When artists stop worrying about reception, their work often becomes more authentic.\n\n**In health**: Exercise and eat well because it\'s the right thing for your body, not only to achieve a specific weight or appearance.\n\n**In learning**: Study to understand and grow, not merely to pass an exam. The knowledge itself becomes the reward.\n\nThe key insight is that detachment from results doesn\'t mean not caring — it means caring about the right things: the quality of your effort, the alignment with your values, and the integrity of your actions.',
      isUser: false,
      timestamp: null,
    ),
  };

  static const List<String> suggestedQuestions = [
    'Explain this shloka in simple Hindi',
    'What is the philosophical meaning?',
    'What do the Sanskrit words mean?',
    'How do different commentators interpret it?',
    'How does this teaching relate to everyday life?',
  ];

  // ─── SUBSCRIPTION PLANS ───────────────────────────────────────────────

  static const List<SubscriptionPlan> subscriptionPlans = [
    SubscriptionPlan(
      id: 'free',
      name: 'Free',
      monthlyPriceINR: 0,
      annualPriceINR: 0,
      features: [
        'Basic reading experience',
        'Browse all 18 chapters',
        'Save favourite verses',
        'Advertisements displayed',
        '3 AI conversations per day',
      ],
    ),
    SubscriptionPlan(
      id: 'premium',
      name: 'Premium',
      monthlyPriceINR: 149,
      annualPriceINR: 1199,
      features: [
        'Ad-free reading experience',
        'Browse all 18 chapters',
        'Save unlimited verses',
        'No advertisements',
        '25 AI conversations per day',
        'Advanced shloka study tools',
        'Reading statistics',
      ],
      isPopular: true,
    ),
    SubscriptionPlan(
      id: 'premium_plus',
      name: 'Premium Plus',
      monthlyPriceINR: 299,
      annualPriceINR: 2399,
      features: [
        'Everything in Premium',
        'Unlimited AI conversations',
        'Commentary from multiple scholars',
        'Advanced word-by-word analysis',
        'Personalised study paths',
        'Offline access',
        'Priority support',
      ],
    ),
  ];

  /// Find a shloka by its id.
  static Shloka? findShloka(String id) {
    try {
      return shlokas.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get shlokas filtered by topic.
  static List<Shloka> shlokasByTopic(String topicId) {
    return shlokas.where((s) => s.topics.contains(topicId)).toList();
  }

  /// Get shlokas for a specific chapter.
  static List<Shloka> shlokasByChapter(int chapter) {
    return shlokas.where((s) => s.chapter == chapter).toList();
  }
}
