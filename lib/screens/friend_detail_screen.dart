// lib/screens/friend_detail_screen.dart
import 'package:flutter/material.dart';
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

class _FriendDetailScreenState extends State<FriendDetailScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            LucideIcons.chevronLeft,
                            color: Colors.white,
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
                        IconButton(
                          onPressed: () => _showFriendOptions(),
                          icon: const Icon(
                            LucideIcons.settings,
                            color: Colors.white,
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
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.balance < 0 ? '-' : ''}\${widget.balance.abs().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: LucideIcons.dollarSign,
                            label: 'Proceed to payment',
                            onTap: () => _proceedToPayment(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            icon: LucideIcons.send,
                            label: 'Send reminder',
                            onTap: () => _sendReminder(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            icon: LucideIcons.share2,
                            label: 'Share payment',
                            onTap: () => _sharePayment(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Transactions Section
            Expanded(
              child: Container(
                color: AppColors.lightGray,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transactions Header
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
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
                              border: Border.all(color: AppColors.surfaceGray),
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
                    ),

                    // Transactions List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: mockTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = mockTransactions[index];
                          return _buildTransactionItem(transaction);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
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
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    return GestureDetector(
      onTap: () => _navigateToExpenseDetail(transaction),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
          createdDate: DateTime.parse(
            '2024-03-11',
          ), // Replace with transaction['date'] if dynamic parsing needed
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
      leading: Icon(icon, color: AppColors.primaryText),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: AppColors.primaryText),
      ),
      trailing: const Icon(
        LucideIcons.chevronRight,
        color: AppColors.secondaryText,
        size: 16,
      ),
      onTap: () => Navigator.pop(context),
    );
  }

  void _proceedToPayment() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Proceeding to payment...')));
  }

  void _sendReminder() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Reminder sent!')));
  }

  void _sharePayment() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Sharing payment details...')));
  }
}
