import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:yoweme/core/utils/constants/colors.dart';
import 'package:yoweme/main.dart';
import 'package:yoweme/model/user.dart';
import 'package:yoweme/services/account_services.dart';
import 'package:yoweme/screens/otp_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const ProfileScreen({super.key, required this.onThemeChanged});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Account>? _accounts;
  bool _isLoading = true;
  String? _error;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final accounts = await ApiServiceAccounts().fetchAccounts();

      setState(() {
        _accounts = accounts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.getCardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.negativeRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                LucideIcons.logOut,
                color: AppColors.negativeRed,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Logout',
              style: TextStyle(
                color: AppColors.getPrimaryTextColor(context),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout? You will need to enter your phone number and OTP again to sign back in.',
          style: TextStyle(
            color: AppColors.getSecondaryTextColor(context),
            fontSize: 14,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.getPrimaryTextColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.negativeRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await _performLogout();
    }
  }

  Future<void> _performLogout() async {
    try {
      // Clear login state from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('userId'); // Remove any stored user data
      await prefs.remove('phoneNumber'); // Remove stored phone number

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(LucideIcons.checkCircle, color: Colors.white, size: 18),
                SizedBox(width: 12),
                Text('Logged out successfully'),
              ],
            ),
            backgroundColor: AppColors.positiveGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        // Navigate to OTP screen and clear navigation stack
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OTPScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: $e'),
            backgroundColor: AppColors.negativeRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  // Helper function to format customer ID to display name
  String formatCustomerIdToName(String customerId) {
    String name = customerId
        .replaceAll('IND_CUST_', 'Individual Customer ')
        .replaceAll('CORP_CUST_', 'Corporate Customer ')
        .replaceAll('BUS_CUST_', 'Business Customer ');

    // Remove leading zeros
    name = name.replaceAll(RegExp(r'0+'), '');
    return name;
  }

  // Get primary account (first account or most recent)
  Account? get primaryAccount {
    if (_accounts == null || _accounts!.isEmpty) return null;

    // Sort by opening date (most recent first) and return the first one
    final sortedAccounts = List<Account>.from(_accounts!);
    sortedAccounts.sort((a, b) => b.openingDate.compareTo(a.openingDate));
    return sortedAccounts.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.getPrimaryTextColor(context),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    MainNavigationScreen(onThemeChanged: _changeTheme),
              ),
            );
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppColors.getPrimaryTextColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: AppColors.getPrimaryTextColor(context),
            onPressed: _fetchUserData,
          ),
          // Logout button in app bar
          IconButton(
            icon: const Icon(LucideIcons.logOut),
            color: AppColors.negativeRed,
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Info Card
                  _buildProfileCard(),
                  const SizedBox(height: 24),

                  // Accounts Summary Card
                  if (_accounts != null && _accounts!.isNotEmpty)
                    _buildAccountsCard(),

                  const SizedBox(height: 24),

                  // Theme Selection Card
                  _buildThemeCard(),

                  const SizedBox(height: 24),

                  // Language Selection Card
                  _buildLanguageCard(),

                  const SizedBox(height: 24),

                  // Account Actions Card
                  _buildAccountActionsCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.negativeRed),
            const SizedBox(height: 16),
            Text(
              'Failed to load profile data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.getPrimaryTextColor(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error occurred',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.getSecondaryTextColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final account = primaryAccount;
    final displayName = account != null
        ? formatCustomerIdToName(account.customerId)
        : 'User';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowLight(context),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryTeal,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              displayName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.getPrimaryTextColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            if (account != null) ...[
              Text(
                'Customer ID: ${account.customerId}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.getSecondaryTextColor(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Member since ${DateFormat('MMM dd, yyyy').format(account.openingDate)}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.getSecondaryTextColor(context),
                ),
              ),
            ] else ...[
              Text(
                'No account information available',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.getSecondaryTextColor(context),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccountsCard() {
    if (_accounts == null || _accounts!.isEmpty) return const SizedBox.shrink();

    final oldestAccount = _accounts!.reduce(
      (a, b) => a.openingDate.isBefore(b.openingDate) ? a : b,
    );
    final newestAccount = _accounts!.reduce(
      (a, b) => a.openingDate.isAfter(b.openingDate) ? a : b,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowLight(context),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: AppColors.primaryTeal,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Account Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Accounts count
          _buildInfoRow(
            'Total Accounts',
            '${_accounts!.length}',
            Icons.account_circle,
          ),

          const SizedBox(height: 12),

          // Oldest account
          _buildInfoRow(
            'First Account',
            DateFormat('MMM dd, yyyy').format(oldestAccount.openingDate),
            Icons.history,
          ),

          const SizedBox(height: 12),

          // Most recent account
          _buildInfoRow(
            'Latest Account',
            DateFormat('MMM dd, yyyy').format(newestAccount.openingDate),
            Icons.new_releases,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.getSecondaryTextColor(context)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.getSecondaryTextColor(context),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.getPrimaryTextColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowLight(context),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette, color: AppColors.primaryTeal, size: 24),
              const SizedBox(width: 12),
              Text(
                'Theme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildThemeOption(
            context,
            'System',
            'Use device theme',
            Icons.smartphone,
            () => widget.onThemeChanged(ThemeMode.system),
          ),
          _buildThemeOption(
            context,
            'Light',
            'Light theme',
            Icons.light_mode,
            () => widget.onThemeChanged(ThemeMode.light),
          ),
          _buildThemeOption(
            context,
            'Dark',
            'Dark theme',
            Icons.dark_mode,
            () => widget.onThemeChanged(ThemeMode.dark),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowLight(context),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.language, color: AppColors.primaryTeal, size: 24),
              const SizedBox(width: 12),
              Text(
                'Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLanguageOption(
            context,
            'English',
            'Change language to English',
            Icons.language,
            () {},
          ),
          _buildLanguageOption(
            context,
            'العربية',
            'تغيير اللغة إلى العربية',
            Icons.translate,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActionsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowLight(context),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: AppColors.primaryTeal, size: 24),
              const SizedBox(width: 12),
              Text(
                'Account Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Privacy option
          _buildActionOption(
            context,
            'Privacy',
            'Manage your privacy settings',
            LucideIcons.shield,
            () {},
          ),

          // Help & Support option
          _buildActionOption(
            context,
            'Help & Support',
            'Get help and contact support',
            LucideIcons.helpCircle,
            () {},
          ),

          // About option
          _buildActionOption(
            context,
            'About',
            'App version and information',
            LucideIcons.info,
            () {},
          ),

          // Logout option (prominent)
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: _buildActionOption(
              context,
              'Logout',
              'Sign out of your account',
              LucideIcons.logOut,
              _handleLogout,
              isDestructive: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primaryTeal),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.getPrimaryTextColor(context),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppColors.getSecondaryTextColor(context)),
      ),
      onTap: onTap,
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.getSecondaryTextColor(context),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primaryTeal),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.getPrimaryTextColor(context),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppColors.getSecondaryTextColor(context)),
      ),
      onTap: onTap,
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.getSecondaryTextColor(context),
      ),
    );
  }

  Widget _buildActionOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: isDestructive
            ? Border.all(color: AppColors.negativeRed.withOpacity(0.2))
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.negativeRed : AppColors.primaryTeal,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive
                ? AppColors.negativeRed
                : AppColors.getPrimaryTextColor(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDestructive
                ? AppColors.negativeRed.withOpacity(0.7)
                : AppColors.getSecondaryTextColor(context),
          ),
        ),
        onTap: onTap,
        trailing: Icon(
          Icons.chevron_right,
          color: isDestructive
              ? AppColors.negativeRed
              : AppColors.getSecondaryTextColor(context),
        ),
      ),
    );
  }
}
