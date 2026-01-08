import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/data/models/insight_model.dart';
import '../../app/data/repositories/settings_repository.dart';
import '../../app/controllers/settings_controller.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  final SmartRuleRepository _ruleRepo = Get.find();
  final SettingsController _settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    final rules = _ruleRepo.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Rules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelp,
          ),
        ],
      ),
      body: rules.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rules.length,
              itemBuilder: (context, index) => _buildRuleCard(rules[index]),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createRule,
        icon: const Icon(Icons.add),
        label: const Text('Create Rule'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rule, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Smart Rules Yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Create automated rules to monitor your subscriptions',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _createRule,
            icon: const Icon(Icons.add),
            label: const Text('Create Your First Rule'),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard(SmartRule rule) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _editRule(rule),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      rule.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Switch(
                    value: rule.isEnabled,
                    onChanged: (enabled) async {
                      await _ruleRepo.toggleEnabled(rule.id);
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                rule.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              _buildRuleSummary(rule),
              if (rule.lastTriggeredAt != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.history, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Last triggered: ${_formatDate(rule.lastTriggeredAt!)} • ${rule.triggerCount} times',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _editRule(rule),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _deleteRule(rule),
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleSummary(SmartRule rule) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.arrow_forward, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'IF ${_getConditionText(rule.condition)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.notifications_active,
                size: 16,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'THEN ${_getActionText(rule.action)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getConditionText(SmartRuleCondition condition) {
    switch (condition.type) {
      case RuleConditionType.unusedForDays:
        return 'unused for ${condition.days} days';
      case RuleConditionType.costExceeds:
        return 'cost exceeds ${_settingsController.formatAmount(condition.threshold ?? 0)}';
      case RuleConditionType.categorySpendExceeds:
        return '${condition.category} spending exceeds ${_settingsController.formatAmount(condition.threshold ?? 0)}';
      case RuleConditionType.trialEndingSoon:
        return 'trial ending in ${condition.days} days';
      case RuleConditionType.priceIncreased:
        return 'price increased';
      case RuleConditionType.subscriptionAgeDays:
        return 'subscription older than ${condition.days} days';
      case RuleConditionType.lowUsage:
        return 'usage below ${condition.threshold}%';
    }
  }

  String _getActionText(SmartRuleAction action) {
    switch (action.type) {
      case RuleActionType.sendAlert:
        return 'send alert: "${action.message}"';
      case RuleActionType.createInsight:
        return 'create ${action.priority.name} priority insight';
      case RuleActionType.suggestCancel:
        return 'suggest cancellation';
      case RuleActionType.suggestPause:
        return 'suggest pausing';
      case RuleActionType.logWarning:
        return 'log warning';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    return '${(diff.inDays / 30).floor()} months ago';
  }

  void _createRule() {
    _showRuleEditor(null);
  }

  void _editRule(SmartRule rule) {
    _showRuleEditor(rule);
  }

  void _showRuleEditor(SmartRule? existingRule) {
    final isEdit = existingRule != null;

    String name = existingRule?.name ?? '';
    String description = existingRule?.description ?? '';
    RuleConditionType conditionType =
        existingRule?.condition.type ?? RuleConditionType.unusedForDays;
    int days = existingRule?.condition.days ?? 30;
    double threshold = existingRule?.condition.threshold ?? 50.0;
    String category = existingRule?.condition.category ?? 'Streaming';
    RuleActionType actionType =
        existingRule?.action.type ?? RuleActionType.createInsight;
    String actionMessage = existingRule?.action.message ?? '';
    InsightPriority priority =
        existingRule?.action.priority ?? InsightPriority.medium;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Rule' : 'Create Rule'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Rule Name',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: name),
                    onChanged: (v) => name = v,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: description),
                    maxLines: 2,
                    onChanged: (v) => description = v,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'IF Condition',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<RuleConditionType>(
                    value: conditionType,
                    decoration: const InputDecoration(
                      labelText: 'Condition Type',
                      border: OutlineInputBorder(),
                    ),
                    items: RuleConditionType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_getConditionTypeLabel(type)),
                      );
                    }).toList(),
                    onChanged: (v) => setDialogState(() => conditionType = v!),
                  ),
                  const SizedBox(height: 12),
                  if (conditionType == RuleConditionType.unusedForDays ||
                      conditionType == RuleConditionType.trialEndingSoon ||
                      conditionType == RuleConditionType.subscriptionAgeDays)
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Days',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(text: days.toString()),
                      onChanged: (v) => days = int.tryParse(v) ?? 30,
                    ),
                  if (conditionType == RuleConditionType.costExceeds ||
                      conditionType == RuleConditionType.categorySpendExceeds ||
                      conditionType == RuleConditionType.lowUsage)
                    TextField(
                      decoration: InputDecoration(
                        labelText: conditionType == RuleConditionType.lowUsage
                            ? 'Threshold (%)'
                            : 'Amount',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: threshold.toString(),
                      ),
                      onChanged: (v) => threshold = double.tryParse(v) ?? 50.0,
                    ),
                  if (conditionType == RuleConditionType.categorySpendExceeds)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: DropdownButtonFormField<String>(
                        value: category,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            [
                                  'Streaming',
                                  'Productivity',
                                  'Fitness',
                                  'Cloud Storage',
                                  'Gaming',
                                  'Education',
                                  'News',
                                  'Music',
                                  'Other',
                                ]
                                .map(
                                  (cat) => DropdownMenuItem(
                                    value: cat,
                                    child: Text(cat),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setDialogState(() => category = v!),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    'THEN Action',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<RuleActionType>(
                    value: actionType,
                    decoration: const InputDecoration(
                      labelText: 'Action Type',
                      border: OutlineInputBorder(),
                    ),
                    items: RuleActionType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_getActionTypeLabel(type)),
                      );
                    }).toList(),
                    onChanged: (v) => setDialogState(() => actionType = v!),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Action Message',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: actionMessage),
                    maxLines: 2,
                    onChanged: (v) => actionMessage = v,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<InsightPriority>(
                    value: priority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: InsightPriority.values.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text(p.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (v) => setDialogState(() => priority = v!),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (name.isEmpty || actionMessage.isEmpty) {
                  Get.snackbar('Error', 'Please fill all required fields');
                  return;
                }

                final rule = SmartRule(
                  id:
                      existingRule?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  description: description,
                  condition: SmartRuleCondition(
                    type: conditionType,
                    days: days,
                    threshold: threshold,
                    category: category,
                  ),
                  action: SmartRuleAction(
                    type: actionType,
                    message: actionMessage,
                    priority: priority,
                  ),
                  isEnabled: existingRule?.isEnabled ?? true,
                  createdAt: existingRule?.createdAt,
                  lastTriggeredAt: existingRule?.lastTriggeredAt,
                  triggerCount: existingRule?.triggerCount ?? 0,
                );

                if (isEdit) {
                  await _ruleRepo.update(rule);
                } else {
                  await _ruleRepo.add(rule);
                }

                setState(() {});
                Navigator.pop(context);
                Get.snackbar(
                  'Success',
                  isEdit ? 'Rule updated' : 'Rule created',
                );
              },
              child: Text(isEdit ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }

  String _getConditionTypeLabel(RuleConditionType type) {
    switch (type) {
      case RuleConditionType.unusedForDays:
        return 'Unused for X days';
      case RuleConditionType.costExceeds:
        return 'Cost exceeds amount';
      case RuleConditionType.categorySpendExceeds:
        return 'Category spending exceeds';
      case RuleConditionType.trialEndingSoon:
        return 'Trial ending soon';
      case RuleConditionType.priceIncreased:
        return 'Price increased';
      case RuleConditionType.subscriptionAgeDays:
        return 'Subscription age exceeds';
      case RuleConditionType.lowUsage:
        return 'Low usage detected';
    }
  }

  String _getActionTypeLabel(RuleActionType type) {
    switch (type) {
      case RuleActionType.sendAlert:
        return 'Send Alert';
      case RuleActionType.createInsight:
        return 'Create Insight';
      case RuleActionType.suggestCancel:
        return 'Suggest Cancel';
      case RuleActionType.suggestPause:
        return 'Suggest Pause';
      case RuleActionType.logWarning:
        return 'Log Warning';
    }
  }

  void _deleteRule(SmartRule rule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Rule'),
        content: Text('Are you sure you want to delete "${rule.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await _ruleRepo.delete(rule.id);
              setState(() {});
              Navigator.pop(context);
              Get.snackbar('Deleted', 'Rule deleted successfully');
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Smart Rules Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Smart Rules automate subscription monitoring and alerts.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('Example Rules:'),
              SizedBox(height: 8),
              Text('• IF Netflix unused for 30 days → Alert me'),
              Text(
                '• IF category spending > \$100 → Create high priority insight',
              ),
              Text('• IF trial ending in 3 days → Send notification'),
              Text('• IF price increased → Suggest review'),
              SizedBox(height: 16),
              Text(
                'Rules run automatically in the background and trigger actions when conditions are met.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
