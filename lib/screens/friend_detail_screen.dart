import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/utils/constants/colors.dart';
import 'expense_detail_screen.dart';

class FriendDetailScreen extends StatefulWidget {
  final String friendName;
  final double balance;
  final String friendId;

  const FriendDetailScreen({
    super.key,
    required this.friendName,
    required this.balance,
    required this.friendId,
  });

  @override
  State<FriendDetailScreen> createState() => _FriendDetailScreenState();
}

class _FriendDetailScreenState extends State<FriendDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> mockTransactions = [
    {
      'id': '#001',
      'title': 'Pizza Night',
      'description': 'Dinner at Tony\'s Pizza',
      'date': '11 March 2024',
      'amount': -19.80,
      'icon': LucideIcons.utensils,
      'color': Colors.orange,
      'category': 'Food & Dining',
      'participants': ['You', 'Peter', 'Victor'],
      'paidBy': 'Peter',
      'status': 'Pending',
    },
    // ... باقي المعاملات
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      // Header
                      Container(
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _circleIconButton(
                                    icon: LucideIcons.chevronLeft,
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Text(
                                    widget.friendName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  _circleIconButton(
                                    icon: LucideIcons.settings,
                                    onPressed: _showFriendOptions,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 24),
                              child: Column(
                                children: [
                                  const CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.white24,
                                    child: Icon(
                                      LucideIcons.user,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    widget.friendName,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'peterclarkson@example.com',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Total:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${widget.balance < 0 ? '-' : ''}\$${widget.balance.abs().toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Transactions
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20, 24, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Transactions',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.surfaceGray,
                                    ),
                                  ),
                                  child: Row(
                                    children: const [
                                      Text(
                                        'All',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        LucideIcons.chevronDown,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...mockTransactions.asMap().entries.map((entry) {
                              final index = entry.key;
                              final transaction = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index ==
                                          mockTransactions.length - 1
                                      ? 0
                                      : 12,
                                ),
                                child: _buildTransactionItem(transaction),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIconButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.primaryText, size: 20),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    return GestureDetector(
      onTap: () => _navigateToExpenseDetail(transaction),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: transaction['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(transaction['icon'],
                  size: 20, color: transaction['color']),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction['date'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${transaction['amount'] < 0 ? '-' : ''}\$${transaction['amount'].abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: transaction['amount'] < 0
                        ? AppColors.negativeRed
                        : AppColors.positiveGreen,
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: AppColors.secondaryText,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToExpenseDetail(Map<String, dynamic> transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseDetailScreen(
          expenseId: transaction['id'],
          description: transaction['description'],
          amount: transaction['amount'].abs().toDouble(),
          paidBy: transaction['paidBy'],
          participants: List<String>.from(transaction['participants']),
          category: transaction['category'],
          createdDate: DateTime.parse('2024-03-11'),
          status: transaction['status'],
        ),
      ),
    );
  }

  void _showFriendOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.secondaryText.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Friend Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            _buildOptionItem('Manage relationship', LucideIcons.users),
            _buildOptionItem('Remove from contact list', LucideIcons.userMinus),
            _buildOptionItem('Block user', LucideIcons.userX),
            _buildOptionItem('Report user', LucideIcons.flag),
            const SizedBox(height: 16),
            _buildOptionItem('Shared groups', LucideIcons.users),
            _buildOptionItem('Adventurers', LucideIcons.mountain),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryTeal),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: AppColors.primaryText),
      ),
      trailing: const Icon(
        LucideIcons.chevronRight,
        color: AppColors.secondaryText,
        size: 16,
      ),
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pop(context);
      },
    );
  }
}
