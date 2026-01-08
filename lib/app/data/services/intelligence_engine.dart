import '../models/subscription_model.dart';
import '../models/insight_model.dart';
import '../repositories/subscription_repository.dart';
import '../repositories/settings_repository.dart';

/// The Subscription Intelligence Engine
/// Provides advanced analytics, insights, and recommendations
class IntelligenceEngine {
  final SubscriptionRepository _subscriptionRepo;
  final SettingsRepository _settingsRepo;
  final InsightRepository _insightRepo;

  IntelligenceEngine({
    required SubscriptionRepository subscriptionRepo,
    required SettingsRepository settingsRepo,
    required InsightRepository insightRepo,
  }) : _subscriptionRepo = subscriptionRepo,
       _settingsRepo = settingsRepo,
       _insightRepo = insightRepo;

  /// Run full analysis and generate insights
  Future<List<InsightModel>> runFullAnalysis() async {
    final insights = <InsightModel>[];

    insights.addAll(await _detectUnusedSubscriptions());
    insights.addAll(await _detectPriceIncreases());
    insights.addAll(await _detectDuplicateServices());
    insights.addAll(await _detectTrialsEndingSoon());
    insights.addAll(await _detectBudgetWarnings());
    insights.addAll(await _detectRegretSubscriptions());
    insights.addAll(await _detectSpendDrift());
    insights.addAll(await _generateCostSavingOpportunities());
    insights.addAll(await _generateBehavioralNudges());

    // Store insights
    for (final insight in insights) {
      await _insightRepo.add(insight);
    }

    return insights;
  }

  /// Detect unused subscriptions
  Future<List<InsightModel>> _detectUnusedSubscriptions() async {
    final insights = <InsightModel>[];
    final subscriptions = _subscriptionRepo.getActive();
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    for (final sub in subscriptions) {
      // Check if no usage logged in last 30 days
      final recentUsage = sub.usageLogs
          .where((log) => log.date.isAfter(thirtyDaysAgo))
          .fold<int>(0, (sum, log) => sum + log.usageMinutes);

      if (sub.usageLogs.isNotEmpty && recentUsage == 0) {
        insights.add(
          InsightModel(
            id: 'unused_${sub.id}_${now.millisecondsSinceEpoch}',
            type: InsightType.unusedSubscription,
            title: '${sub.name} appears unused',
            description:
                'You haven\'t logged any usage for ${sub.name} in the last 30 days. '
                'Consider if you still need this subscription.',
            priority: InsightPriority.medium,
            potentialSavings: sub.monthlyEquivalent,
            currencyCode: sub.currencyCode,
            relatedSubscriptionIds: [sub.id],
            actions: [
              InsightAction(
                type: InsightActionType.cancel,
                label: 'Cancel subscription',
                subscriptionId: sub.id,
              ),
              InsightAction(
                type: InsightActionType.pause,
                label: 'Pause for now',
                subscriptionId: sub.id,
              ),
              InsightAction(
                type: InsightActionType.logUsage,
                label: 'Log usage',
                subscriptionId: sub.id,
              ),
              InsightAction(type: InsightActionType.dismiss, label: 'Dismiss'),
            ],
            iconName: 'warning',
            colorHex: '#FFA000',
          ),
        );
      }
    }

    return insights;
  }

  /// Detect price increases
  Future<List<InsightModel>> _detectPriceIncreases() async {
    final insights = <InsightModel>[];
    final subscriptions = _subscriptionRepo.getActive();
    final now = DateTime.now();

    for (final sub in subscriptions) {
      final increasePercent = sub.priceIncreasePercent;
      if (increasePercent != null && increasePercent > 10) {
        insights.add(
          InsightModel(
            id: 'price_increase_${sub.id}_${now.millisecondsSinceEpoch}',
            type: InsightType.priceIncrease,
            title:
                '${sub.name} price increased ${increasePercent.toStringAsFixed(0)}%',
            description:
                'The price of ${sub.name} has increased by ${increasePercent.toStringAsFixed(0)}% '
                'since you first subscribed. Consider reviewing alternatives.',
            priority: increasePercent > 25
                ? InsightPriority.high
                : InsightPriority.medium,
            relatedSubscriptionIds: [sub.id],
            actions: [
              InsightAction(
                type: InsightActionType.review,
                label: 'Review alternatives',
                subscriptionId: sub.id,
              ),
              InsightAction(
                type: InsightActionType.negotiate,
                label: 'Try to negotiate',
                subscriptionId: sub.id,
              ),
              InsightAction(type: InsightActionType.dismiss, label: 'Dismiss'),
            ],
            iconName: 'trending_up',
            colorHex: '#F44336',
          ),
        );
      }
    }

    return insights;
  }

