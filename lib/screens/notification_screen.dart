// lib/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/utils/constants/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Payments',
    'Reminders',
    'Updates',
    'Social',
  ];

  // Fake notification data
  final List<Map<String, dynamic>> _allNotifications = [
    {
      'id': '1',
      'type': 'payment_received',
      'category': 'Payments',
      'title': 'Payment Received',
      'message': 'Peter Clarkson paid you \$15.00 for Pizza Night',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
      'isRead': false,
      'avatar': 'P',
      'avatarColor': Color(0xFF4F46E5),
      'amount': 15.00,
      'isPositive': true,
      'actionType': 'view_expense',
    },
    {
      'id': '2',
      'type': 'reminder_sent',
      'category': 'Reminders',
      'title': 'Reminder Sent',
      'message': 'You sent a payment reminder to Victor for Movie Tickets',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': false,
      'avatar': 'V',
      'avatarColor': Color(0xFF059669),
      'amount': 22.50,
      'isPositive': false,
      'actionType': 'view_expense',
    },
    {
      'id': '3',
      'type': 'expense_added',
      'category': 'Updates',
      'title': 'New Expense Added',
      'message': 'Camila added "Grocery Shopping" expense for \$89.45',
      'time': DateTime.now().subtract(const Duration(hours: 4)),
      'isRead': true,
      'avatar': 'C',
      'avatarColor': Color(0xFFDC2626),
      'amount': 89.45,
      'isPositive': false,
      'actionType': 'view_expense',
    },
    {
      'id': '4',
      'type': 'payment_request',
      'category': 'Payments',
      'title': 'Payment Request',
      'message': 'Alex is requesting \$45.00 for Uber rides',
      'time': DateTime.now().subtract(const Duration(hours: 6)),
      'isRead': true,
      'avatar': 'A',
      'avatarColor': Color(0xFFF59E0B),
      'amount': 45.00,
      'isPositive': false,
      'actionType': 'pay_now',
    },
    {
      'id': '5',
      'type': 'friend_joined',
      'category': 'Social',
      'title': 'Friend Joined YOweMe',
      'message':
          'Sarah Martinez joined YOweMe and wants to split expenses with you',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'avatar': 'S',
      'avatarColor': Color(0xFF8B5CF6),
      'actionType': 'add_friend',
    },
    {
      'id': '6',
      'type': 'weekly_summary',
      'category': 'Updates',
      'title': 'Weekly Summary',
      'message':
          'You spent \$127.50 this week and saved \$23.00 compared to last week',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'actionType': 'view_summary',
    },
    {
      'id': '7',
      'type': 'settlement_complete',
      'category': 'Payments',
      'title': 'Settlement Complete',
      'message': 'All payments for "Weekend Trip" have been settled',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
      'actionType': 'view_expense',
    },
    {
      'id': '8',
      'type': 'reminder_received',
      'category': 'Reminders',
      'title': 'Payment Reminder',
      'message': 'Paula sent you a reminder for Restaurant Bill (\$32.00)',
      'time': DateTime.now().subtract(const Duration(days: 3)),
      'isRead': true,
      'avatar': 'P',
      'avatarColor': Color(0xFF06B6D4),
      'amount': 32.00,
      'isPositive': false,
      'actionType': 'pay_now',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'All') {
      return _allNotifications;
    }
    return _allNotifications
        .where((notification) => notification['category'] == _selectedFilter)
        .toList();
  }

  int get _unreadCount {
    return _allNotifications
        .where((notification) => !notification['isRead'])
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  _buildFilterTabs(),
                  const SizedBox(height: 16),
                  _buildNotificationsList(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: null, // No back arrow
      title: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(width: 48), // Balance the action button
          ],
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: _markAllAsRead,
            icon: const Icon(LucideIcons.checkCheck, size: 24),
            color: AppColors.primaryTeal,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = filter == _selectedFilter;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
                HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryTeal : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.primaryText,
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    final notifications = _filteredNotifications;

    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: notifications.asMap().entries.map((entry) {
          final index = entry.key;
          final notification = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == notifications.length - 1 ? 0 : 16,
            ),
            child: _buildNotificationItem(notification),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        border: !notification['isRead']
            ? Border.all(
                color: AppColors.primaryTeal.withOpacity(0.3),
                width: 1.5,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _handleNotificationTap(notification),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNotificationIcon(notification),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: notification['isRead']
                                        ? FontWeight.w600
                                        : FontWeight.bold,
                                    color: AppColors.primaryText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                _formatTime(notification['time']),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            notification['message'],
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.secondaryText,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (notification.containsKey('amount'))
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: _buildAmountChip(notification),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (notification['actionType'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildActionButtons(notification),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(Map<String, dynamic> notification) {
    IconData icon;
    Color color;

    switch (notification['type']) {
      case 'payment_received':
        icon = LucideIcons.creditCard;
        color = AppColors.success;
        break;
      case 'payment_request':
        icon = LucideIcons.clock;
        color = AppColors.warning;
        break;
      case 'reminder_sent':
      case 'reminder_received':
        icon = LucideIcons.bell;
        color = AppColors.info;
        break;
      case 'expense_added':
        icon = LucideIcons.plus;
        color = AppColors.primaryTeal;
        break;
      case 'friend_joined':
        icon = LucideIcons.userPlus;
        color = AppColors.success;
        break;
      case 'settlement_complete':
        icon = LucideIcons.checkCircle;
        color = AppColors.success;
        break;
      case 'weekly_summary':
        icon = LucideIcons.barChart3;
        color = AppColors.info;
        break;
      default:
        icon = LucideIcons.bell;
        color = AppColors.primaryTeal;
    }

    Widget iconWidget = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Icon(icon, color: color, size: 28),
    );

    // If notification has an avatar, show it with a status indicator
    if (notification.containsKey('avatar')) {
      iconWidget = Stack(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  notification['avatarColor'],
                  notification['avatarColor'].withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: Text(
                notification['avatar'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: Icon(icon, color: Colors.white, size: 12),
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        iconWidget,
        if (!notification['isRead'])
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.primaryTeal,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAmountChip(Map<String, dynamic> notification) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: notification['isPositive']
            ? AppColors.success.withOpacity(0.15)
            : AppColors.warning.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            notification['isPositive']
                ? LucideIcons.trendingUp
                : LucideIcons.trendingDown,
            size: 16,
            color: notification['isPositive']
                ? AppColors.success
                : AppColors.warning,
          ),
          const SizedBox(width: 8),
          Text(
            '\$${notification['amount'].toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: notification['isPositive']
                  ? AppColors.success
                  : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> notification) {
    return Row(
      children: [
        if (notification['actionType'] == 'pay_now') ...[
          Expanded(
            child: ElevatedButton(
              onPressed: () => _handlePayNow(notification),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Pay Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _handleViewDetails(notification),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryTeal,
                side: BorderSide(color: AppColors.primaryTeal, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ] else if (notification['actionType'] == 'add_friend') ...[
          Expanded(
            child: ElevatedButton(
              onPressed: () => _handleAddFriend(notification),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Add Friend',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ] else ...[
          Expanded(
            child: OutlinedButton(
              onPressed: () => _handleViewDetails(notification),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryTeal,
                side: BorderSide(
                  color: AppColors.primaryTeal.withOpacity(0.5),
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.surfaceGray,
              borderRadius: BorderRadius.circular(70),
            ),
            child: Icon(
              LucideIcons.bell,
              size: 56,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'No ${_selectedFilter.toLowerCase()} notifications',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You\'re all caught up! Check back later for updates.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.secondaryText,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('d MMM yyyy').format(time);
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        notification['isRead'] = true;
      }
    });

    HapticFeedback.vibrate();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    setState(() {
      notification['isRead'] = true;
    });
    HapticFeedback.lightImpact();
  }

  void _handlePayNow(Map<String, dynamic> notification) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Processing payment of \$${notification['amount'].toStringAsFixed(2)}...',
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleViewDetails(Map<String, dynamic> notification) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening expense details...'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleAddFriend(Map<String, dynamic> notification) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Adding friend...'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
