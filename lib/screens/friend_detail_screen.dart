import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:yoweme/model/trasnactions.dart';
import '../core/utils/constants/colors.dart';
import 'expense_detail_screen.dart';

class FriendDetailScreen extends StatefulWidget {
  final String friendName;
  final double balance;
  final String friendId;
  final List<Transaction> transactions;

  const FriendDetailScreen({
    super.key,
    required this.friendName,
    required this.balance,
    required this.friendId,
    required this.transactions,
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

  String _selectedFilter = 'All';
  List<String> _filterOptions = [
    'All',
    'Credit',
    'Debit',
    'Pending',
    'Settled',
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

  // Filter transactions based on selected filter
  List<Transaction> _getFilteredTransactions() {
    if (_selectedFilter == 'All') return widget.transactions;

    return widget.transactions.where((transaction) {
      switch (_selectedFilter) {
        case 'Credit':
          return transaction.creditDebitIndicator.toLowerCase() == 'credit';
        case 'Debit':
          return transaction.creditDebitIndicator.toLowerCase() == 'debit';
        case 'Pending':
          return transaction.status.toLowerCase() == 'pending';
        case 'Settled':
          return transaction.status.toLowerCase() == 'settled';
        default:
          return true;
      }
    }).toList();
  }

  // Enhanced icon mapping with more categories
  IconData _getTransactionIcon(String description) {
    description = description.toLowerCase();

    // Food & Dining
    if (description.contains('food') ||
        description.contains('restaurant') ||
        description.contains('pizza') ||
        description.contains('dinner') ||
        description.contains('lunch') ||
        description.contains('breakfast')) {
      return LucideIcons.utensils;
    }
    // Coffee & Drinks
    else if (description.contains('coffee') ||
        description.contains('drink') ||
        description.contains('starbucks') ||
        description.contains('cafe')) {
      return LucideIcons.coffee;
    }
    // Transportation
    else if (description.contains('gas') ||
        description.contains('fuel') ||
        description.contains('transport') ||
        description.contains('taxi') ||
        description.contains('uber') ||
        description.contains('bus')) {
      return LucideIcons.car;
    }
    // Shopping
    else if (description.contains('shopping') ||
        description.contains('store') ||
        description.contains('market') ||
        description.contains('mall')) {
      return LucideIcons.shoppingBag;
    }
    // Grocery
    else if (description.contains('grocery') ||
        description.contains('supermarket') ||
        description.contains('carrefour') ||
        description.contains('walmart')) {
      return LucideIcons.shoppingCart;
    }
    // Entertainment
    else if (description.contains('movie') ||
        description.contains('cinema') ||
        description.contains('entertainment') ||
        description.contains('game')) {
      return LucideIcons.film;
    }
    // Bills & Utilities
    else if (description.contains('bill') ||
        description.contains('utility') ||
        description.contains('electric') ||
        description.contains('water')) {
      return LucideIcons.fileText;
    }
    // Money Transfer/Bonus
    else if (description.contains('bonus') ||
        description.contains('salary') ||
        description.contains('transfer') ||
        description.contains('payment')) {
      return LucideIcons.banknote;
    }
    // Default
    else {
      return LucideIcons.receipt;
    }
  }

  // Enhanced color mapping
  Color _getTransactionColor(String description) {
    description = description.toLowerCase();

    if (description.contains('food') || description.contains('restaurant')) {
      return Colors.orange;
    } else if (description.contains('coffee') ||
        description.contains('drink')) {
      return Colors.brown;
    } else if (description.contains('gas') ||
        description.contains('transport')) {
      return Colors.blue;
    } else if (description.contains('shopping') ||
        description.contains('store')) {
      return Colors.purple;
    } else if (description.contains('grocery') ||
        description.contains('supermarket')) {
      return Colors.green;
    } else if (description.contains('movie') ||
        description.contains('entertainment')) {
      return Colors.red;
    } else if (description.contains('bonus') ||
        description.contains('salary')) {
      return Colors.teal;
    } else if (description.contains('bill') ||
        description.contains('utility')) {
      return Colors.indigo;
    } else {
      return Colors.grey;
    }
  }

  // Helper method to format date
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final filteredTransactions = _getFilteredTransactions();

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
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: const Icon(
                                      LucideIcons.arrowLeft,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const Icon(
                                    LucideIcons.moreVertical,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
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
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.friendName,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Transactions Amount: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${widget.balance < 0 ? '-' : ''}JOD ${widget.balance.abs().toStringAsFixed(2)}',
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

                      // Transaction Stats
                      if (widget.transactions.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '${widget.transactions.length}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryTeal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '${widget.transactions.where((t) => t.creditDebitIndicator.toLowerCase() == 'credit').length}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.positiveGreen,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Credits',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '${widget.transactions.where((t) => t.creditDebitIndicator.toLowerCase() == 'debit').length}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.negativeRed,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Debits',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.secondaryText,
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
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Transactions',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _showFilterOptions,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.surfaceGray,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          _selectedFilter,
                                          style: const TextStyle(fontSize: 14),
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
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Display filtered transactions or empty state
                            filteredTransactions.isEmpty
                                ? _buildEmptyState()
                                : Column(
                                    children: filteredTransactions
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          final index = entry.key;
                                          final transaction = entry.value;
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom:
                                                  index ==
                                                      filteredTransactions
                                                              .length -
                                                          1
                                                  ? 0
                                                  : 12,
                                            ),
                                            child: _buildTransactionItem(
                                              transaction,
                                            ),
                                          );
                                        })
                                        .toList(),
                                  ),
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

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filter Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              const SizedBox(height: 20),
              ..._filterOptions.map((option) {
                return ListTile(
                  title: Text(option),
                  trailing: _selectedFilter == option
                      ? const Icon(
                          LucideIcons.check,
                          color: AppColors.primaryTeal,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedFilter = option;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            LucideIcons.receipt,
            size: 64,
            color: AppColors.secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _selectedFilter == 'All'
                ? 'No transactions yet'
                : 'No $_selectedFilter transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter == 'All'
                ? 'Start splitting expenses with ${widget.friendName}'
                : 'Try changing the filter to see more transactions',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.secondaryText.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isDebit = transaction.creditDebitIndicator.toLowerCase() == 'debit';
    final displayAmount = isDebit
        ? -transaction.amount.value
        : transaction.amount.value;

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
                color: _getTransactionColor(
                  transaction.description,
                ).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _getTransactionIcon(transaction.description),
                size: 20,
                color: _getTransactionColor(transaction.description),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Fixed: Changed from Row to Column to prevent overflow
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(transaction.transactionDate),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      if (transaction.transactionChannel != null)
                        Text(
                          transaction.transactionChannel!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.secondaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  if (transaction.status.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: transaction.status.toLowerCase() == 'pending'
                              ? Colors.orange.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          transaction.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: transaction.status.toLowerCase() == 'pending'
                                ? Colors.orange
                                : Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${displayAmount < 0 ? '-' : '+'}${transaction.amount.currency} ${displayAmount.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: displayAmount < 0
                        ? AppColors.negativeRed
                        : AppColors.positiveGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: AppColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToExpenseDetail(Transaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseDetailScreen(
          expenseId: transaction.transactionId,
          description: transaction.description,
          amount: transaction.amount.value,
          paidBy: transaction.creditorName ?? widget.friendName,
          participants: [
            transaction.debtorName ?? 'Unknown',
            transaction.creditorName ?? widget.friendName,
          ],
          category: 'General',
          createdDate: transaction.transactionDate,
          status: transaction.status,
        ),
      ),
    );
  }
}
