import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

/// Family & Team Sharing Screen for Managing Shared Subscriptions
class FamilySharingScreen extends StatefulWidget {
  const FamilySharingScreen({super.key});

  @override
  State<FamilySharingScreen> createState() => _FamilySharingScreenState();
}

class _FamilySharingScreenState extends State<FamilySharingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A0F) : Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildFamilyPlanOverview(context)),
          SliverToBoxAdapter(child: _buildTabBar(context)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 600,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMembersTab(context),
                  _buildSharedSubscriptionsTab(context),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showInviteSheet(context),
        backgroundColor: const Color(0xFF7C4DFF),
        icon: const Icon(Icons.person_add),
        label: const Text('Invite Member'),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFFFF6B6B)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.family_restroom,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Family Sharing',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7C4DFF).withOpacity(0.3),
                const Color(0xFFFF6B6B).withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyPlanOverview(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C4DFF), Color(0xFF9C7DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C4DFF).withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: CustomPaint(
                painter: _PatternPainter(color: Colors.white.withOpacity(0.05)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Family Plan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '4 members • ₹2,499/month total',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Active',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Member avatars
                Row(
                  children: [
                    _buildMemberAvatar(
                      name: 'You',
                      isOwner: true,
                      color: const Color(0xFFFF6B6B),
                    ),
                    const SizedBox(width: 8),
                    _buildMemberAvatar(
                      name: 'Mom',
                      isOwner: false,
                      color: const Color(0xFF00BFA6),
                    ),
                    const SizedBox(width: 8),
                    _buildMemberAvatar(
                      name: 'Dad',
                      isOwner: false,
                      color: const Color(0xFFFF9500),
                    ),
                    const SizedBox(width: 8),
                    _buildMemberAvatar(
                      name: 'Sis',
                      isOwner: false,
                      color: const Color(0xFF667EEA),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Stats row
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('Saved', '₹1,240/mo'),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      _buildStat('Per Person', '₹625/mo'),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      _buildStat('Shared', '6 subs'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberAvatar({
    required String name,
    required bool isOwner,
    required Color color,
  }) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (isOwner)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.star, color: Colors.white, size: 10),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: isDark ? const Color(0xFF374151) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.hintColor,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Members'),
          Tab(text: 'Shared Subscriptions'),
        ],
      ),
    );
  }

  Widget _buildMembersTab(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final members = [
      _FamilyMember(
        name: 'You',
        email: 'you@email.com',
        role: 'Owner',
        joinedDate: 'Owner',
        color: const Color(0xFFFF6B6B),
        sharedSubscriptions: 6,
        monthlyCost: 625,
      ),
      _FamilyMember(
        name: 'Mom',
        email: 'mom@email.com',
        role: 'Member',
        joinedDate: 'Jan 2024',
        color: const Color(0xFF00BFA6),
        sharedSubscriptions: 4,
        monthlyCost: 625,
      ),
      _FamilyMember(
        name: 'Dad',
        email: 'dad@email.com',
        role: 'Member',
        joinedDate: 'Jan 2024',
        color: const Color(0xFFFF9500),
        sharedSubscriptions: 3,
        monthlyCost: 625,
      ),
      _FamilyMember(
        name: 'Sister',
        email: 'sister@email.com',
        role: 'Member',
        joinedDate: 'Feb 2024',
        color: const Color(0xFF667EEA),
        sharedSubscriptions: 5,
        monthlyCost: 625,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return _buildMemberCard(context, member);
      },
    );
  }

  Widget _buildMemberCard(BuildContext context, _FamilyMember member) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isOwner = member.role == 'Owner';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isOwner
            ? Border.all(
                color: const Color(0xFFFFD700).withOpacity(0.5),
                width: 2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isOwner
                ? const Color(0xFFFFD700).withOpacity(0.15)
                : Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: member.color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: member.color.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    member.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (isOwner)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? const Color(0xFF1F2937) : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (isOwner) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'OWNER',
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  member.email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.subscriptions,
                          color: theme.hintColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${member.sharedSubscriptions} shared',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.payments, color: theme.hintColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '₹${member.monthlyCost}/mo',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!isOwner)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: theme.hintColor),
              onSelected: (value) {
                if (value == 'remove') {
                  _removeMember(member);
                } else if (value == 'transfer') {
                  _transferOwnership(member);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'transfer',
                  child: Row(
                    children: [
                      Icon(Icons.swap_horiz, size: 20),
                      SizedBox(width: 12),
                      Text('Transfer Ownership'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text('Remove', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSharedSubscriptionsTab(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sharedSubs = [
      _SharedSubscription(
        name: 'Netflix Premium',
        icon: Icons.play_circle,
        color: const Color(0xFFE50914),
        totalCost: 649,
        perPerson: 162,
        members: 4,
        maxMembers: 5,
      ),
      _SharedSubscription(
        name: 'Spotify Family',
        icon: Icons.music_note,
        color: const Color(0xFF1DB954),
        totalCost: 179,
        perPerson: 45,
        members: 4,
        maxMembers: 6,
      ),
      _SharedSubscription(
        name: 'YouTube Premium Family',
        icon: Icons.smart_display,
        color: const Color(0xFFFF0000),
        totalCost: 189,
        perPerson: 47,
        members: 4,
        maxMembers: 6,
      ),
      _SharedSubscription(
        name: 'iCloud+ 2TB',
        icon: Icons.cloud,
        color: const Color(0xFF007AFF),
        totalCost: 749,
        perPerson: 187,
        members: 4,
        maxMembers: 6,
      ),
      _SharedSubscription(
        name: 'Microsoft 365 Family',
        icon: Icons.apps,
        color: const Color(0xFF00A4EF),
        totalCost: 549,
        perPerson: 137,
        members: 4,
        maxMembers: 6,
      ),
      _SharedSubscription(
        name: 'Disney+ Premium',
        icon: Icons.movie,
        color: const Color(0xFF0063E5),
        totalCost: 299,
        perPerson: 75,
        members: 4,
        maxMembers: 4,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sharedSubs.length,
      itemBuilder: (context, index) {
        final sub = sharedSubs[index];
        return _buildSharedSubCard(context, sub);
      },
    );
  }

  Widget _buildSharedSubCard(BuildContext context, _SharedSubscription sub) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final memberProgress = sub.members / sub.maxMembers;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: sub.color.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: sub.color,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: sub.color.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(sub.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sub.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '₹${sub.totalCost}/mo',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00BFA6).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '₹${sub.perPerson}/person',
                            style: const TextStyle(
                              color: Color(0xFF00BFA6),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: theme.hintColor),
            ],
          ),
          const SizedBox(height: 16),
          // Member slots indicator
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${sub.members}/${sub.maxMembers} members',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (sub.members < sub.maxMembers)
                    Text(
                      '${sub.maxMembers - sub.members} slots available',
                      style: TextStyle(
                        color: const Color(0xFF00BFA6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: memberProgress,
                  backgroundColor: sub.color.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation(sub.color),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showInviteSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C4DFF), Color(0xFF9C7DFF)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Invite Family Member',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Share the cost of your subscriptions with family',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter email address',
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF374151)
                      : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.back();
                        Get.snackbar(
                          'Link Copied!',
                          'Share the invite link with your family',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      icon: const Icon(Icons.link),
                      label: const Text('Copy Link'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        Get.snackbar(
                          'Invitation Sent!',
                          'We\'ve sent an invite to your family member',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFF00BFA6),
                          colorText: Colors.white,
                        );
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Send Invite'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C4DFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _removeMember(_FamilyMember member) {
    Get.snackbar(
      'Remove ${member.name}?',
      'This action cannot be undone',
      snackPosition: SnackPosition.BOTTOM,
      mainButton: TextButton(
        onPressed: () {},
        child: const Text('CONFIRM', style: TextStyle(color: Colors.red)),
      ),
    );
  }

  void _transferOwnership(_FamilyMember member) {
    Get.snackbar(
      'Transfer Ownership',
      'Make ${member.name} the new owner?',
      snackPosition: SnackPosition.BOTTOM,
      mainButton: TextButton(onPressed: () {}, child: const Text('CONFIRM')),
    );
  }
}

// Data classes
class _FamilyMember {
  final String name;
  final String email;
  final String role;
  final String joinedDate;
  final Color color;
  final int sharedSubscriptions;
  final double monthlyCost;

  const _FamilyMember({
    required this.name,
    required this.email,
    required this.role,
    required this.joinedDate,
    required this.color,
    required this.sharedSubscriptions,
    required this.monthlyCost,
  });
}

class _SharedSubscription {
  final String name;
  final IconData icon;
  final Color color;
  final double totalCost;
  final double perPerson;
  final int members;
  final int maxMembers;

  const _SharedSubscription({
    required this.name,
    required this.icon,
    required this.color,
    required this.totalCost,
    required this.perPerson,
    required this.members,
    required this.maxMembers,
  });
}

// Pattern painter
class _PatternPainter extends CustomPainter {
  final Color color;

  _PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 30.0;
    for (var i = 0.0; i < size.width + size.height; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(0, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
