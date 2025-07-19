import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoweme/core/utils/constants/colors.dart';
import 'package:yoweme/main.dart';
import 'package:yoweme/model/user.dart';
import 'package:yoweme/providers/theme_provider.dart';
import 'package:yoweme/providers/locale_provider.dart';
import 'package:yoweme/services/account_services.dart';
import 'package:yoweme/screens/otp_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
    _themeMode = Provider.of<ThemeProvider>(context, listen: false).themeMode;
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
    Provider.of<ThemeProvider>(context, listen: false).setThemeMode(themeMode);
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OTPScreen()),
    );
  }

  String formatCustomerIdToName(String customerId) {
    String name = customerId
        .replaceAll('IND_CUST_', 'Individual Customer ')
        .replaceAll('CORP_CUST_', 'Corporate Customer ')
        .replaceAll('BUS_CUST_', 'Business Customer ');
    name = name.replaceAll(RegExp(r'0+'), '');
    return name;
  }

  Account? get primaryAccount {
    if (_accounts == null || _accounts!.isEmpty) return null;
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
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppColors.getPrimaryTextColor(context),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildProfileCard(),
                  const SizedBox(height: 24),
                  if (_accounts != null && _accounts!.isNotEmpty)
                    _buildAccountsCard(),
                  const SizedBox(height: 24),
                  _buildThemeCard(),
                  const SizedBox(height: 24),
                  _buildLanguageCard(),
                  const SizedBox(height: 24),
                  _buildLogoutCard(),
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
          _buildInfoRow(
            'Total Accounts',
            '${_accounts!.length}',
            Icons.account_circle,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'First Account',
            DateFormat('MMM dd, yyyy').format(oldestAccount.openingDate),
            Icons.history,
          ),
          const SizedBox(height: 12),
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
            () => _changeTheme(ThemeMode.system),
          ),
          _buildThemeOption(
            context,
            'Light',
            'Light theme',
            Icons.light_mode,
            () => _changeTheme(ThemeMode.light),
          ),
          _buildThemeOption(
            context,
            'Dark',
            'Dark theme',
            Icons.dark_mode,
            () => _changeTheme(ThemeMode.dark),
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
            () => Provider.of<LocaleProvider>(
              context,
              listen: false,
            ).setLocale(const Locale('en')),
          ),
          _buildLanguageOption(
            context,
            'العربية',
            'تغيير اللغة إلى العربية',
            Icons.translate,
            () => Provider.of<LocaleProvider>(
              context,
              listen: false,
            ).setLocale(const Locale('ar')),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutCard() {
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
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.logout, color: AppColors.negativeRed, size: 24),
        title: Text(
          'Logout',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.getPrimaryTextColor(context),
          ),
        ),
        onTap: _logout,
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
}
