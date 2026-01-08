import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // FAQ Section
          _buildSectionHeader(context, 'Frequently Asked Questions'),

          _buildFaqTile(
            context,
            question: 'How do I add a subscription?',
            answer:
                'Tap the + button at the bottom of the home screen. You can either choose from popular services or create a custom subscription with all the details you need.',
          ),

          _buildFaqTile(
            context,
            question: 'How do I set up bill reminders?',
            answer:
                'When adding or editing a subscription, you can set reminder days. Go to Settings > Notifications to set default reminder days for all subscriptions.',
          ),

          _buildFaqTile(
            context,
            question: 'Can I track subscriptions in different currencies?',
            answer:
                'Yes! Each subscription can have its own currency. Go to Settings > Currency to change your default display currency.',
          ),

          _buildFaqTile(
            context,
            question: 'How do I pause a subscription?',
            answer:
                'Long press on any subscription card and tap "Pause". You can also do this from the subscription detail screen.',
          ),

          _buildFaqTile(
            context,
            question: 'What happens when I delete a subscription?',
            answer:
                'The subscription will be permanently removed. If you want to keep it for records, consider archiving it instead.',
          ),

          _buildFaqTile(
            context,
            question: 'How do I export my data?',
            answer:
                'Go to Settings > Data > Export Data. You can export as JSON (full backup) or CSV (spreadsheet compatible).',
          ),

          _buildFaqTile(
            context,
            question: 'Is my data secure?',
            answer:
                'Yes! All your data is stored locally on your device. Cloud backup is optional and encrypted. We never share your data with third parties.',
          ),

          const SizedBox(height: 24),

          // Contact Section
          _buildSectionHeader(context, 'Contact Us'),

          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.email_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            title: const Text('Email Support'),
            subtitle: const Text('support@subtrak.app'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _launchEmail(),
          ),

          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.bug_report_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            title: const Text('Report a Bug'),
            subtitle: const Text('Help us improve SubTrak'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _launchBugReport(),
          ),

          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.lightbulb_outline,
                color: theme.colorScheme.primary,
              ),
            ),
            title: const Text('Feature Request'),
            subtitle: const Text('Suggest new features'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _launchFeatureRequest(),
          ),

          const SizedBox(height: 24),

          // App Info
          _buildSectionHeader(context, 'App Information'),

          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.info_outline,
                color: theme.colorScheme.onSurface,
              ),
            ),
            title: const Text('Version'),
            subtitle: const Text('1.0.0 (Build 1)'),
          ),

          const SizedBox(height: 40),

          // Support message
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Icon(Icons.favorite, color: Colors.red.shade400, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    'Thank you for using SubTrak!',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We\'re always working to make SubTrak better. Your feedback helps us improve!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildFaqTile(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    final theme = Theme.of(context);

    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      title: Text(
        question,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      children: [
        Text(
          answer,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.hintColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Future<void> _launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@subtrak.app',
      queryParameters: {'subject': 'SubTrak Support Request'},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'Error',
        'Could not open email client',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _launchBugReport() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'bugs@subtrak.app',
      queryParameters: {
        'subject': 'SubTrak Bug Report',
        'body':
            'Please describe the bug:\n\n\nSteps to reproduce:\n\n\nDevice info:\n\n',
      },
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'Error',
        'Could not open email client',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _launchFeatureRequest() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'features@subtrak.app',
      queryParameters: {
        'subject': 'SubTrak Feature Request',
        'body': 'I would like to suggest the following feature:\n\n',
      },
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'Error',
        'Could not open email client',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