  /// Detect duplicate or overlapping services
  Future<List<InsightModel>> _detectDuplicateServices() async {
    final insights = <InsightModel>[];
    final subscriptions = _subscriptionRepo.getActive();
    final now = DateTime.now();

    // Group by category
    final byCategory = <SubscriptionCategory, List<SubscriptionModel>>{};
    for (final sub in subscriptions) {
      byCategory.putIfAbsent(sub.category, () => []).add(sub);
    }

    // Check for duplicates within categories
    final duplicateCandidates = {
      SubscriptionCategory.streaming: ['streaming', 'video', 'movies', 'shows'],
      SubscriptionCategory.music: ['music', 'audio', 'songs'],
      SubscriptionCategory.cloud: ['storage', 'cloud', 'drive', 'backup'],
      SubscriptionCategory.news: ['news', 'reading', 'books', 'articles'],
    };

    for (final entry in byCategory.entries) {
      if (entry.value.length > 1 &&
          duplicateCandidates.containsKey(entry.key)) {
        final totalSpend = entry.value.fold<double>(
          0,
          (sum, sub) => sum + sub.monthlyEquivalent,
        );

        insights.add(
          InsightModel(
            id: 'duplicate_${entry.key.name}_${now.millisecondsSinceEpoch}',
            type: InsightType.duplicateService,
            title: 'Multiple ${entry.key.name} subscriptions',
            description:
                'You have ${entry.value.length} ${entry.key.name} subscriptions '
                'costing ₹${totalSpend.toStringAsFixed(0)}/month combined. '
                'Consider consolidating.',
            priority: InsightPriority.medium,
            potentialSavings: entry.value
                .map((s) => s.monthlyEquivalent)
                .reduce((a, b) => a < b ? a : b),
            currencyCode: 'INR',
            relatedSubscriptionIds: entry.value.map((s) => s.id).toList(),
            actions: [
              InsightAction(
                type: InsightActionType.review,
                label: 'Compare services',
              ),
              InsightAction(type: InsightActionType.dismiss, label: 'Dismiss'),
            ],
            iconName: 'content_copy',
            colorHex: '#FF9800',
          ),
        );
      }
    }

    return insights;
  }

  /// Detect trials ending soon
  Future<List<InsightModel>> _detectTrialsEndingSoon() async {
    final insights = <InsightModel>[];
    final trials = _subscriptionRepo.getTrialsEndingSoon(days: 7);
    final now = DateTime.now();

    for (final sub in trials) {
      final daysLeft = sub.trialEndDate!.difference(now).inDays;
      insights.add(
        InsightModel(
          id: 'trial_ending_${sub.id}_${now.millisecondsSinceEpoch}',
          type: InsightType.trialEnding,
          title: '${sub.name} trial ends in $daysLeft days',
          description:
              'Your ${sub.name} trial ends on ${_formatDate(sub.trialEndDate!)}. '
              'Decide if you want to continue at ₹${sub.amount}/month.',
          priority: daysLeft <= 2
              ? InsightPriority.critical
              : InsightPriority.high,
          potentialSavings: sub.monthlyEquivalent,
          currencyCode: sub.currencyCode,
          relatedSubscriptionIds: [sub.id],
          actions: [
            InsightAction(
              type: InsightActionType.cancel,
              label: 'Cancel before trial ends',
              subscriptionId: sub.id,
            ),
            InsightAction(
              type: InsightActionType.remind,
              label: 'Remind me later',
              subscriptionId: sub.id,
            ),
            InsightAction(
              type: InsightActionType.dismiss,
              label: 'Keep subscription',
            ),
          ],
          iconName: 'timer',
          colorHex: '#E91E63',
          expiresAt: sub.trialEndDate,
        ),
      );
    }

    return insights;
  }

