import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app/controllers/subscription_controller.dart';
import '../widgets/modern_ui_components.dart';

/// Family Sharing Screen - Modern Redesign
class FamilySharingScreen extends StatefulWidget {
  const FamilySharingScreen({super.key});

  @override
  State<FamilySharingScreen> createState() => _FamilySharingScreenState();
}

class _FamilySharingScreenState extends State<FamilySharingScreen> {
  final SubscriptionController _controller = Get.find();

  // Sample family members
  final List<_FamilyMember> _members = [
    _FamilyMember(
      name: 'You',
      email: 'you@email.com',
      avatar: 'Y',
      isOwner: true,
      subscriptionCount: 8,
    ),
    _FamilyMember(
      name: 'Sarah',
      email: 'sarah@email.com',
      avatar: 'S',
      isOwner: false,
      subscriptionCount: 3,
    ),
    _FamilyMember(
      name: 'Mike',
      email: 'mike@email.com',
      avatar: 'M',
      isOwner: false,
      subscriptionCount: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildSharingStats(context)),
          SliverToBoxAdapter(child: _buildFamilyMembers(context)),
          SliverToBoxAdapter(child: _buildSharedSubscriptions(context)),
          SliverToBoxAdapter(child: _buildSharingSettings(context)),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _inviteMember(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Invite'),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      title: const Text(
        'Family Sharing',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => _openSettings(context),
        ),
      ],
    );
  }

  Widget _buildSharingStats(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: AccentCard(
        accentColor: AppColors.secondary,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.family_restroom_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Family Plan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '3 members • 5 shared subscriptions',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _SharingStat(
                    label: 'Total Savings',
                    value: '₹2,400',
                    subValue: '/month',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _SharingStat(
                    label: 'Shared',
                    value: '5',
                    subValue: 'subscriptions',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: _SharingStat(
                    label: 'Members',
                    value: '3',
                    subValue: 'of 6',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyMembers(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ModernSectionHeader(
          title: 'Family Members',
          actionText: 'Manage',
          onAction: () => _manageMembers(context),
        ),
        ModernCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: _members.map((member) {
              final isLast = member == _members.last;
              return Column(
                children: [
                  _MemberTile(
                    member: member,
                    onTap: () => _viewMember(context, member),
                  ),
                  if (!isLast) const ModernDivider(),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSharedSubscriptions(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(
          title: 'Shared Subscriptions',
          subtitle: 'Active family plans',
        ),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _SharedSubscriptionCard(
                name: 'Netflix',
                members: 3,
                price: '₹649',
                color: const Color(0xFFE50914),
              ),
              _SharedSubscriptionCard(
                name: 'Spotify',
                members: 4,
                price: '₹179',
                color: const Color(0xFF1DB954),
              ),
              _SharedSubscriptionCard(
                name: 'YouTube',
                members: 3,
                price: '₹189',
                color: const Color(0xFFFF0000),
              ),
              _SharedSubscriptionCard(
                name: 'iCloud',
                members: 5,
                price: '₹75',
                color: const Color(0xFF3395FF),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSharingSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernSectionHeader(title: 'Settings'),
        ModernCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              ActionTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Get alerts for family activity',
                onTap: () {},
              ),
              const ModernDivider(),
              ActionTile(
                icon: Icons.lock_outline_rounded,
                title: 'Permissions',
                subtitle: 'Control what members can see',
                onTap: () {},
              ),
              const ModernDivider(),
              ActionTile(
                icon: Icons.sync_rounded,
                title: 'Sync Settings',
                subtitle: 'Auto-sync subscriptions',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _inviteMember(BuildContext context) {
    HapticFeedback.mediumImpact();
    Get.snackbar(
      'Invite Member',
      'Send an invitation to join your family plan',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _openSettings(BuildContext context) {
    HapticFeedback.lightImpact();
  }

  void _manageMembers(BuildContext context) {
    HapticFeedback.lightImpact();
  }

  void _viewMember(BuildContext context, _FamilyMember member) {
    HapticFeedback.lightImpact();
    Get.snackbar(
      member.name,
      'Sharing ${member.subscriptionCount} subscriptions',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════════════════

class _FamilyMember {
  final String name;
  final String email;
  final String avatar;
  final bool isOwner;
  final int subscriptionCount;

  const _FamilyMember({
    required this.name,
    required this.email,
    required this.avatar,
    required this.isOwner,
    required this.subscriptionCount,
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

class _SharingStat extends StatelessWidget {
  final String label;
  final String value;
  final String subValue;

  const _SharingStat({
    required this.label,
    required this.value,
    required this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: ' $subValue',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MemberTile extends StatelessWidget {
  final _FamilyMember member;
  final VoidCallback onTap;

  const _MemberTile({required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: member.isOwner
                  ? AppColors.primary
                  : AppColors.slate400,
              child: Text(
                member.avatar,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        member.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (member.isOwner) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Owner',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${member.subscriptionCount} shared subscriptions',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _SharedSubscriptionCard extends StatelessWidget {
  final String name;
  final int members;
  final String price;
  final Color color;

  const _SharedSubscriptionCard({
    required this.name,
    required this.members,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : AppColors.slate200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$members',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '$price/mo',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
