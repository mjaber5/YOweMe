// lib/screens/friend_detail_screen.dart
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
    {
      'id': '#002',
      'title': 'Groceries',
      'description': 'Weekly shopping at Walmart',
      'date': '8 March 2024',
      'amount': 862.08,
      'icon': LucideIcons.shoppingBag,
      'color': Colors.green,
      'category': 'Groceries',
      'participants': ['You', 'Peter'],
      'paidBy': 'You',
      'status': 'Paid',
    },
    {
      'id': '#003',
      'title': 'Movie Night',
      'description': 'Cinema tickets and snacks',
      'date': '15 Feb 2024',
      'amount': -15.99,
      'icon': LucideIcons.film,
      'color': Colors.purple,
      'category': 'Entertainment',
      'participants': ['You', 'Peter', 'Camila'],
      'paidBy': 'Peter',
      'status': 'Paid',
    },
    {
      'id': '#004',
      'title': 'Uber Ride',
      'description': 'Shared ride to airport',
      'date': '10 Jan 2024',
      'amount': -20.00,
      'icon': LucideIcons.car,
      'color': Colors.black,
      'category': 'Transportation',
      'participants': ['You', 'Peter'],
      'paidBy': 'Peter',
      'status': 'Paid',
    },
    {
      'id': '#005',
      'title': 'Birthday Gift',
      'description': 'Present for Andy\'s birthday',
      'date': '5 Jan 2024',
      'amount': -64.30,
      'icon': LucideIcons.gift,
      'color': Colors.pink,
      'category': 'Shopping',
      'participants': ['You', 'Peter', 'Alex'],
      'paidBy': 'Peter',
      'status': 'Paid',
    },
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

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
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
    return Scaffold(
      backgroundColor: AppColors.lightGray,
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
                      // Header with gradient background
                      Container(
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                        ),
                        child: Column(
                          children: [
                            // Navigation and settings
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        LucideIcons.chevronLeft,
                                        color: AppColors.primaryText,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget.friendName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      onPressed: () => _showFriendOptions(),
                                      icon: const Icon(
                                        LucideIcons.settings,
                                        color: AppColors.primaryText,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Balance Display
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 24,
                              ),
                              child: Column(
                                children: [
                                  // Profile Avatar
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: const Icon(
                                      LucideIcons.user,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Friend Name and Email
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

                                  // Total Balance
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

                      // Transactions Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Transactions Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Transactions',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.surfaceGray,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'All',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primaryText,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        LucideIcons.chevronDown,
                                        size: 16,
                                        color: AppColors.secondaryText,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Transactions List
                            ...mockTransactions.asMap().entries.map((entry) {
                              final index = entry.key;
                              final transaction = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == mockTransactions.length - 1
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
            // Positioned(
            //   bottom: 20,
            //   left: 20,
            //   right: 20,
            //   child: _buildActionButtons(),
            // ),
          ],
        ),
      ),
    );
  }

  // Widget _buildActionButtons() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: _buildActionButton(
  //           icon: LucideIcons.dollarSign,
  //           label: 'Proceed to payment',
  //           onTap: () => _proceedToPayment(),
  //         ),
  //       ),
  //       const SizedBox(width: 12),
  //       Expanded(
  //         child: _buildActionButton(
  //           icon: LucideIcons.send,
  //           label: 'Send reminder',
  //           onTap: () => _sendReminder(),
  //         ),
  //       ),
  //       const SizedBox(width: 12),
  //       Expanded(
  //         child: _buildActionButton(
  //           icon: LucideIcons.share2,
  //           label: 'Share payment',
  //           onTap: () => _sharePayment(),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryTeal,
            AppColors.primaryTeal.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryTeal.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            HapticFeedback.mediumImpact();
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    return GestureDetector(
      onTap: () => _navigateToExpenseDetail(transaction),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Transaction Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: transaction['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                transaction['icon'],
                size: 20,
                color: transaction['color'],
              ),
            ),
            const SizedBox(width: 16),

            // Transaction Info
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

            // Amount and Arrow
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
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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

  // void _proceedToPayment() {
  //   HapticFeedback.selectionClick();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: const Text('Proceeding to payment...'),
  //       backgroundColor: AppColors.success,
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     ),
  //   );
  // }

  // void _sendReminder() {
  //   HapticFeedback.selectionClick();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: const Text('Reminder sent!'),
  //       backgroundColor: AppColors.success,
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     ),
  //   );
  // }

  // void _sharePayment() {
  //   HapticFeedback.selectionClick();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: const Text('Sharing payment details...'),
  //       backgroundColor: AppColors.info,
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     ),
  //   );
  // }
}
