import 'dart:ui';
import 'package:flutter/material.dart';

/// Enterprise-grade brand logo service with real company logos
/// Uses multiple logo sources for maximum coverage
class BrandLogoService {
  static final BrandLogoService _instance = BrandLogoService._internal();
  factory BrandLogoService() => _instance;
  BrandLogoService._internal();

  /// Brand data with accurate colors and logo URLs
  static final Map<String, BrandData> _brandDatabase = {
    // Streaming Services
    'netflix': BrandData(
      name: 'Netflix',
      primaryColor: const Color(0xFFE50914),
      secondaryColor: const Color(0xFF221F1F),
      logoUrl: 'https://logo.clearbit.com/netflix.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/netflix/E50914',
      iconChar: 'N',
      domain: 'netflix.com',
    ),
    'prime_video': BrandData(
      name: 'Prime Video',
      primaryColor: const Color(0xFF00A8E1),
      secondaryColor: const Color(0xFF232F3E),
      logoUrl: 'https://logo.clearbit.com/primevideo.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/amazonprime/00A8E1',
      iconChar: 'P',
      domain: 'primevideo.com',
    ),
    'disney_plus': BrandData(
      name: 'Disney+',
      primaryColor: const Color(0xFF113CCF),
      secondaryColor: const Color(0xFF1A1D29),
      logoUrl: 'https://logo.clearbit.com/disneyplus.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/disneyplus/113CCF',
      iconChar: 'D',
      domain: 'disneyplus.com',
    ),
    'hotstar': BrandData(
      name: 'Disney+ Hotstar',
      primaryColor: const Color(0xFF1F80E0),
      secondaryColor: const Color(0xFF0F1014),
      logoUrl: 'https://logo.clearbit.com/hotstar.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/hotstar/1F80E0',
      iconChar: 'H',
      domain: 'hotstar.com',
    ),
    'youtube': BrandData(
      name: 'YouTube',
      primaryColor: const Color(0xFFFF0000),
      secondaryColor: const Color(0xFF282828),
      logoUrl: 'https://logo.clearbit.com/youtube.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/youtube/FF0000',
      iconChar: 'Y',
      domain: 'youtube.com',
    ),
    'youtube_premium': BrandData(
      name: 'YouTube Premium',
      primaryColor: const Color(0xFFFF0000),
      secondaryColor: const Color(0xFF282828),
      logoUrl: 'https://logo.clearbit.com/youtube.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/youtubepremium/FF0000',
      iconChar: 'Y',
      domain: 'youtube.com',
    ),
    'hbo_max': BrandData(
      name: 'Max',
      primaryColor: const Color(0xFF002BE7),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/max.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/hbo/002BE7',
      iconChar: 'M',
      domain: 'max.com',
    ),
    'hulu': BrandData(
      name: 'Hulu',
      primaryColor: const Color(0xFF1CE783),
      secondaryColor: const Color(0xFF040405),
      logoUrl: 'https://logo.clearbit.com/hulu.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/hulu/1CE783',
      iconChar: 'H',
      domain: 'hulu.com',
    ),
    'apple_tv': BrandData(
      name: 'Apple TV+',
      primaryColor: const Color(0xFF000000),
      secondaryColor: const Color(0xFFFFFFFF),
      logoUrl: 'https://logo.clearbit.com/tv.apple.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/appletv/000000',
      iconChar: 'A',
      domain: 'tv.apple.com',
    ),
    'zee5': BrandData(
      name: 'ZEE5',
      primaryColor: const Color(0xFF8B008B),
      secondaryColor: const Color(0xFF1A0A2E),
      logoUrl: 'https://logo.clearbit.com/zee5.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/zee5/8B008B',
      iconChar: 'Z',
      domain: 'zee5.com',
    ),
    'sonyliv': BrandData(
      name: 'SonyLIV',
      primaryColor: const Color(0xFF070707),
      secondaryColor: const Color(0xFFE8E8E8),
      logoUrl: 'https://logo.clearbit.com/sonyliv.com',
      fallbackLogoUrl: null,
      iconChar: 'S',
      domain: 'sonyliv.com',
    ),
    'jio_cinema': BrandData(
      name: 'JioCinema',
      primaryColor: const Color(0xFFD71920),
      secondaryColor: const Color(0xFF0A1929),
      logoUrl: 'https://logo.clearbit.com/jiocinema.com',
      fallbackLogoUrl: null,
      iconChar: 'J',
      domain: 'jiocinema.com',
    ),

    // Music Services
    'spotify': BrandData(
      name: 'Spotify',
      primaryColor: const Color(0xFF1DB954),
      secondaryColor: const Color(0xFF191414),
      logoUrl: 'https://logo.clearbit.com/spotify.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/spotify/1DB954',
      iconChar: 'S',
      domain: 'spotify.com',
    ),
    'apple_music': BrandData(
      name: 'Apple Music',
      primaryColor: const Color(0xFFFA2D48),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/music.apple.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/applemusic/FA2D48',
      iconChar: 'A',
      domain: 'music.apple.com',
    ),
    'youtube_music': BrandData(
      name: 'YouTube Music',
      primaryColor: const Color(0xFFFF0000),
      secondaryColor: const Color(0xFF030303),
      logoUrl: 'https://logo.clearbit.com/music.youtube.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/youtubemusic/FF0000',
      iconChar: 'Y',
      domain: 'music.youtube.com',
    ),
    'gaana': BrandData(
      name: 'Gaana',
      primaryColor: const Color(0xFFE72C30),
      secondaryColor: const Color(0xFF1A1A2E),
      logoUrl: 'https://logo.clearbit.com/gaana.com',
      fallbackLogoUrl: null,
      iconChar: 'G',
      domain: 'gaana.com',
    ),
    'jiosaavn': BrandData(
      name: 'JioSaavn',
      primaryColor: const Color(0xFF2BC5B4),
      secondaryColor: const Color(0xFF121212),
      logoUrl: 'https://logo.clearbit.com/jiosaavn.com',
      fallbackLogoUrl: null,
      iconChar: 'J',
      domain: 'jiosaavn.com',
    ),
    'amazon_music': BrandData(
      name: 'Amazon Music',
      primaryColor: const Color(0xFF25D1DA),
      secondaryColor: const Color(0xFF232F3E),
      logoUrl: 'https://logo.clearbit.com/music.amazon.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/amazonmusic/25D1DA',
      iconChar: 'A',
      domain: 'music.amazon.com',
    ),
    'tidal': BrandData(
      name: 'Tidal',
      primaryColor: const Color(0xFF000000),
      secondaryColor: const Color(0xFFFFFFFF),
      logoUrl: 'https://logo.clearbit.com/tidal.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/tidal/000000',
      iconChar: 'T',
      domain: 'tidal.com',
    ),
    'deezer': BrandData(
      name: 'Deezer',
      primaryColor: const Color(0xFFFEAA2D),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/deezer.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/deezer/FEAA2D',
      iconChar: 'D',
      domain: 'deezer.com',
    ),

    // Gaming
    'xbox_game_pass': BrandData(
      name: 'Xbox Game Pass',
      primaryColor: const Color(0xFF107C10),
      secondaryColor: const Color(0xFF0E0E0E),
      logoUrl: 'https://logo.clearbit.com/xbox.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/xbox/107C10',
      iconChar: 'X',
      domain: 'xbox.com',
    ),
    'playstation_plus': BrandData(
      name: 'PlayStation Plus',
      primaryColor: const Color(0xFF003087),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/playstation.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/playstation/003087',
      iconChar: 'P',
      domain: 'playstation.com',
    ),
    'nintendo_online': BrandData(
      name: 'Nintendo Switch Online',
      primaryColor: const Color(0xFFE60012),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/nintendo.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/nintendo/E60012',
      iconChar: 'N',
      domain: 'nintendo.com',
    ),
    'ea_play': BrandData(
      name: 'EA Play',
      primaryColor: const Color(0xFFFF4747),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/ea.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/ea/FF4747',
      iconChar: 'E',
      domain: 'ea.com',
    ),
    'ubisoft_plus': BrandData(
      name: 'Ubisoft+',
      primaryColor: const Color(0xFF0070FF),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/ubisoft.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/ubisoft/0070FF',
      iconChar: 'U',
      domain: 'ubisoft.com',
    ),
    'steam': BrandData(
      name: 'Steam',
      primaryColor: const Color(0xFF00ADEE),
      secondaryColor: const Color(0xFF171A21),
      logoUrl: 'https://logo.clearbit.com/steampowered.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/steam/00ADEE',
      iconChar: 'S',
      domain: 'steampowered.com',
    ),

    // Productivity
    'microsoft_365': BrandData(
      name: 'Microsoft 365',
      primaryColor: const Color(0xFFD83B01),
      secondaryColor: const Color(0xFF0078D4),
      logoUrl: 'https://logo.clearbit.com/microsoft.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/microsoft/0078D4',
      iconChar: 'M',
      domain: 'microsoft.com',
    ),
    'notion': BrandData(
      name: 'Notion',
      primaryColor: const Color(0xFF000000),
      secondaryColor: const Color(0xFFFFFFFF),
      logoUrl: 'https://logo.clearbit.com/notion.so',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/notion/000000',
      iconChar: 'N',
      domain: 'notion.so',
    ),
    'slack': BrandData(
      name: 'Slack',
      primaryColor: const Color(0xFF4A154B),
      secondaryColor: const Color(0xFFE01E5A),
      logoUrl: 'https://logo.clearbit.com/slack.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/slack/4A154B',
      iconChar: 'S',
      domain: 'slack.com',
    ),
    'zoom': BrandData(
      name: 'Zoom',
      primaryColor: const Color(0xFF2D8CFF),
      secondaryColor: const Color(0xFF0B5CFF),
      logoUrl: 'https://logo.clearbit.com/zoom.us',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/zoom/2D8CFF',
      iconChar: 'Z',
      domain: 'zoom.us',
    ),
    'canva': BrandData(
      name: 'Canva',
      primaryColor: const Color(0xFF00C4CC),
      secondaryColor: const Color(0xFF7D2AE8),
      logoUrl: 'https://logo.clearbit.com/canva.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/canva/00C4CC',
      iconChar: 'C',
      domain: 'canva.com',
    ),
    'evernote': BrandData(
      name: 'Evernote',
      primaryColor: const Color(0xFF00A82D),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/evernote.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/evernote/00A82D',
      iconChar: 'E',
      domain: 'evernote.com',
    ),
    'todoist': BrandData(
      name: 'Todoist',
      primaryColor: const Color(0xFFE44332),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/todoist.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/todoist/E44332',
      iconChar: 'T',
      domain: 'todoist.com',
    ),
    'trello': BrandData(
      name: 'Trello',
      primaryColor: const Color(0xFF0052CC),
      secondaryColor: const Color(0xFF026AA7),
      logoUrl: 'https://logo.clearbit.com/trello.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/trello/0052CC',
      iconChar: 'T',
      domain: 'trello.com',
    ),
    'asana': BrandData(
      name: 'Asana',
      primaryColor: const Color(0xFFF06A6A),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/asana.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/asana/F06A6A',
      iconChar: 'A',
      domain: 'asana.com',
    ),
    'monday': BrandData(
      name: 'monday.com',
      primaryColor: const Color(0xFFFF3D57),
      secondaryColor: const Color(0xFF6161FF),
      logoUrl: 'https://logo.clearbit.com/monday.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/monday/FF3D57',
      iconChar: 'M',
      domain: 'monday.com',
    ),
    'linear': BrandData(
      name: 'Linear',
      primaryColor: const Color(0xFF5E6AD2),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/linear.app',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/linear/5E6AD2',
      iconChar: 'L',
      domain: 'linear.app',
    ),

    // Cloud Storage
    'google_one': BrandData(
      name: 'Google One',
      primaryColor: const Color(0xFF4285F4),
      secondaryColor: const Color(0xFFEA4335),
      logoUrl: 'https://logo.clearbit.com/one.google.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/google/4285F4',
      iconChar: 'G',
      domain: 'one.google.com',
    ),
    'icloud': BrandData(
      name: 'iCloud+',
      primaryColor: const Color(0xFF3693F3),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/icloud.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/icloud/3693F3',
      iconChar: 'i',
      domain: 'icloud.com',
    ),
    'dropbox': BrandData(
      name: 'Dropbox',
      primaryColor: const Color(0xFF0061FF),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/dropbox.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/dropbox/0061FF',
      iconChar: 'D',
      domain: 'dropbox.com',
    ),
    'onedrive': BrandData(
      name: 'OneDrive',
      primaryColor: const Color(0xFF0078D4),
      secondaryColor: const Color(0xFF094AB2),
      logoUrl: 'https://logo.clearbit.com/onedrive.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/microsoftonedrive/0078D4',
      iconChar: 'O',
      domain: 'onedrive.com',
    ),

    // Software & Dev Tools
    'github': BrandData(
      name: 'GitHub',
      primaryColor: const Color(0xFF181717),
      secondaryColor: const Color(0xFFFFFFFF),
      logoUrl: 'https://logo.clearbit.com/github.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/github/181717',
      iconChar: 'G',
      domain: 'github.com',
    ),
    'figma': BrandData(
      name: 'Figma',
      primaryColor: const Color(0xFFF24E1E),
      secondaryColor: const Color(0xFF1E1E1E),
      logoUrl: 'https://logo.clearbit.com/figma.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/figma/F24E1E',
      iconChar: 'F',
      domain: 'figma.com',
    ),
    'adobe_cc': BrandData(
      name: 'Adobe Creative Cloud',
      primaryColor: const Color(0xFFFF0000),
      secondaryColor: const Color(0xFF1E0000),
      logoUrl: 'https://logo.clearbit.com/adobe.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/adobe/FF0000',
      iconChar: 'A',
      domain: 'adobe.com',
    ),
    'jetbrains': BrandData(
      name: 'JetBrains',
      primaryColor: const Color(0xFFFF318C),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/jetbrains.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/jetbrains/000000',
      iconChar: 'J',
      domain: 'jetbrains.com',
    ),
    'chatgpt': BrandData(
      name: 'ChatGPT Plus',
      primaryColor: const Color(0xFF10A37F),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/openai.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/openai/10A37F',
      iconChar: 'C',
      domain: 'openai.com',
    ),
    'claude': BrandData(
      name: 'Claude Pro',
      primaryColor: const Color(0xFFCC785C),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/anthropic.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/anthropic/CC785C',
      iconChar: 'C',
      domain: 'anthropic.com',
    ),
    'copilot': BrandData(
      name: 'GitHub Copilot',
      primaryColor: const Color(0xFF000000),
      secondaryColor: const Color(0xFF8957E5),
      logoUrl: 'https://logo.clearbit.com/github.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/githubcopilot/000000',
      iconChar: 'C',
      domain: 'github.com',
    ),
    'vercel': BrandData(
      name: 'Vercel',
      primaryColor: const Color(0xFF000000),
      secondaryColor: const Color(0xFFFFFFFF),
      logoUrl: 'https://logo.clearbit.com/vercel.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/vercel/000000',
      iconChar: 'V',
      domain: 'vercel.com',
    ),
    'netlify': BrandData(
      name: 'Netlify',
      primaryColor: const Color(0xFF00C7B7),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/netlify.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/netlify/00C7B7',
      iconChar: 'N',
      domain: 'netlify.com',
    ),
    'aws': BrandData(
      name: 'AWS',
      primaryColor: const Color(0xFFFF9900),
      secondaryColor: const Color(0xFF232F3E),
      logoUrl: 'https://logo.clearbit.com/aws.amazon.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/amazonaws/FF9900',
      iconChar: 'A',
      domain: 'aws.amazon.com',
    ),
    'gcp': BrandData(
      name: 'Google Cloud',
      primaryColor: const Color(0xFF4285F4),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/cloud.google.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/googlecloud/4285F4',
      iconChar: 'G',
      domain: 'cloud.google.com',
    ),
    'azure': BrandData(
      name: 'Microsoft Azure',
      primaryColor: const Color(0xFF0078D4),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/azure.microsoft.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/microsoftazure/0078D4',
      iconChar: 'A',
      domain: 'azure.microsoft.com',
    ),
    'digitalocean': BrandData(
      name: 'DigitalOcean',
      primaryColor: const Color(0xFF0080FF),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/digitalocean.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/digitalocean/0080FF',
      iconChar: 'D',
      domain: 'digitalocean.com',
    ),

    // Fitness & Health
    'cult_fit': BrandData(
      name: 'Cult.fit',
      primaryColor: const Color(0xFFFF3F6C),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/cult.fit',
      fallbackLogoUrl: null,
      iconChar: 'C',
      domain: 'cult.fit',
    ),
    'headspace': BrandData(
      name: 'Headspace',
      primaryColor: const Color(0xFFFD814A),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/headspace.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/headspace/FD814A',
      iconChar: 'H',
      domain: 'headspace.com',
    ),
    'calm': BrandData(
      name: 'Calm',
      primaryColor: const Color(0xFF80B3FF),
      secondaryColor: const Color(0xFF3156A3),
      logoUrl: 'https://logo.clearbit.com/calm.com',
      fallbackLogoUrl: null,
      iconChar: 'C',
      domain: 'calm.com',
    ),
    'strava': BrandData(
      name: 'Strava',
      primaryColor: const Color(0xFFFC4C02),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/strava.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/strava/FC4C02',
      iconChar: 'S',
      domain: 'strava.com',
    ),
    'fitbit_premium': BrandData(
      name: 'Fitbit Premium',
      primaryColor: const Color(0xFF00B0B9),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/fitbit.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/fitbit/00B0B9',
      iconChar: 'F',
      domain: 'fitbit.com',
    ),
    'peloton': BrandData(
      name: 'Peloton',
      primaryColor: const Color(0xFFDE0014),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/onepeloton.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/peloton/DE0014',
      iconChar: 'P',
      domain: 'onepeloton.com',
    ),
    'apple_fitness': BrandData(
      name: 'Apple Fitness+',
      primaryColor: const Color(0xFFFA2D48),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/apple.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/apple/000000',
      iconChar: 'F',
      domain: 'apple.com',
    ),

    // News & Reading
    'kindle_unlimited': BrandData(
      name: 'Kindle Unlimited',
      primaryColor: const Color(0xFFFF9900),
      secondaryColor: const Color(0xFF232F3E),
      logoUrl: 'https://logo.clearbit.com/amazon.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/kindle/FF9900',
      iconChar: 'K',
      domain: 'amazon.com',
    ),
    'audible': BrandData(
      name: 'Audible',
      primaryColor: const Color(0xFFF8991D),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/audible.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/audible/F8991D',
      iconChar: 'A',
      domain: 'audible.com',
    ),
    'medium': BrandData(
      name: 'Medium',
      primaryColor: const Color(0xFF000000),
      secondaryColor: const Color(0xFFFFFFFF),
      logoUrl: 'https://logo.clearbit.com/medium.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/medium/000000',
      iconChar: 'M',
      domain: 'medium.com',
    ),
    'substack': BrandData(
      name: 'Substack',
      primaryColor: const Color(0xFFFF6719),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/substack.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/substack/FF6719',
      iconChar: 'S',
      domain: 'substack.com',
    ),
    'the_athletic': BrandData(
      name: 'The Athletic',
      primaryColor: const Color(0xFF000000),
      secondaryColor: const Color(0xFFDB2818),
      logoUrl: 'https://logo.clearbit.com/theathletic.com',
      fallbackLogoUrl: null,
      iconChar: 'A',
      domain: 'theathletic.com',
    ),
    'nyt': BrandData(
      name: 'New York Times',
      primaryColor: const Color(0xFF000000),
      secondaryColor: const Color(0xFFFFFFFF),
      logoUrl: 'https://logo.clearbit.com/nytimes.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/newyorktimes/000000',
      iconChar: 'T',
      domain: 'nytimes.com',
    ),
    'wsj': BrandData(
      name: 'Wall Street Journal',
      primaryColor: const Color(0xFF000000),
      secondaryColor: const Color(0xFFFFFFFF),
      logoUrl: 'https://logo.clearbit.com/wsj.com',
      fallbackLogoUrl: null,
      iconChar: 'W',
      domain: 'wsj.com',
    ),

    // Telecom
    'jio_postpaid': BrandData(
      name: 'Jio',
      primaryColor: const Color(0xFF0A3478),
      secondaryColor: const Color(0xFFD71920),
      logoUrl: 'https://logo.clearbit.com/jio.com',
      fallbackLogoUrl: null,
      iconChar: 'J',
      domain: 'jio.com',
    ),
    'airtel_postpaid': BrandData(
      name: 'Airtel',
      primaryColor: const Color(0xFFE40000),
      secondaryColor: const Color(0xFFFFFFFF),
      logoUrl: 'https://logo.clearbit.com/airtel.in',
      fallbackLogoUrl: null,
      iconChar: 'A',
      domain: 'airtel.in',
    ),
    'vi_postpaid': BrandData(
      name: 'Vi',
      primaryColor: const Color(0xFFED1C24),
      secondaryColor: const Color(0xFFFFC72C),
      logoUrl: 'https://logo.clearbit.com/myvi.in',
      fallbackLogoUrl: null,
      iconChar: 'V',
      domain: 'myvi.in',
    ),

    // Finance & Shopping
    'amazon_prime': BrandData(
      name: 'Amazon Prime',
      primaryColor: const Color(0xFFFF9900),
      secondaryColor: const Color(0xFF232F3E),
      logoUrl: 'https://logo.clearbit.com/amazon.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/amazon/FF9900',
      iconChar: 'A',
      domain: 'amazon.com',
    ),
    'flipkart_plus': BrandData(
      name: 'Flipkart Plus',
      primaryColor: const Color(0xFF2874F0),
      secondaryColor: const Color(0xFFFFE500),
      logoUrl: 'https://logo.clearbit.com/flipkart.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/flipkart/2874F0',
      iconChar: 'F',
      domain: 'flipkart.com',
    ),
    'swiggy_one': BrandData(
      name: 'Swiggy One',
      primaryColor: const Color(0xFFFC8019),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/swiggy.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/swiggy/FC8019',
      iconChar: 'S',
      domain: 'swiggy.com',
    ),
    'zomato_pro': BrandData(
      name: 'Zomato Gold',
      primaryColor: const Color(0xFFCB202D),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/zomato.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/zomato/CB202D',
      iconChar: 'Z',
      domain: 'zomato.com',
    ),

    // VPN & Security
    'nordvpn': BrandData(
      name: 'NordVPN',
      primaryColor: const Color(0xFF4687FF),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/nordvpn.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/nordvpn/4687FF',
      iconChar: 'N',
      domain: 'nordvpn.com',
    ),
    'expressvpn': BrandData(
      name: 'ExpressVPN',
      primaryColor: const Color(0xFFDA3940),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/expressvpn.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/expressvpn/DA3940',
      iconChar: 'E',
      domain: 'expressvpn.com',
    ),
    'surfshark': BrandData(
      name: 'Surfshark',
      primaryColor: const Color(0xFF178FE6),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/surfshark.com',
      fallbackLogoUrl: null,
      iconChar: 'S',
      domain: 'surfshark.com',
    ),
    '1password': BrandData(
      name: '1Password',
      primaryColor: const Color(0xFF0094F5),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/1password.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/1password/0094F5',
      iconChar: '1',
      domain: '1password.com',
    ),
    'lastpass': BrandData(
      name: 'LastPass',
      primaryColor: const Color(0xFFD32D27),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/lastpass.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/lastpass/D32D27',
      iconChar: 'L',
      domain: 'lastpass.com',
    ),
    'bitwarden': BrandData(
      name: 'Bitwarden',
      primaryColor: const Color(0xFF175DDC),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/bitwarden.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/bitwarden/175DDC',
      iconChar: 'B',
      domain: 'bitwarden.com',
    ),

    // Social
    'linkedin_premium': BrandData(
      name: 'LinkedIn Premium',
      primaryColor: const Color(0xFF0A66C2),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/linkedin.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/linkedin/0A66C2',
      iconChar: 'L',
      domain: 'linkedin.com',
    ),
    'twitter_blue': BrandData(
      name: 'X Premium',
      primaryColor: const Color(0xFF000000),
      secondaryColor: const Color(0xFFFFFFFF),
      logoUrl: 'https://logo.clearbit.com/x.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/x/000000',
      iconChar: 'X',
      domain: 'x.com',
    ),
    'discord_nitro': BrandData(
      name: 'Discord Nitro',
      primaryColor: const Color(0xFF5865F2),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/discord.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/discord/5865F2',
      iconChar: 'D',
      domain: 'discord.com',
    ),
    'reddit_premium': BrandData(
      name: 'Reddit Premium',
      primaryColor: const Color(0xFFFF4500),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/reddit.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/reddit/FF4500',
      iconChar: 'R',
      domain: 'reddit.com',
    ),
    'telegram_premium': BrandData(
      name: 'Telegram Premium',
      primaryColor: const Color(0xFF26A5E4),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/telegram.org',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/telegram/26A5E4',
      iconChar: 'T',
      domain: 'telegram.org',
    ),

    // Education
    'coursera': BrandData(
      name: 'Coursera',
      primaryColor: const Color(0xFF0056D2),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/coursera.org',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/coursera/0056D2',
      iconChar: 'C',
      domain: 'coursera.org',
    ),
    'udemy': BrandData(
      name: 'Udemy',
      primaryColor: const Color(0xFFA435F0),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/udemy.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/udemy/A435F0',
      iconChar: 'U',
      domain: 'udemy.com',
    ),
    'skillshare': BrandData(
      name: 'Skillshare',
      primaryColor: const Color(0xFF00FF84),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/skillshare.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/skillshare/00FF84',
      iconChar: 'S',
      domain: 'skillshare.com',
    ),
    'masterclass': BrandData(
      name: 'MasterClass',
      primaryColor: const Color(0xFF000000),
      secondaryColor: const Color(0xFFFFFFFF),
      logoUrl: 'https://logo.clearbit.com/masterclass.com',
      fallbackLogoUrl: null,
      iconChar: 'M',
      domain: 'masterclass.com',
    ),
    'duolingo': BrandData(
      name: 'Duolingo Plus',
      primaryColor: const Color(0xFF58CC02),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/duolingo.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/duolingo/58CC02',
      iconChar: 'D',
      domain: 'duolingo.com',
    ),

    // Travel
    'uber_one': BrandData(
      name: 'Uber One',
      primaryColor: const Color(0xFF000000),
      secondaryColor: const Color(0xFFFFFFFF),
      logoUrl: 'https://logo.clearbit.com/uber.com',
      fallbackLogoUrl: 'https://cdn.simpleicons.org/uber/000000',
      iconChar: 'U',
      domain: 'uber.com',
    ),
    'ola_select': BrandData(
      name: 'Ola Select',
      primaryColor: const Color(0xFF7CC242),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/olacabs.com',
      fallbackLogoUrl: null,
      iconChar: 'O',
      domain: 'olacabs.com',
    ),
    'cleartrip': BrandData(
      name: 'Cleartrip',
      primaryColor: const Color(0xFFE74C3C),
      secondaryColor: const Color(0xFF000000),
      logoUrl: 'https://logo.clearbit.com/cleartrip.com',
      fallbackLogoUrl: null,
      iconChar: 'C',
      domain: 'cleartrip.com',
    ),
    'makemytrip': BrandData(
      name: 'MakeMyTrip',
      primaryColor: const Color(0xFFE53935),
      secondaryColor: const Color(0xFF0D47A1),
      logoUrl: 'https://logo.clearbit.com/makemytrip.com',
      fallbackLogoUrl: null,
      iconChar: 'M',
      domain: 'makemytrip.com',
    ),
  };

