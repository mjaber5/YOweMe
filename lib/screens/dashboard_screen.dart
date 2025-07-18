import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:yoweme/l10n/app_localizations.dart';
import 'package:yoweme/model/trasnactions.dart';
import 'package:yoweme/model/user.dart';
import 'package:yoweme/model/balance.dart';
import 'package:yoweme/services/account_services.dart';
import 'package:yoweme/services/balance_services.dart';
import 'package:yoweme/services/transactions_services.dart';
import '../core/utils/constants/colors.dart';
import 'friend_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Color> avatarColors = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.red,
    Colors.teal,
  ];

  // Helper function to format customer ID to display name
  String formatCustomerIdToName(String customerId) {
    // Remove prefixes and convert to readable format
    String name = customerId
        .replaceAll('IND_CUST_', 'Individual ')
        .replaceAll('CORP_CUST_', 'Corporate ')
        .replaceAll('BUS_CUST_', 'Business ');

    // Remove leading zeros and add "Customer"
    name = name.replaceAll(RegExp(r'0+'), '');
    return '$name Customer';
  }

  // Helper function to get account ID from customer ID
  String getAccountIdFromCustomerId(String customerId, int index) {
    // This maps customer IDs to account IDs (1001-1062)
    return (1001 + index).toString();
  }

  double getTotalBalance(List<Balance> balances) {
    return balances.fold(0.0, (sum, balance) => sum + balance.availableBalance);
  }

  double getTotalOwed(List<Balance> balances) {
    return balances
        .where((balance) => balance.availableBalance < 0)
        .fold(0.0, (sum, balance) => sum + balance.availableBalance.abs());
  }

  double getTotalOwing(List<Balance> balances) {
    return balances
        .where((balance) => balance.availableBalance > 0)
        .fold(0.0, (sum, balance) => sum + balance.availableBalance);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
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
                    l10n.dashboard,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getPrimaryTextColor(context),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Balance Summary Card
            FutureBuilder<List<Balance>>(
              future: BalanceService().fetchBalances(),
              builder: (context, balanceSnapshot) {
                double totalBalance = 0.0;
                double totalOwed = 0.0;
                double totalOwing = 0.0;

                if (balanceSnapshot.hasData &&
                    balanceSnapshot.data!.isNotEmpty) {
                  totalBalance = getTotalBalance(balanceSnapshot.data!);
                  totalOwed = getTotalOwed(balanceSnapshot.data!);
                  totalOwing = getTotalOwing(balanceSnapshot.data!);
                }

                return Container(
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
                        l10n.balance,
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
                                  l10n.overall,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.getSecondaryTextColor(
                                      context,
                                    ),
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
                                  l10n.iOwe,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.getSecondaryTextColor(
                                      context,
                                    ),
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
                                  l10n.owesMe,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.getSecondaryTextColor(
                                      context,
                                    ),
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
                );
              },
            ),

            const SizedBox(height: 24),

            // Accounts List
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder<List<dynamic>>(
                  future: Future.wait([
                    ApiServiceAccounts().fetchAccounts(),
                    BalanceService().fetchBalances(),
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(
                            color: AppColors.getSecondaryTextColor(context),
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data![0].isEmpty) {
                      return _buildEmptyState(l10n);
                    }

                    final accounts = snapshot.data![0] as List<Account>;
                    final balances = snapshot.data![1] as List<Balance>;

                    return ListView.builder(
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        final account = accounts[index];
                        final accountId = getAccountIdFromCustomerId(
                          account.customerId,
                          index,
                        );

                        // Find matching balance by accountId
                        final balance = balances.firstWhere(
                          (b) => b.accountId == accountId,
                          orElse: () => Balance(
                            accountId: accountId,
                            availableBalance: 0.0,
                            currency: 'USD',
                          ),
                        );

                        // Create user-friendly name from customerId
                        final displayName = formatCustomerIdToName(
                          account.customerId,
                        );

                        final friend = {
                          'name': displayName,
                          'customerId': account.customerId,
                          'accountId': accountId,
                          'amount': balance.availableBalance,
                          'date': DateFormat.yMMMd().format(
                            account.openingDate,
                          ),
                          'avatar': displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : 'U',
                          'color': avatarColors[index % avatarColors.length],
                          'id': account.customerId,
                          'currency': balance.currency,
                        };

                        return _buildFriendItem(friend, l10n);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendItem(Map<String, dynamic> friend, AppLocalizations l10n) {
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

            // Account info
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
                    '${l10n.account}: ${friend['accountId']} • ${friend['date']}',
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
                  friend['amount'] == 0
                      ? l10n.noBalance
                      : friend['amount'] < 0
                      ? l10n.youOwe
                      : l10n.owesYou,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: friend['amount'] == 0
                        ? AppColors.getSecondaryTextColor(context)
                        : friend['amount'] < 0
                        ? AppColors.negativeRed
                        : AppColors.positiveGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${friend['currency']} ${friend['amount'].abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: friend['amount'] == 0
                            ? AppColors.getSecondaryTextColor(context)
                            : friend['amount'] < 0
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

  void _navigateToFriendDetail(Map<String, dynamic> friend) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final transactionService = TransactionService();
      List<Transaction> transactions = [];

      print(
        '🚀 Starting transaction fetch for account: ${friend['accountId']}',
      );

      // Try to fetch real transactions from API
      try {
        transactions = await transactionService.fetchTransactionsByAccountId(
          friend['accountId'],
        );
        print(
          '✅ Successfully fetched ${transactions.length} real transactions from API',
        );

        // If no transactions found, you might want to try mock data
        if (transactions.isEmpty) {
          print(
            '📝 No real transactions found, generating mock data for testing...',
          );
          transactions = await transactionService.generateMockTransactions(
            friend['accountId'],
          );
        }
      } catch (apiError) {
        print('⚠️ Real API fetch failed: $apiError');
        print('📝 Falling back to mock transactions for testing...');

        // Use mock data as fallback
        transactions = await transactionService.generateMockTransactions(
          friend['accountId'],
        );
      }

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Navigate to friend detail screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FriendDetailScreen(
              friendName: friend['name'],
              balance: friend['amount'].toDouble(),
              friendId: friend['id'],
              transactions: transactions,
            ),
          ),
        );
      }
    } catch (error) {
      print('❌ All transaction fetch methods failed: $error');

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Show error message with option to continue without transactions
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to load transactions: $error'),
            backgroundColor: AppColors.negativeRed,
            action: SnackBarAction(
              label: 'Continue Anyway',
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendDetailScreen(
                      friendName: friend['name'],
                      balance: friend['amount'].toDouble(),
                      friendId: friend['id'],
                      transactions: [], // Empty list
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    }
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
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
          l10n.noAccountsFound,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.getPrimaryTextColor(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.addAccountToSplitwise,
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
          child: Text(l10n.addAccountToSplitwise),
        ),
      ],
    );
  }
}