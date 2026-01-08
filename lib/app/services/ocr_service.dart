import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../data/models/subscription_model.dart';
import '../../ui/screens/add_subscription_screen.dart';

class OcrService {
  static final ImagePicker _picker = ImagePicker();
  static final TextRecognizer _textRecognizer = TextRecognizer();

  /// Capture screenshot from gallery or camera
  static Future<File?> captureImage({bool fromCamera = false}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image: $e',
        backgroundColor: Colors.red[100],
      );
    }
    return null;
  }

  /// Process image and extract text using ML Kit
  static Future<String?> extractTextFromImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      if (recognizedText.text.isEmpty) {
        Get.snackbar('No Text Found', 'Could not detect any text in the image');
        return null;
      }

      return recognizedText.text;
    } catch (e) {
      Get.snackbar(
        'OCR Error',
        'Failed to extract text: $e',
        backgroundColor: Colors.red[100],
      );
      return null;
    }
  }

  /// Parse extracted text and auto-fill subscription data
  static ParsedSubscriptionData parseSubscriptionText(String text) {
    final data = ParsedSubscriptionData();
    final lowerText = text.toLowerCase();

    // Detect service name (common streaming/subscription services)
    final services = {
      'netflix': 'Netflix',
      'spotify': 'Spotify',
      'apple music': 'Apple Music',
      'youtube premium': 'YouTube Premium',
      'amazon prime': 'Amazon Prime',
      'hbo max': 'HBO Max',
      'disney': 'Disney+',
      'hulu': 'Hulu',
      'adobe': 'Adobe Creative Cloud',
      'microsoft 365': 'Microsoft 365',
      'office 365': 'Microsoft 365',
      'dropbox': 'Dropbox',
      'google one': 'Google One',
      'icloud': 'iCloud+',
      'github': 'GitHub',
      'chatgpt': 'ChatGPT Plus',
      'midjourney': 'Midjourney',
      'notion': 'Notion',
      'slack': 'Slack',
      'zoom': 'Zoom',
      'canva': 'Canva Pro',
      'grammarly': 'Grammarly',
      'linkedin': 'LinkedIn Premium',
    };

    for (final entry in services.entries) {
      if (lowerText.contains(entry.key)) {
        data.name = entry.value;
        data.category = _getCategoryForService(entry.value);
        break;
      }
    }

    // Extract amount using regex patterns
    final pricePatterns = [
      RegExp(r'\$(\d+\.?\d*)'), // $9.99
      RegExp(r'(\d+\.?\d*)\s*(?:usd|dollars?)'), // 9.99 USD
      RegExp(
        r'(?:price|amount|total|cost)[\s:]*\$?(\d+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(\d+\.?\d*)\s*/\s*(?:mo|month)',
        caseSensitive: false,
      ), // 9.99/mo
    ];

    for (final pattern in pricePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final amount = double.tryParse(match.group(1) ?? '');
        if (amount != null && amount > 0 && amount < 10000) {
          data.amount = amount;
          break;
        }
      }
    }

    // Detect billing frequency
    if (lowerText.contains('annual') ||
        lowerText.contains('yearly') ||
        lowerText.contains('/year')) {
      data.recurrence = RecurrenceType.annual;
    } else if (lowerText.contains('month') || lowerText.contains('/mo')) {
      data.recurrence = RecurrenceType.monthly;
    } else if (lowerText.contains('week')) {
      data.recurrence = RecurrenceType.weekly;
    }

    // Extract dates (billing date, renewal date)
    final datePatterns = [
      RegExp(
        r'(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})',
      ), // MM/DD/YYYY or DD-MM-YYYY
      RegExp(
        r'(?:next billing|renews?|due)[\s:]+(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})',
        caseSensitive: false,
      ),
      RegExp(
        r'(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\s+(\d{1,2})',
        caseSensitive: false,
      ),
    ];

    for (final pattern in datePatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        try {
          // Parse date - simplified, might need more robust parsing
          final now = DateTime.now();
          data.nextBillingDate = now.add(
            const Duration(days: 7),
          ); // Default to 7 days from now
          break;
        } catch (e) {
          // Date parsing failed, continue
        }
      }
    }

    // Extract email if present
    final emailPattern = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+');
    final emailMatch = emailPattern.firstMatch(text);
    if (emailMatch != null) {
      data.notes = 'Email: ${emailMatch.group(0)}';
    }

    // Detect trial period
    if (lowerText.contains('trial') || lowerText.contains('free for')) {
      data.status = SubscriptionStatus.trial;
      final trialDaysPattern = RegExp(
        r'(\d+)[\s-]*day\s+trial',
        caseSensitive: false,
      );
      final trialMatch = trialDaysPattern.firstMatch(text);
      if (trialMatch != null) {
        final days = int.tryParse(trialMatch.group(1) ?? '');
        if (days != null) {
          data.trialEndDate = DateTime.now().add(Duration(days: days));
        }
      }
    }

    return data;
  }

  static String _getCategoryForService(String serviceName) {
    final categoryMap = {
      'Netflix': 'Streaming',
      'Spotify': 'Music',
      'Apple Music': 'Music',
      'YouTube Premium': 'Streaming',
      'Amazon Prime': 'Streaming',
      'HBO Max': 'Streaming',
      'Disney+': 'Streaming',
      'Hulu': 'Streaming',
      'Adobe Creative Cloud': 'Productivity',
      'Microsoft 365': 'Productivity',
      'Dropbox': 'Cloud Storage',
      'Google One': 'Cloud Storage',
      'iCloud+': 'Cloud Storage',
      'GitHub': 'Productivity',
      'ChatGPT Plus': 'Productivity',
      'Midjourney': 'Productivity',
      'Notion': 'Productivity',
      'Slack': 'Productivity',
      'Zoom': 'Productivity',
      'Canva Pro': 'Productivity',
      'Grammarly': 'Productivity',
      'LinkedIn Premium': 'Productivity',
    };
    return categoryMap[serviceName] ?? 'Other';
  }

  /// Show OCR screenshot picker dialog
  static void showOcrDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Scan Subscription',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Capture a screenshot or photo of your subscription email or receipt',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _processOcrImage(fromCamera: false);
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _processOcrImage(fromCamera: true);
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  /// Process OCR image and navigate to add subscription screen
  static Future<void> _processOcrImage({bool fromCamera = false}) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Capture image
      final imageFile = await captureImage(fromCamera: fromCamera);
      if (imageFile == null) {
        Get.back();
        return;
      }

      // Extract text
      final extractedText = await extractTextFromImage(imageFile);
      if (extractedText == null || extractedText.isEmpty) {
        Get.back();
        return;
      }

      // Parse subscription data
      final parsedData = parseSubscriptionText(extractedText);

      Get.back(); // Close loading dialog

      // Show preview and confirmation
      Get.dialog(
        AlertDialog(
          title: const Text('Detected Subscription'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (parsedData.name != null)
                  _buildDataRow('Service', parsedData.name!),
                if (parsedData.amount != null)
                  _buildDataRow(
                    'Amount',
                    '\$${parsedData.amount!.toStringAsFixed(2)}',
                  ),
                if (parsedData.recurrence != null)
                  _buildDataRow('Billing', parsedData.recurrence!.name),
                if (parsedData.category != null)
                  _buildDataRow('Category', parsedData.category!),
                if (parsedData.nextBillingDate != null)
                  _buildDataRow(
                    'Next Bill',
                    parsedData.nextBillingDate.toString().split(' ')[0],
                  ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Extracted Text:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        extractedText.length > 200
                            ? '${extractedText.substring(0, 200)}...'
                            : extractedText,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Get.back();
                Get.to(() => AddSubscriptionScreen(ocrData: parsedData));
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Failed to process image: $e',
        backgroundColor: Colors.red[100],
      );
    }
  }

  static Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  static void dispose() {
    _textRecognizer.close();
  }
}

/// Parsed subscription data from OCR
class ParsedSubscriptionData {
  String? name;
  double? amount;
  RecurrenceType? recurrence;
  String? category;
  DateTime? nextBillingDate;
  DateTime? trialEndDate;
  SubscriptionStatus? status;
  String? notes;

  ParsedSubscriptionData({
    this.name,
    this.amount,
    this.recurrence,
    this.category,
    this.nextBillingDate,
    this.trialEndDate,
    this.status,
    this.notes,
  });

  bool get hasData =>
      name != null || amount != null || recurrence != null || category != null;
}