  /// Detect budget warnings
  Future<List<InsightModel>> _detectBudgetWarnings() async {
    final insights = <InsightModel>[];
    final settings = _settingsRepo.getSettings();
    final budget = settings.budgetSettings;
    final now = DateTime.now();

    if (budget.monthlyBudget != null) {
      final currentSpend = _subscriptionRepo.getTotalMonthlySpend();
      final budgetPercent = (currentSpend / budget.monthlyBudget!) * 100;

      if (budgetPercent >= budget.thresholdPercent) {
        insights.add(
          InsightModel(
            id: 'budget_warning_${now.millisecondsSinceEpoch}',
            type: InsightType.budgetWarning,
            title: budgetPercent >= 100
                ? 'Budget exceeded!'
                : 'Approaching budget limit',
            description:
                'Your subscription spending is at ${budgetPercent.toStringAsFixed(0)}% '
                'of your ₹${budget.monthlyBudget!.toStringAsFixed(0)} monthly budget. '
                '${budgetPercent >= 100 ? 'Consider reviewing your subscriptions.' : ''}',
            priority: budgetPercent >= 100
                ? InsightPriority.critical
                : InsightPriority.high,
            actions: [
              InsightAction(
                type: InsightActionType.review,
                label: 'Review subscriptions',
              ),
              InsightAction(type: InsightActionType.dismiss, label: 'Dismiss'),
            ],
            iconName: 'account_balance_wallet',
            colorHex: budgetPercent >= 100 ? '#F44336' : '#FF9800',
          ),
        );
      }
    }

    return insights;
  }

  /// Detect regret subscriptions (high cost, low usage)
  Future<List<InsightModel>> _detectRegretSubscriptions() async {
    final insights = <InsightModel>[];
    final subscriptions = _subscriptionRepo.getActive();
    final now = DateTime.now();

    for (final sub in subscriptions) {
      // Skip if no usage data or subscription is new
      if (sub.usageLogs.isEmpty || now.difference(sub.createdAt).inDays < 30) {
        continue;
      }

      final costPerUse = sub.costPerUse;
      if (costPerUse > 100) {
        // More than ₹100 per hour of use
        insights.add(
          InsightModel(
            id: 'regret_${sub.id}_${now.millisecondsSinceEpoch}',
            type: InsightType.regretDetection,
            title: '${sub.name} has high cost per use',
            description:
                'You\'re paying ₹${costPerUse.toStringAsFixed(0)} per hour of use for ${sub.name}. '
                'This might not be worth the cost.',
            priority: costPerUse > 200
                ? InsightPriority.high
                : InsightPriority.medium,
            potentialSavings: sub.monthlyEquivalent,
            currencyCode: sub.currencyCode,
            relatedSubscriptionIds: [sub.id],
            actions: [
              InsightAction(
                type: InsightActionType.cancel,
                label: 'Cancel subscription',
                subscriptionId: sub.id,
              ),
              InsightAction(
                type: InsightActionType.downgrade,
                label: 'Look for cheaper plan',
                subscriptionId: sub.id,
              ),
              InsightAction(type: InsightActionType.dismiss, label: 'Dismiss'),
            ],
            iconName: 'sentiment_dissatisfied',
            colorHex: '#9C27B0',
            metadata: {'costPerUse': costPerUse},
          ),
        );
      }
    }

    return insights;
  }

  /// Detect spend drift (gradual increase over time)
  Future<List<InsightModel>> _detectSpendDrift() async {
    final insights = <InsightModel>[];
    final now = DateTime.now();

    // Compare current month to 3 months ago using payment history
    final subscriptions = _subscriptionRepo.getActive();
    final threeMonthsAgo = now.subtract(const Duration(days: 90));

    double historicalMonthly = 0;
    int subsWithHistory = 0;

    for (final sub in subscriptions) {
      // Check if subscription existed 3 months ago
      if (sub.createdAt.isBefore(threeMonthsAgo)) {
        final oldPayments = sub.paymentHistory
            .where((p) => p.date.isBefore(threeMonthsAgo))
            .toList();
        if (oldPayments.isNotEmpty) {
          historicalMonthly += oldPayments.last.amount;
          subsWithHistory++;
        }
      }
    }

    if (subsWithHistory >= 3) {
      final currentMonthly = _subscriptionRepo.getTotalMonthlySpend();
      final driftPercent =
          ((currentMonthly - historicalMonthly) / historicalMonthly) * 100;

      if (driftPercent > 15) {
        insights.add(
          InsightModel(
            id: 'spend_drift_${now.millisecondsSinceEpoch}',
            type: InsightType.spendDrift,
            title:
                'Subscription spending up ${driftPercent.toStringAsFixed(0)}%',
            description:
                'Your subscription spending has increased by ${driftPercent.toStringAsFixed(0)}% '
                'over the last 3 months. You\'re now spending '
                '₹${(currentMonthly - historicalMonthly).toStringAsFixed(0)} more per month.',
            priority: driftPercent > 30
                ? InsightPriority.high
                : InsightPriority.medium,
            potentialSavings: currentMonthly - historicalMonthly,
            currencyCode: 'INR',
            actions: [
              InsightAction(
                type: InsightActionType.review,
                label: 'Review recent additions',
              ),
              InsightAction(type: InsightActionType.dismiss, label: 'Dismiss'),
            ],
            iconName: 'show_chart',
            colorHex: '#FF5722',
          ),
        );
      }
    }

    return insights;
  }

