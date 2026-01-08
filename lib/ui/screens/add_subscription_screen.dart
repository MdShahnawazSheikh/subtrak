import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/data/models/subscription_model.dart';
import '../../app/data/models/subscription_template_model.dart';
import '../../app/controllers/subscription_controller.dart';
import '../../app/services/ocr_service.dart';
import '../widgets/premium_components.dart';

class AddSubscriptionScreen extends StatefulWidget {
  final SubscriptionModel? editSubscription;
  final ParsedSubscriptionData? ocrData;

  const AddSubscriptionScreen({super.key, this.editSubscription, this.ocrData});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen>
    with SingleTickerProviderStateMixin {
  final SubscriptionController _controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  late TabController _tabController;

  // Form fields
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagController = TextEditingController();

  RecurrenceType _recurrenceType = RecurrenceType.monthly;
  SubscriptionCategory _category = SubscriptionCategory.other;
  PaymentMethod _paymentMethod = PaymentMethod.creditCard;
  DateTime _startDate = DateTime.now();
  DateTime? _nextBillingDate;
  bool _isTrial = false;
  DateTime? _trialEndDate;
  String? _colorHex;
  List<String> _tags = [];
  bool _autoRenew = true;
  List<int> _reminderDays = [3, 1];

  bool get _isEditing => widget.editSubscription != null;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (_isEditing) {
      _loadSubscription(widget.editSubscription!);
    } else if (widget.ocrData != null) {
      _loadOcrData(widget.ocrData!);
    }
  }

  void _loadOcrData(ParsedSubscriptionData data) {
    if (data.name != null) _nameController.text = data.name!;
    if (data.amount != null) _amountController.text = data.amount!.toString();
    if (data.recurrence != null) _recurrenceType = data.recurrence!;
    if (data.category != null) {
      try {
        _category = SubscriptionCategory.values.firstWhere(
          (c) => c.name.toLowerCase() == data.category!.toLowerCase(),
          orElse: () => SubscriptionCategory.other,
        );
      } catch (e) {
        _category = SubscriptionCategory.other;
      }
    }
    if (data.nextBillingDate != null) _nextBillingDate = data.nextBillingDate;
    if (data.status != null && data.status == SubscriptionStatus.trial) {
      _isTrial = true;
      if (data.trialEndDate != null) _trialEndDate = data.trialEndDate;
    }
    if (data.notes != null) _notesController.text = data.notes!;
  }

