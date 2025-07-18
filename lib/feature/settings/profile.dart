import 'package:flutter/material.dart';
import 'package:yoweme/core/utils/constants/colors.dart';
import 'package:yoweme/main.dart';

class ProfileScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const ProfileScreen({super.key, required this.onThemeChanged});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Info Card
            Container(
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
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getPrimaryTextColor(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.getSecondaryTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Theme Selection Card
            Container(
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
                  Text(
                    'Theme',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getPrimaryTextColor(context),
                    ),
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
            ),

            const SizedBox(height: 24),

            // Language Selection Card
            Container(
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
                  Text(
                    'Language',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getPrimaryTextColor(context),
                    ),
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
            ),
          ],
        ),
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