  /// Get brand data by ID or name
  static BrandData? getBrand(String identifier) {
    final normalizedId = _normalizeIdentifier(identifier);

    // Direct match
    if (_brandDatabase.containsKey(normalizedId)) {
      return _brandDatabase[normalizedId];
    }

    // Fuzzy search by name
    for (final entry in _brandDatabase.entries) {
      if (_normalizeIdentifier(entry.value.name) == normalizedId) {
        return entry.value;
      }
    }

    // Partial match
    for (final entry in _brandDatabase.entries) {
      if (entry.key.contains(normalizedId) ||
          normalizedId.contains(entry.key) ||
          _normalizeIdentifier(entry.value.name).contains(normalizedId)) {
        return entry.value;
      }
    }

    return null;
  }

  /// Get logo URL for a brand
  static String? getLogoUrl(String identifier, {bool useFallback = false}) {
    final brand = getBrand(identifier);
    if (brand == null) return null;
    return useFallback
        ? (brand.fallbackLogoUrl ?? brand.logoUrl)
        : brand.logoUrl;
  }

  /// Get brand color
  static Color getBrandColor(String identifier) {
    final brand = getBrand(identifier);
    return brand?.primaryColor ?? const Color(0xFF7C4DFF);
  }

  /// Get clearbit logo URL from domain
  static String getClearbitLogoUrl(String domain, {int size = 128}) {
    return 'https://logo.clearbit.com/$domain?size=$size';
  }

