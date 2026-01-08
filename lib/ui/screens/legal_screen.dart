import 'package:flutter/material.dart';

enum LegalType { privacy, terms }

class LegalScreen extends StatelessWidget {
  final LegalType type;

  const LegalScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPrivacy = type == LegalType.privacy;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPrivacy ? 'Privacy Policy' : 'Terms of Service'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isPrivacy ? 'Privacy Policy' : 'Terms of Service',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: January 2026',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 24),
            if (isPrivacy)
              ..._buildPrivacyContent(context)
            else
              ..._buildTermsContent(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPrivacyContent(BuildContext context) {
    return [
      _buildSection(
        context,
        title: '1. Information We Collect',
        content: '''
SubTrak is designed with your privacy in mind. We collect minimal data necessary to provide our services:

• **Subscription Data**: Names, amounts, billing dates, and categories of your subscriptions. This data is stored locally on your device.

• **App Usage**: Anonymous analytics about how you use the app (if enabled) to help us improve the experience.

• **Device Information**: Basic device information for crash reporting and troubleshooting.

We do NOT collect:
• Personal identification information
• Payment or banking details
• Location data
• Contact information
''',
      ),
      _buildSection(
        context,
        title: '2. How We Use Your Data',
        content: '''
Your data is used exclusively to:

• Display your subscriptions and spending insights
• Send bill reminders and notifications
• Generate spending analytics and insights
• Improve app performance and fix bugs

We never sell, share, or trade your personal data with third parties.
''',
      ),
      _buildSection(
        context,
        title: '3. Data Storage',
        content: '''
• **Local Storage**: All subscription data is stored locally on your device using encrypted storage.

• **Cloud Backup** (Optional): If enabled, your data is encrypted end-to-end before being backed up to secure cloud servers.

• **Data Retention**: Your data remains on your device until you delete it. Cloud backups are retained for 30 days after account deletion.
''',
      ),
      _buildSection(
        context,
        title: '4. Your Rights',
        content: '''
You have the right to:

• **Access**: View all data we have about you
• **Export**: Download your data at any time
• **Delete**: Permanently delete all your data
• **Opt-out**: Disable analytics and cloud features

Exercise these rights in Settings > Data.
''',
      ),
      _buildSection(
        context,
        title: '5. Security',
        content: '''
We implement industry-standard security measures:

• AES-256 encryption for stored data
• Secure HTTPS connections
• Optional biometric authentication
• No third-party data sharing

Your security is our priority.
''',
      ),
      _buildSection(
        context,
        title: '6. Contact Us',
        content: '''
For privacy-related inquiries:

Email: privacy@subtrak.app

We respond to all inquiries within 48 hours.
''',
      ),
    ];
  }

  List<Widget> _buildTermsContent(BuildContext context) {
    return [
      _buildSection(
        context,
        title: '1. Acceptance of Terms',
        content: '''
By downloading, installing, or using SubTrak, you agree to these Terms of Service. If you do not agree, please do not use the app.

These terms may be updated from time to time. Continued use of the app after changes constitutes acceptance of the new terms.
''',
      ),
      _buildSection(
        context,
        title: '2. Description of Service',
        content: '''
SubTrak is a subscription tracking application that helps you:

• Track recurring payments and subscriptions
• Receive bill reminders and notifications
• Analyze spending patterns
• Manage your subscription portfolio

The app is provided "as is" for personal, non-commercial use.
''',
      ),
      _buildSection(
        context,
        title: '3. User Responsibilities',
        content: '''
As a user, you agree to:

• Provide accurate subscription information
• Use the app for lawful purposes only
• Not attempt to reverse engineer or modify the app
• Not use the app to infringe on others' rights
• Keep your device and app access secure
''',
      ),
      _buildSection(
        context,
        title: '4. Subscriptions & Payments',
        content: '''
**Free Tier**: Basic features with limited subscriptions.

**Pro Subscription**: 
• Monthly or annual billing
• Cancel anytime
• Refunds per app store policy

**Lifetime Access**:
• One-time purchase
• All current and future Pro features

Prices may vary by region and are subject to change.
''',
      ),
      _buildSection(
        context,
        title: '5. Intellectual Property',
        content: '''
SubTrak and all its contents, features, and functionality are owned by SubTrak and are protected by international copyright, trademark, and other intellectual property laws.

You may not copy, modify, distribute, or create derivative works without permission.
''',
      ),
      _buildSection(
        context,
        title: '6. Limitation of Liability',
        content: '''
SubTrak is a tracking tool only. We are not responsible for:

• Missed payments or late fees
• Inaccurate data you enter
• Third-party subscription services
• Financial decisions based on app insights

Always verify important financial information independently.
''',
      ),
      _buildSection(
        context,
        title: '7. Termination',
        content: '''
We reserve the right to suspend or terminate your access if you violate these terms.

You may stop using the app at any time by uninstalling it. Your local data will be deleted; cloud backups will be retained per our data retention policy.
''',
      ),
      _buildSection(
        context,
        title: '8. Contact',
        content: '''
For questions about these terms:

Email: legal@subtrak.app

Thank you for using SubTrak!
''',
      ),
    ];
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content.trim(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
