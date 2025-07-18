// lib/screens/dashboard_screen.dart (Updated with theme support)
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/utils/constants/colors.dart';
import 'friend_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Mock data - replace with real data from your state management
  final List<Map<String, dynamic>> mockFriends = [
    {
      'name': 'Peter',
      'amount': -54.68,
      'date': '01 March 2022',
      'avatar': 'P',
      'color': Colors.blue,
      'id': '1',
    },
    {
      'name': 'Victor',
      'amount': 260.68,
      'date': '10 March 2022',
      'avatar': 'V',
      'color': Colors.green,
      'id': '2',
    },
    {
      'name': 'Camila',
      'amount': -13.20,
      'date': '15 March 2022',
      'avatar': 'C',
      'color': Colors.purple,
      'id': '3',
    },
    {
      'name': 'Alex',
      'amount': 15.99,
      'date': '18 March 2022',
      'avatar': 'A',
      'color': Colors.orange,
      'id': '4',
    },
    {
      'name': 'Arthur',
      'amount': -1.15,
      'date': '24 March 2022',
      'avatar': 'A',
      'color': Colors.red,
      'id': '5',
    },
    {
      'name': 'Paula',
      'amount': -95.71,
      'date': '25 March 2022',
      'avatar': 'P',
      'color': Colors.teal,
      'id': '6',
    },
  ];

  double get totalBalance {
    return mockFriends.fold(0.0, (sum, friend) => sum + friend['amount']);
  }

  double get totalOwed {
    return mockFriends
        .where((friend) => friend['amount'] < 0)
        .fold(0.0, (sum, friend) => sum + friend['amount'].abs());
  }

  double get totalOwing {
    return mockFriends
        .where((friend) => friend['amount'] > 0)
        .fold(0.0, (sum, friend) => sum + friend['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getPrimaryTextColor(context),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the plus button
                ],
              ),
            ),

            // Balance Summary Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.getCardColor(context),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.getShadowLight(context),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.getSecondaryTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${totalBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: totalBalance >= 0
                          ? AppColors.positiveGreen
                          : AppColors.negativeRed,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Overall',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.getSecondaryTextColor(context),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${totalBalance.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: totalBalance >= 0
                                    ? AppColors.positiveGreen
                                    : AppColors.negativeRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'I owe',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.getSecondaryTextColor(context),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${totalOwed.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.negativeRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Owes me',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.getSecondaryTextColor(context),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${totalOwing.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.positiveGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Friends List
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: mockFriends.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: mockFriends.length,
                        itemBuilder: (context, index) {
                          final friend = mockFriends[index];
                          return _buildFriendItem(friend);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendItem(Map<String, dynamic> friend) {
    return GestureDetector(
      onTap: () => _navigateToFriendDetail(friend),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.getCardColor(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.getShadowLight(context),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: friend['color'],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  friend['avatar'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Friend info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getPrimaryTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    friend['date'],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.getSecondaryTextColor(context),
                    ),
                  ),
                ],
              ),
            ),

            // Amount and arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  friend['amount'] < 0 ? 'YOU OWE' : 'OWES YOU',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: friend['amount'] < 0
                        ? AppColors.negativeRed
                        : AppColors.positiveGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$${friend['amount'].abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: friend['amount'] < 0
                            ? AppColors.negativeRed
                            : AppColors.positiveGreen,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: AppColors.getSecondaryTextColor(context),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToFriendDetail(Map<String, dynamic> friend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendDetailScreen(
          friendName: friend['name'],
          balance: friend['amount'].toDouble(),
          friendId: friend['id'],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.getSurfaceColor(context),
            borderRadius: BorderRadius.circular(60),
          ),
          child: Icon(
            LucideIcons.users,
            size: 48,
            color: AppColors.getSecondaryTextColor(context),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'No friends found',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.getPrimaryTextColor(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add friends to start splitting expenses',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.getSecondaryTextColor(context),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryTeal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Add friend to splitwise'),
        ),
      ],
    );
  }
}