  /// Get simple icons URL
  static String getSimpleIconUrl(String iconName, {String? color}) {
    final colorParam = color ?? '000000';
    return 'https://cdn.simpleicons.org/$iconName/$colorParam';
  }

  /// Normalize identifier for matching
  static String _normalizeIdentifier(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '')
        .replaceAll('plus', '')
        .replaceAll('premium', '')
        .replaceAll('pro', '');
  }

  /// Get all available brands
  static List<BrandData> get allBrands => _brandDatabase.values.toList();

  /// Search brands
  static List<BrandData> searchBrands(String query) {
    final normalizedQuery = _normalizeIdentifier(query);
    return _brandDatabase.values.where((brand) {
      return _normalizeIdentifier(brand.name).contains(normalizedQuery) ||
          brand.domain.contains(normalizedQuery);
    }).toList();
  }
}

/// Brand data model
class BrandData {
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final String logoUrl;
  final String? fallbackLogoUrl;
  final String iconChar;
  final String domain;

  const BrandData({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.logoUrl,
    this.fallbackLogoUrl,
    required this.iconChar,
    required this.domain,
  });

  /// Get gradient colors for the brand
  List<Color> get gradientColors => [
    primaryColor,
    Color.lerp(primaryColor, secondaryColor, 0.5) ?? primaryColor,
  ];
}