  /// Generate cost saving opportunities
  Future<List<InsightModel>> _generateCostSavingOpportunities() async {
    final insights = <InsightModel>[];
    final subscriptions = _subscriptionRepo.getActive();
    final now = DateTime.now();

    // Find subscriptions that could be switched to annual billing
    for (final sub in subscriptions) {
      if (sub.recurrenceType == RecurrenceType.monthly &&
          now.difference(sub.createdAt).inDays > 60) {
        // Typically annual plans are 15-20% cheaper
        final potentialSavings = sub.monthlyEquivalent * 12 * 0.17;
        if (potentialSavings > 500) {
          // Only if savings are significant
          insights.add(
            InsightModel(
              id: 'annual_switch_${sub.id}_${now.millisecondsSinceEpoch}',
              type: InsightType.costSaving,
              title: 'Save on ${sub.name} with annual billing',
              description:
                  'Switching ${sub.name} to annual billing could save you approximately '
                  '₹${potentialSavings.toStringAsFixed(0)} per year (typically 15-20% discount).',
              priority: InsightPriority.low,
              potentialSavings: potentialSavings / 12, // Monthly equivalent
              currencyCode: sub.currencyCode,
              relatedSubscriptionIds: [sub.id],
              actions: [
                InsightAction(
                  type: InsightActionType.viewDetails,
                  label: 'Check annual pricing',
                  subscriptionId: sub.id,
                  url: sub.websiteUrl,
                ),
                InsightAction(
                  type: InsightActionType.dismiss,
                  label: 'Not interested',
                ),
              ],
              iconName: 'savings',
              colorHex: '#4CAF50',
            ),
          );
        }
      }
    }

    return insights;
  }

  /// Generate behavioral nudges (ethical, no dark patterns)
  Future<List<InsightModel>> _generateBehavioralNudges() async {
    final insights = <InsightModel>[];
    final settings = _settingsRepo.getSettings();
    final now = DateTime.now();

    // Nudge for setting up budget if not done
    if (settings.budgetSettings.monthlyBudget == null) {
      final currentSpend = _subscriptionRepo.getTotalMonthlySpend();
      insights.add(
        InsightModel(
          id: 'budget_setup_nudge_${now.millisecondsSinceEpoch}',
          type: InsightType.behavioralNudge,
          title: 'Set up a monthly budget',
          description:
              'You\'re currently spending ₹${currentSpend.toStringAsFixed(0)}/month on subscriptions. '
              'Setting a budget helps you stay in control of your spending.',
          priority: InsightPriority.low,
          actions: [
            InsightAction(
              type: InsightActionType.viewDetails,
              label: 'Set budget',
            ),
            InsightAction(
              type: InsightActionType.dismiss,
              label: 'Maybe later',
            ),
          ],
          iconName: 'tips_and_updates',
          colorHex: '#2196F3',
          expiresAt: now.add(const Duration(days: 7)),
        ),
      );
    }

    // Nudge for logging usage
    final subsWithoutRecentUsage = _subscriptionRepo.getActive().where((sub) {
      if (sub.usageLogs.isEmpty) return true;
      final lastLog = sub.usageLogs.reduce(
        (a, b) => a.date.isAfter(b.date) ? a : b,
      );
      return now.difference(lastLog.date).inDays > 14;
    }).toList();

    if (subsWithoutRecentUsage.isNotEmpty) {
      insights.add(
        InsightModel(
          id: 'log_usage_nudge_${now.millisecondsSinceEpoch}',
          type: InsightType.behavioralNudge,
          title: 'Track your subscription usage',
          description:
              'Logging how often you use your subscriptions helps identify '
              'which ones are worth keeping. ${subsWithoutRecentUsage.length} '
              'subscriptions haven\'t been logged recently.',
          priority: InsightPriority.low,
          actions: [
            InsightAction(
              type: InsightActionType.logUsage,
              label: 'Log usage now',
            ),
            InsightAction(type: InsightActionType.dismiss, label: 'Dismiss'),
          ],
          iconName: 'track_changes',
          colorHex: '#00BCD4',
          expiresAt: now.add(const Duration(days: 7)),
        ),
      );
    }

    return insights;
  }