  void _loadSubscription(SubscriptionModel sub) {
    _nameController.text = sub.name;
    _amountController.text = sub.amount.toString();
    _descriptionController.text = sub.description ?? '';
    _notesController.text = sub.notes ?? '';
    _recurrenceType = sub.recurrenceType;
    _category = sub.category;
    _paymentMethod = sub.paymentMethod;
    _startDate = sub.startDate;
    _nextBillingDate = sub.nextBillingDate;
    _isTrial = sub.isTrial;
    _trialEndDate = sub.trialEndDate;
    _colorHex = sub.colorHex;
    _tags = List.from(sub.tags);
    _autoRenew = sub.autoRenew;
    _reminderDays = List.from(sub.notificationPreference.daysBefore);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Subscription' : 'Add Subscription'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: _isEditing
            ? null
            : TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Quick Add'),
                  Tab(text: 'Custom'),
                ],
              ),
      ),
      body: _isEditing
          ? _buildForm(context)
          : TabBarView(
              controller: _tabController,
              children: [_buildQuickAdd(context), _buildForm(context)],
            ),
    );
  }

  Widget _buildQuickAdd(BuildContext context) {
    final theme = Theme.of(context);
    final allTemplates = SubscriptionTemplate.allTemplates;

    // Filter templates by search
    final filteredTemplates = _searchQuery.isEmpty
        ? allTemplates
        : allTemplates.where((t) {
            return t.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                t.aliases.any(
                  (a) => a.toLowerCase().contains(_searchQuery.toLowerCase()),
                );
          }).toList();

    // Group templates by category
    final grouped = <String, List<SubscriptionTemplate>>{};
    for (final template in filteredTemplates) {
      grouped.putIfAbsent(template.category, () => []).add(template);
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search services...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
        ),

        // Popular section
        if (_searchQuery.isEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                'POPULAR',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: SubscriptionTemplate.popularTemplates.length,
                itemBuilder: (context, index) {
                  final template = SubscriptionTemplate.popularTemplates[index];
                  return _buildPopularTemplateCard(context, template);
                },
              ),
            ),
          ),
        ],

        // Category sections
        ...grouped.entries.map((entry) {
          return SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Text(
                    entry.key.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.value
                        .map((t) => _buildTemplateChip(context, t))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        }),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildPopularTemplateCard(
    BuildContext context,
    SubscriptionTemplate template,
  ) {
    final theme = Theme.of(context);
    final color = _parseColor(template.colorHex);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectTemplate(template),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      template.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  template.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateChip(
    BuildContext context,
    SubscriptionTemplate template,
  ) {
    final color = _parseColor(template.colorHex);

    return ActionChip(
      avatar: CircleAvatar(
        backgroundColor: color,
        child: Text(
          template.name[0].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      label: Text(template.name),
      onPressed: () => _selectTemplate(template),
    );
  }

  void _selectTemplate(SubscriptionTemplate template) {
    HapticFeedback.lightImpact();

    _nameController.text = template.name;
    _amountController.text = template.suggestedAmount?.toString() ?? '';
    _descriptionController.text = template.description ?? '';
    _colorHex = template.colorHex;
    _category = _parseCategory(template.category);
    _recurrenceType = _parseRecurrence(template.recurrenceType);

    // Switch to custom form tab
    _tabController.animateTo(1);
    setState(() {});
  }

  Widget _buildForm(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Name field
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Subscription Name',
              hintText: 'e.g., Netflix, Spotify',
              prefixIcon: Icon(Icons.subscriptions_outlined),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter a name' : null,
          ),
          const SizedBox(height: 16),

          // Amount field
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              hintText: 'e.g., 199',
              prefixIcon: Icon(Icons.currency_rupee),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please enter an amount';
              if (double.tryParse(value!) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Recurrence dropdown
          DropdownButtonFormField<RecurrenceType>(
            value: _recurrenceType,
            decoration: const InputDecoration(
              labelText: 'Billing Cycle',
              prefixIcon: Icon(Icons.repeat),
            ),
            items: RecurrenceType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(_getRecurrenceLabel(type)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _recurrenceType = value);
              }
            },
          ),
          const SizedBox(height: 16),

          // Category dropdown
          DropdownButtonFormField<SubscriptionCategory>(
            value: _category,
            decoration: const InputDecoration(
              labelText: 'Category',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: SubscriptionCategory.values.map((cat) {
              return DropdownMenuItem(
                value: cat,
                child: Text(_getCategoryLabel(cat)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _category = value);
              }
            },
          ),
          const SizedBox(height: 16),

          // Payment method dropdown
          DropdownButtonFormField<PaymentMethod>(
            value: _paymentMethod,
            decoration: const InputDecoration(
              labelText: 'Payment Method',
              prefixIcon: Icon(Icons.payment),
            ),
            items: PaymentMethod.values.map((method) {
              return DropdownMenuItem(
                value: method,
                child: Text(_getPaymentMethodLabel(method)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _paymentMethod = value);
              }
            },
          ),
          const SizedBox(height: 16),

          // Start date
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today),
            title: const Text('Start Date'),
            subtitle: Text(DateFormat('MMM dd, yyyy').format(_startDate)),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _startDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                setState(() => _startDate = date);
              }
            },
          ),
          const Divider(),

          // Next billing date
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event),
            title: const Text('Next Billing Date'),
            subtitle: Text(
              _nextBillingDate != null
                  ? DateFormat('MMM dd, yyyy').format(_nextBillingDate!)
                  : 'Same as start date',
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _nextBillingDate ?? _startDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                setState(() => _nextBillingDate = date);
              }
            },
          ),
          const Divider(),

          // Trial toggle
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('This is a trial'),
            subtitle: const Text('Track when your trial ends'),
            value: _isTrial,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() {
                _isTrial = value;
                if (value && _trialEndDate == null) {
                  _trialEndDate = DateTime.now().add(const Duration(days: 7));
                }
              });
            },
          ),

          if (_isTrial) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.hourglass_bottom),
              title: const Text('Trial End Date'),
              subtitle: Text(
                _trialEndDate != null
                    ? DateFormat('MMM dd, yyyy').format(_trialEndDate!)
                    : 'Select date',
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _trialEndDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  setState(() => _trialEndDate = date);
                }
              },
            ),
            const Divider(),
          ],

          // Auto-renew toggle
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Auto-renews'),
            subtitle: const Text('Subscription renews automatically'),
            value: _autoRenew,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => _autoRenew = value);
            },
          ),

          // Color picker
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _colorHex != null
                    ? _parseColor(_colorHex!)
                    : theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            title: const Text('Color'),
            subtitle: const Text('Choose a color for this subscription'),
            onTap: () => _showColorPicker(context),
          ),
          const Divider(),

          // Description
          TextFormField(
            controller: _descriptionController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              hintText: 'Add a note about this subscription',
              prefixIcon: Icon(Icons.description_outlined),
            ),
          ),
          const SizedBox(height: 16),

          // Notes
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes (optional)',
              hintText: 'Any additional notes',
              prefixIcon: Icon(Icons.note_outlined),
            ),
          ),
          const SizedBox(height: 16),

          // Tags
          _buildTagsSection(context),

          const SizedBox(height: 24),

          // Reminder settings
          _buildReminderSection(context),

          const SizedBox(height: 32),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: _saveSubscription,
              child: Text(
                _isEditing ? 'Update Subscription' : 'Add Subscription',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._tags.map(
              (tag) => Chip(
                label: Text(tag),
                onDeleted: () {
                  setState(() => _tags.remove(tag));
                },
              ),
            ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: const Text('Add Tag'),
              onPressed: () => _showAddTagDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReminderSection(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_outlined,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Reminders',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Remind me before:',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [1, 2, 3, 5, 7].map((days) {
              final isSelected = _reminderDays.contains(days);
              return FilterChip(
                label: Text('$days day${days == 1 ? '' : 's'}'),
                selected: isSelected,
                onSelected: (selected) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    if (selected) {
                      _reminderDays.add(days);
                    } else {
                      _reminderDays.remove(days);
                    }
                    _reminderDays.sort((a, b) => b.compareTo(a));
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    final colors = [
      '#E50914', // Netflix red
      '#1DB954', // Spotify green
      '#FF6F00', // Amazon orange
      '#5865F2', // Discord purple
      '#00BFA6', // Teal
      '#7C4DFF', // Deep purple
      '#FF6B35', // Orange
      '#2196F3', // Blue
      '#E91E63', // Pink
      '#607D8B', // Blue grey
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose Color', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors.map((hex) {
                final color = _parseColor(hex);
                final isSelected = _colorHex == hex;
                return GestureDetector(
                  onTap: () {
                    setState(() => _colorHex = hex);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showAddTagDialog(BuildContext context) {
    _tagController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: _tagController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter tag name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final tag = _tagController.text.trim();
              if (tag.isNotEmpty && !_tags.contains(tag)) {
                setState(() => _tags.add(tag));
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveSubscription() async {
    if (!_formKey.currentState!.validate()) return;

    HapticFeedback.mediumImpact();

    final subscription = SubscriptionModel(
      id: _isEditing
          ? widget.editSubscription!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      amount: double.parse(_amountController.text),
      currencyCode: 'INR',
      recurrenceType: _recurrenceType,
      startDate: _startDate,
      nextBillingDate: _nextBillingDate ?? _startDate,
      status: _isTrial ? SubscriptionStatus.trial : SubscriptionStatus.active,
      category: _category,
      paymentMethod: _paymentMethod,
      colorHex: _colorHex,
      isTrial: _isTrial,
      trialEndDate: _trialEndDate,
      tags: _tags,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      autoRenew: _autoRenew,
      notificationPreference: NotificationPreference(
        enabled: _reminderDays.isNotEmpty,
        daysBefore: _reminderDays,
      ),
    );

    if (_isEditing) {
      await _controller.updateSubscription(subscription);
      Get.back();
      Get.snackbar('Updated', '${subscription.name} has been updated');
    } else {
      await _controller.addSubscription(subscription);
      Get.back();
      Get.snackbar('Added', '${subscription.name} has been added');
    }
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return const Color(0xFF7C4DFF);
    }
  }

  SubscriptionCategory _parseCategory(String category) {
    return SubscriptionCategory.values.firstWhere(
      (c) => c.name.toLowerCase() == category.toLowerCase(),
      orElse: () => SubscriptionCategory.other,
    );
  }

  RecurrenceType _parseRecurrence(String recurrence) {
    return RecurrenceType.values.firstWhere(
      (r) => r.name.toLowerCase() == recurrence.toLowerCase(),
      orElse: () => RecurrenceType.monthly,
    );
  }

  String _getRecurrenceLabel(RecurrenceType type) {
    switch (type) {
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekly:
        return 'Weekly';
      case RecurrenceType.biWeekly:
        return 'Bi-weekly';
      case RecurrenceType.monthly:
        return 'Monthly';
      case RecurrenceType.biMonthly:
        return 'Bi-monthly';
      case RecurrenceType.quarterly:
        return 'Quarterly';
      case RecurrenceType.semiAnnual:
        return 'Semi-annual';
      case RecurrenceType.annual:
        return 'Annual';
      case RecurrenceType.custom:
        return 'Custom';
      case RecurrenceType.oneTime:
        return 'One-time';
    }
  }

  String _getCategoryLabel(SubscriptionCategory category) {
    switch (category) {
      case SubscriptionCategory.streaming:
        return 'Streaming';
      case SubscriptionCategory.music:
        return 'Music';
      case SubscriptionCategory.gaming:
        return 'Gaming';
      case SubscriptionCategory.productivity:
        return 'Productivity';
      case SubscriptionCategory.cloud:
        return 'Cloud Storage';
      case SubscriptionCategory.fitness:
        return 'Fitness';
      case SubscriptionCategory.news:
        return 'News';
      case SubscriptionCategory.education:
        return 'Education';
      case SubscriptionCategory.finance:
        return 'Finance';
      case SubscriptionCategory.shopping:
        return 'Shopping';
      case SubscriptionCategory.utilities:
        return 'Utilities';
      case SubscriptionCategory.insurance:
        return 'Insurance';
      case SubscriptionCategory.telecom:
        return 'Telecom';
      case SubscriptionCategory.food:
        return 'Food & Delivery';
      case SubscriptionCategory.software:
        return 'Software';
      case SubscriptionCategory.social:
        return 'Social';
      case SubscriptionCategory.travel:
        return 'Travel';
      case SubscriptionCategory.other:
        return 'Other';
    }
  }

  String _getPaymentMethodLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.netBanking:
        return 'Net Banking';
      case PaymentMethod.wallet:
        return 'Wallet';
      case PaymentMethod.autoPay:
        return 'Auto Pay';
      case PaymentMethod.manual:
        return 'Manual';
      case PaymentMethod.other:
        return 'Other';
    }
  }
}
