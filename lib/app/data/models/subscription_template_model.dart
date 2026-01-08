import 'package:hive/hive.dart';

part 'subscription_template_model.g.dart';

/// Pre-defined subscription templates for quick add
@HiveType(typeId: 3)
class SubscriptionTemplate {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final double? suggestedAmount;

  @HiveField(4)
  final String currencyCode;

  @HiveField(5)
  final String recurrenceType;

  @HiveField(6)
  final String category;

  @HiveField(7)
  final String iconName;

  @HiveField(8)
  final String colorHex;

  @HiveField(9)
  final String? websiteUrl;

  @HiveField(10)
  final String? cancellationUrl;

  @HiveField(11)
  final List<String> aliases;

  @HiveField(12)
  final bool isPopular;

  @HiveField(13)
  final int usageCount;

  const SubscriptionTemplate({
    required this.id,
    required this.name,
    this.description,
    this.suggestedAmount,
    this.currencyCode = 'INR',
    this.recurrenceType = 'monthly',
    required this.category,
    required this.iconName,
    required this.colorHex,
    this.websiteUrl,
    this.cancellationUrl,
    this.aliases = const [],
    this.isPopular = false,
    this.usageCount = 0,
  });

  /// Popular streaming services
  static const List<SubscriptionTemplate> streamingTemplates = [
    SubscriptionTemplate(
      id: 'netflix',
      name: 'Netflix',
      description: 'Streaming movies and TV shows',
      suggestedAmount: 649,
      category: 'streaming',
      iconName: 'netflix',
      colorHex: '#E50914',
      websiteUrl: 'https://netflix.com',
      cancellationUrl: 'https://netflix.com/cancelplan',
      aliases: ['nflx', 'netflix premium'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'prime_video',
      name: 'Amazon Prime Video',
      description: 'Amazon streaming service',
      suggestedAmount: 179,
      category: 'streaming',
      iconName: 'prime',
      colorHex: '#00A8E1',
      websiteUrl: 'https://primevideo.com',
      aliases: ['prime', 'amazon prime', 'prime video'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'hotstar',
      name: 'Disney+ Hotstar',
      description: 'Disney and Hotstar content',
      suggestedAmount: 299,
      category: 'streaming',
      iconName: 'hotstar',
      colorHex: '#1F1F1F',
      websiteUrl: 'https://hotstar.com',
      aliases: ['hotstar', 'disney+', 'disney plus'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'youtube_premium',
      name: 'YouTube Premium',
      description: 'Ad-free YouTube with music',
      suggestedAmount: 129,
      category: 'streaming',
      iconName: 'youtube',
      colorHex: '#FF0000',
      websiteUrl: 'https://youtube.com/premium',
      aliases: ['youtube', 'yt premium', 'youtube music'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'jio_cinema',
      name: 'JioCinema',
      description: 'Jio streaming platform',
      suggestedAmount: 999,
      category: 'streaming',
      iconName: 'jio',
      colorHex: '#0A1929',
      websiteUrl: 'https://jiocinema.com',
      aliases: ['jio', 'jiocinema premium'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'sonyliv',
      name: 'SonyLiv',
      description: 'Sony entertainment streaming',
      suggestedAmount: 999,
      category: 'streaming',
      iconName: 'sony',
      colorHex: '#000000',
      websiteUrl: 'https://sonyliv.com',
      aliases: ['sony liv', 'sony'],
      isPopular: false,
    ),
    SubscriptionTemplate(
      id: 'zee5',
      name: 'Zee5',
      description: 'Zee entertainment',
      suggestedAmount: 599,
      category: 'streaming',
      iconName: 'zee5',
      colorHex: '#8B008B',
      websiteUrl: 'https://zee5.com',
      aliases: ['zee5 premium'],
      isPopular: false,
    ),
    SubscriptionTemplate(
      id: 'apple_tv',
      name: 'Apple TV+',
      description: 'Apple original shows and movies',
      suggestedAmount: 99,
      category: 'streaming',
      iconName: 'apple',
      colorHex: '#000000',
      websiteUrl: 'https://tv.apple.com',
      aliases: ['apple tv plus', 'apple tv'],
      isPopular: false,
    ),
  ];

  /// Music services
  static const List<SubscriptionTemplate> musicTemplates = [
    SubscriptionTemplate(
      id: 'spotify',
      name: 'Spotify',
      description: 'Music streaming',
      suggestedAmount: 119,
      category: 'music',
      iconName: 'spotify',
      colorHex: '#1DB954',
      websiteUrl: 'https://spotify.com',
      cancellationUrl: 'https://spotify.com/account',
      aliases: ['spotify premium', 'spotify family'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'apple_music',
      name: 'Apple Music',
      description: 'Apple music streaming',
      suggestedAmount: 99,
      category: 'music',
      iconName: 'apple',
      colorHex: '#FA233B',
      websiteUrl: 'https://music.apple.com',
      aliases: ['apple music', 'itunes'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'gaana',
      name: 'Gaana+',
      description: 'Indian music streaming',
      suggestedAmount: 399,
      category: 'music',
      iconName: 'gaana',
      colorHex: '#E72C30',
      websiteUrl: 'https://gaana.com',
      aliases: ['gaana plus', 'gaana'],
      isPopular: false,
    ),
    SubscriptionTemplate(
      id: 'jiosaavn',
      name: 'JioSaavn',
      description: 'Music and podcasts',
      suggestedAmount: 99,
      category: 'music',
      iconName: 'jiosaavn',
      colorHex: '#2BC5B4',
      websiteUrl: 'https://jiosaavn.com',
      aliases: ['saavn', 'jio saavn'],
      isPopular: false,
    ),
    SubscriptionTemplate(
      id: 'wynk',
      name: 'Wynk Music',
      description: 'Airtel music streaming',
      suggestedAmount: 49,
      category: 'music',
      iconName: 'wynk',
      colorHex: '#E41937',
      websiteUrl: 'https://wynk.in',
      aliases: ['wynk', 'airtel wynk'],
      isPopular: false,
    ),
  ];

  /// Gaming subscriptions
  static const List<SubscriptionTemplate> gamingTemplates = [
    SubscriptionTemplate(
      id: 'xbox_game_pass',
      name: 'Xbox Game Pass',
      description: 'Xbox gaming subscription',
      suggestedAmount: 349,
      category: 'gaming',
      iconName: 'xbox',
      colorHex: '#107C10',
      websiteUrl: 'https://xbox.com/gamepass',
      aliases: ['game pass', 'xbox gamepass', 'xbox ultimate'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'playstation_plus',
      name: 'PlayStation Plus',
      description: 'PlayStation gaming subscription',
      suggestedAmount: 499,
      category: 'gaming',
      iconName: 'playstation',
      colorHex: '#003087',
      websiteUrl: 'https://playstation.com/plus',
      aliases: ['ps plus', 'psn plus', 'playstation plus'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'nintendo_online',
      name: 'Nintendo Switch Online',
      description: 'Nintendo online gaming',
      suggestedAmount: 159,
      category: 'gaming',
      iconName: 'nintendo',
      colorHex: '#E60012',
      websiteUrl: 'https://nintendo.com/switch/online',
      aliases: ['nintendo online', 'nso'],
      isPopular: false,
    ),
    SubscriptionTemplate(
      id: 'ea_play',
      name: 'EA Play',
      description: 'EA games subscription',
      suggestedAmount: 99,
      category: 'gaming',
      iconName: 'ea',
      colorHex: '#000000',
      websiteUrl: 'https://ea.com/ea-play',
      aliases: ['ea access', 'ea play pro'],
      isPopular: false,
    ),
  ];

  /// Productivity apps
  static const List<SubscriptionTemplate> productivityTemplates = [
    SubscriptionTemplate(
      id: 'microsoft_365',
      name: 'Microsoft 365',
      description: 'Office suite subscription',
      suggestedAmount: 489,
      category: 'productivity',
      iconName: 'microsoft',
      colorHex: '#0078D4',
      websiteUrl: 'https://microsoft.com/microsoft-365',
      aliases: ['office 365', 'ms 365', 'microsoft office'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'notion',
      name: 'Notion',
      description: 'All-in-one workspace',
      suggestedAmount: 480,
      recurrenceType: 'monthly',
      category: 'productivity',
      iconName: 'notion',
      colorHex: '#000000',
      websiteUrl: 'https://notion.so',
      aliases: ['notion pro', 'notion team'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'evernote',
      name: 'Evernote',
      description: 'Note-taking app',
      suggestedAmount: 575,
      category: 'productivity',
      iconName: 'evernote',
      colorHex: '#00A82D',
      websiteUrl: 'https://evernote.com',
      aliases: ['evernote premium', 'evernote pro'],
      isPopular: false,
    ),
    SubscriptionTemplate(
      id: 'todoist',
      name: 'Todoist',
      description: 'Task management',
      suggestedAmount: 325,
      category: 'productivity',
      iconName: 'todoist',
      colorHex: '#E44332',
      websiteUrl: 'https://todoist.com',
      aliases: ['todoist pro', 'todoist premium'],
      isPopular: false,
    ),
    SubscriptionTemplate(
      id: 'canva',
      name: 'Canva Pro',
      description: 'Design platform',
      suggestedAmount: 499,
      category: 'productivity',
      iconName: 'canva',
      colorHex: '#00C4CC',
      websiteUrl: 'https://canva.com',
      aliases: ['canva pro', 'canva'],
      isPopular: true,
    ),
  ];

  /// Cloud storage
  static const List<SubscriptionTemplate> cloudTemplates = [
    SubscriptionTemplate(
      id: 'google_one',
      name: 'Google One',
      description: 'Google cloud storage',
      suggestedAmount: 130,
      category: 'cloud',
      iconName: 'google',
      colorHex: '#4285F4',
      websiteUrl: 'https://one.google.com',
      aliases: ['google drive', 'google storage'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'icloud',
      name: 'iCloud+',
      description: 'Apple cloud storage',
      suggestedAmount: 75,
      category: 'cloud',
      iconName: 'apple',
      colorHex: '#3693F3',
      websiteUrl: 'https://apple.com/icloud',
      aliases: ['icloud plus', 'icloud storage'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'dropbox',
      name: 'Dropbox',
      description: 'Cloud file storage',
      suggestedAmount: 978,
      category: 'cloud',
      iconName: 'dropbox',
      colorHex: '#0061FF',
      websiteUrl: 'https://dropbox.com',
      aliases: ['dropbox plus', 'dropbox pro'],
      isPopular: false,
    ),
    SubscriptionTemplate(
      id: 'onedrive',
      name: 'OneDrive',
      description: 'Microsoft cloud storage',
      suggestedAmount: 140,
      category: 'cloud',
      iconName: 'microsoft',
      colorHex: '#0078D4',
      websiteUrl: 'https://onedrive.com',
      aliases: ['onedrive standalone', 'microsoft onedrive'],
      isPopular: false,
    ),
  ];

  /// Fitness & Health
  static const List<SubscriptionTemplate> fitnessTemplates = [
    SubscriptionTemplate(
      id: 'cult_fit',
      name: 'Cult.fit',
      description: 'Fitness and wellness',
      suggestedAmount: 1499,
      category: 'fitness',
      iconName: 'cultfit',
      colorHex: '#FF3F6C',
      websiteUrl: 'https://cult.fit',
      aliases: ['cultfit', 'cure.fit'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'headspace',
      name: 'Headspace',
      description: 'Meditation and mindfulness',
      suggestedAmount: 1099,
      category: 'fitness',
      iconName: 'headspace',
      colorHex: '#FD814A',
      websiteUrl: 'https://headspace.com',
      aliases: ['headspace plus'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'strava',
      name: 'Strava',
      description: 'Fitness tracking',
      suggestedAmount: 499,
      category: 'fitness',
      iconName: 'strava',
      colorHex: '#FC4C02',
      websiteUrl: 'https://strava.com',
      aliases: ['strava premium', 'strava subscription'],
      isPopular: false,
    ),
    SubscriptionTemplate(
      id: 'fitbit_premium',
      name: 'Fitbit Premium',
      description: 'Health insights and tracking',
      suggestedAmount: 849,
      category: 'fitness',
      iconName: 'fitbit',
      colorHex: '#00B0B9',
      websiteUrl: 'https://fitbit.com/premium',
      aliases: ['fitbit', 'fitbit plus'],
      isPopular: false,
    ),
    SubscriptionTemplate(
      id: 'apple_fitness',
      name: 'Apple Fitness+',
      description: 'Apple workout subscription',
      suggestedAmount: 799,
      category: 'fitness',
      iconName: 'apple',
      colorHex: '#FA2C55',
      websiteUrl: 'https://apple.com/apple-fitness-plus',
      aliases: ['fitness+', 'apple fitness plus'],
      isPopular: false,
    ),
  ];

  /// News & Reading
  static const List<SubscriptionTemplate> newsTemplates = [
    SubscriptionTemplate(
      id: 'kindle_unlimited',
      name: 'Kindle Unlimited',
      description: 'Amazon ebook subscription',
      suggestedAmount: 169,
      category: 'news',
      iconName: 'kindle',
      colorHex: '#FF9900',
      websiteUrl: 'https://amazon.in/kindleunlimited',
      aliases: ['kindle', 'amazon kindle'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'audible',
      name: 'Audible',
      description: 'Audiobook subscription',
      suggestedAmount: 199,
      category: 'news',
      iconName: 'audible',
      colorHex: '#F8991D',
      websiteUrl: 'https://audible.in',
      aliases: ['amazon audible', 'audible india'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'medium',
      name: 'Medium',
      description: 'Online articles and stories',
      suggestedAmount: 400,
      category: 'news',
      iconName: 'medium',
      colorHex: '#000000',
      websiteUrl: 'https://medium.com',
      aliases: ['medium membership'],
      isPopular: false,
    ),
    SubscriptionTemplate(
      id: 'the_hindu',
      name: 'The Hindu',
      description: 'Digital newspaper',
      suggestedAmount: 399,
      category: 'news',
      iconName: 'newspaper',
      colorHex: '#1A3764',
      websiteUrl: 'https://thehindu.com',
      aliases: ['hindu epaper', 'the hindu digital'],
      isPopular: false,
    ),
  ];

  /// Telecom & Utilities
  static const List<SubscriptionTemplate> telecomTemplates = [
    SubscriptionTemplate(
      id: 'jio_postpaid',
      name: 'Jio Postpaid',
      description: 'Jio mobile plan',
      suggestedAmount: 399,
      category: 'telecom',
      iconName: 'jio',
      colorHex: '#0A1929',
      websiteUrl: 'https://jio.com',
      aliases: ['jio', 'reliance jio'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'airtel_postpaid',
      name: 'Airtel Postpaid',
      description: 'Airtel mobile plan',
      suggestedAmount: 449,
      category: 'telecom',
      iconName: 'airtel',
      colorHex: '#E40000',
      websiteUrl: 'https://airtel.in',
      aliases: ['airtel', 'bharti airtel'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'vi_postpaid',
      name: 'Vi Postpaid',
      description: 'Vodafone Idea mobile plan',
      suggestedAmount: 399,
      category: 'telecom',
      iconName: 'vi',
      colorHex: '#ED1C24',
      websiteUrl: 'https://vi.in',
      aliases: ['vi', 'vodafone', 'idea'],
      isPopular: false,
    ),
    SubscriptionTemplate(
      id: 'broadband',
      name: 'Broadband / WiFi',
      description: 'Home internet connection',
      suggestedAmount: 799,
      category: 'utilities',
      iconName: 'wifi',
      colorHex: '#4A90D9',
      websiteUrl: '',
      aliases: ['internet', 'wifi', 'fiber'],
      isPopular: true,
    ),
  ];

  /// Software subscriptions
  static const List<SubscriptionTemplate> softwareTemplates = [
    SubscriptionTemplate(
      id: 'adobe_cc',
      name: 'Adobe Creative Cloud',
      description: 'Adobe creative suite',
      suggestedAmount: 4230,
      category: 'software',
      iconName: 'adobe',
      colorHex: '#FF0000',
      websiteUrl: 'https://adobe.com/creativecloud',
      aliases: ['adobe', 'creative cloud', 'photoshop'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'figma',
      name: 'Figma',
      description: 'Design and prototyping',
      suggestedAmount: 1200,
      category: 'software',
      iconName: 'figma',
      colorHex: '#F24E1E',
      websiteUrl: 'https://figma.com',
      aliases: ['figma pro', 'figma team'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'github',
      name: 'GitHub',
      description: 'Code hosting platform',
      suggestedAmount: 330,
      category: 'software',
      iconName: 'github',
      colorHex: '#181717',
      websiteUrl: 'https://github.com',
      aliases: ['github pro', 'github team'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'jetbrains',
      name: 'JetBrains',
      description: 'Developer tools',
      suggestedAmount: 1070,
      category: 'software',
      iconName: 'jetbrains',
      colorHex: '#000000',
      websiteUrl: 'https://jetbrains.com',
      aliases: ['intellij', 'pycharm', 'webstorm'],
      isPopular: false,
    ),
    SubscriptionTemplate(
      id: 'chatgpt',
      name: 'ChatGPT Plus',
      description: 'OpenAI ChatGPT subscription',
      suggestedAmount: 1650,
      category: 'software',
      iconName: 'openai',
      colorHex: '#10A37F',
      websiteUrl: 'https://chat.openai.com',
      aliases: ['openai', 'gpt plus', 'chatgpt plus'],
      isPopular: true,
    ),
    SubscriptionTemplate(
      id: 'claude',
      name: 'Claude Pro',
      description: 'Anthropic AI assistant',
      suggestedAmount: 1650,
      category: 'software',
      iconName: 'anthropic',
      colorHex: '#D4A373',
      websiteUrl: 'https://claude.ai',
      aliases: ['anthropic', 'claude pro'],
      isPopular: true,
    ),
  ];

  /// Get all templates
  static List<SubscriptionTemplate> get allTemplates => [
    ...streamingTemplates,
    ...musicTemplates,
    ...gamingTemplates,
    ...productivityTemplates,
    ...cloudTemplates,
    ...fitnessTemplates,
    ...newsTemplates,
    ...telecomTemplates,
    ...softwareTemplates,
  ];

  /// Get popular templates
  static List<SubscriptionTemplate> get popularTemplates =>
      allTemplates.where((t) => t.isPopular).toList();

  /// Search templates by query
  static List<SubscriptionTemplate> search(String query) {
    final lowerQuery = query.toLowerCase();
    return allTemplates.where((template) {
      return template.name.toLowerCase().contains(lowerQuery) ||
          template.aliases.any(
            (alias) => alias.toLowerCase().contains(lowerQuery),
          ) ||
          template.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get templates by category
  static List<SubscriptionTemplate> getByCategory(String category) {
    return allTemplates.where((t) => t.category == category).toList();
  }
}