  /// Calculate "Worth It" score for a subscription (0-100)
  int calculateWorthItScore(SubscriptionModel subscription) {
    int score = 50; // Base score

    // Factor 1: Usage frequency (if available)
    if (subscription.usageLogs.isNotEmpty) {
      final averageUsage = subscription.averageMonthlyUsage;
      if (averageUsage > 600) {
        score += 20; // More than 10 hours/month
      } else if (averageUsage > 300) {
        score += 10;
      } else if (averageUsage > 60) {
        score += 5;
      } else if (averageUsage < 30) {
        score -= 15; // Less than 30 min/month
      }
    }

    // Factor 2: Cost per day
    final costPerDay = subscription.costPerDay;
    if (costPerDay < 10) {
      score += 10;
    } else if (costPerDay > 50) {
      score -= 10;
    }

    // Factor 3: Subscription age (longer = more committed)
    final ageInDays = DateTime.now().difference(subscription.createdAt).inDays;
    if (ageInDays > 365) {
      score += 10;
    } else if (ageInDays < 30) {
      score -= 5; // New subscription, not enough data
    }

    // Factor 4: Price history (no increases = stable)
    final priceIncrease = subscription.priceIncreasePercent;
    if (priceIncrease != null && priceIncrease > 20) {
      score -= 15;
    }

    // Factor 5: Payment failures
    final failedPayments = subscription.paymentHistory
        .where((p) => !p.successful)
        .length;
    if (failedPayments > 0) {
      score -= failedPayments * 5;
    }

    // Clamp score to 0-100
    return score.clamp(0, 100);
  }

  /// Get monthly summary data
  MonthlySummary getMonthlySummary() {
    final subscriptions = _subscriptionRepo.getActive();
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    final thisMonthBills = _subscriptionRepo.getInDateRange(
      monthStart,
      monthEnd,
    );
    final totalThisMonth = thisMonthBills.fold<double>(
      0,
      (sum, s) => sum + s.amount,
    );

    final categorySpend = _subscriptionRepo.getSpendByCategory();
    final topCategory = categorySpend.entries.isNotEmpty
        ? categorySpend.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : null;

    final potentialSavings = _insightRepo.getTotalPotentialSavings();

    return MonthlySummary(
      month: now,
      totalSpend: _subscriptionRepo.getTotalMonthlySpend(),
      totalThisMonth: totalThisMonth,
      billsThisMonth: thisMonthBills.length,
      activeSubscriptions: subscriptions.length,
      topCategory: topCategory,
      topCategorySpend: topCategory != null
          ? categorySpend[topCategory] ?? 0
          : 0,
      potentialSavings: potentialSavings,
      yearlyProjection: _subscriptionRepo.getTotalAnnualSpend(),
    );
  }

  /// Get upcoming spend preview
  SpendPreview getSpendPreview({int days = 30}) {
    final upcoming = _subscriptionRepo.getUpcoming(days: days);
    final total = upcoming.fold<double>(0, (sum, s) => sum + s.amount);

    final byDay = <DateTime, double>{};
    for (final sub in upcoming) {
      final date = DateTime(
        sub.nextBillingDate.year,
        sub.nextBillingDate.month,
        sub.nextBillingDate.day,
      );
      byDay[date] = (byDay[date] ?? 0) + sub.amount;
    }

    return SpendPreview(
      days: days,
      totalAmount: total,
      billCount: upcoming.length,
      amountByDay: byDay,
      subscriptions: upcoming,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Monthly summary data class
class MonthlySummary {
  final DateTime month;
  final double totalSpend;
  final double totalThisMonth;
  final int billsThisMonth;
  final int activeSubscriptions;
  final SubscriptionCategory? topCategory;
  final double topCategorySpend;
  final double potentialSavings;
  final double yearlyProjection;

  const MonthlySummary({
    required this.month,
    required this.totalSpend,
    required this.totalThisMonth,
    required this.billsThisMonth,
    required this.activeSubscriptions,
    this.topCategory,
    required this.topCategorySpend,
    required this.potentialSavings,
    required this.yearlyProjection,
  });
}

/// Spend preview data class
class SpendPreview {
  final int days;
  final double totalAmount;
  final int billCount;
  final Map<DateTime, double> amountByDay;
  final List<SubscriptionModel> subscriptions;

  const SpendPreview({
    required this.days,
    required this.totalAmount,
    required this.billCount,
    required this.amountByDay,
    required this.subscriptions,
  });
}
