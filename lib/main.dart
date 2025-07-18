import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoweme/core/utils/theme/theme.dart';
import 'package:yoweme/core/utils/constants/colors.dart';
import 'package:yoweme/model/user.dart';
import 'package:yoweme/screens/dashboard_screen.dart';
import 'package:yoweme/screens/friend_detail_screen.dart';
import 'package:yoweme/screens/add_expense_screen.dart';
import 'package:yoweme/screens/ai_insights_screen.dart';
import 'package:yoweme/screens/notification_screen.dart';
import 'package:yoweme/screens/otp_screen.dart';
import 'package:yoweme/screens/otp_verification_screen.dart';
import 'package:yoweme/services/account_services.dart';
import 'package:yoweme/services/gemini_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try to load environment variables - handle if file doesn't exist
  try {
    await dotenv.load(fileName: ".env");
    print("✅ Environment file loaded successfully");

    // Initialize Gemini AI only if API key is available
    if (dotenv.env['GEMINI_API_KEY'] != null &&
        dotenv.env['GEMINI_API_KEY']!.isNotEmpty &&
        dotenv.env['GEMINI_API_KEY']!.startsWith('AIza')) {
      GeminiService.initialize();
      print("✅ Gemini AI initialized successfully");
    } else {
      print("⚠️ Invalid Gemini API key - AI features will be disabled");
    }
  } catch (e) {
    print("⚠️ .env file not found - creating one for you...");
    print("Please add your Gemini API key to the .env file");
    // Continue without AI features for now
  }

  // Check login state
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(YOweMeApp(isLoggedIn: isLoggedIn));
}

class YOweMeApp extends StatefulWidget {
  final bool isLoggedIn;

  const YOweMeApp({super.key, required this.isLoggedIn});

  @override
  State<YOweMeApp> createState() => _YOweMeAppState();
}

class _YOweMeAppState extends State<YOweMeApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YOweMe - Smart Expense Splitting',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: widget.isLoggedIn
          ? MainNavigationScreen(onThemeChanged: _changeTheme)
          : const OTPScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/otp': (context) => const OTPScreen(),
        '/otp-verification': (context) =>
            const OTPVerificationScreen(phoneNumber: ''),
        '/main': (context) =>
            MainNavigationScreen(onThemeChanged: _changeTheme),
        '/dashboard': (context) => const DashboardScreen(),
        '/friend-detail': (context) => const FriendDetailScreen(
          friendName: 'Peter Clarkson',
          balance: -154.68,
          friendId: '1',
        ),
        '/add-expense': (context) => const AddExpenseScreen(),
        '/ai-insights': (context) => const AIInsightsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const MainNavigationScreen({super.key, required this.onThemeChanged});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    const DashboardScreen(),
    const AIInsightsScreen(),
    const AddExpenseScreen(),
    const NotificationsScreen(),
    ProfileScreen(onThemeChanged: widget.onThemeChanged),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.getCardColor(context),
          boxShadow: [
            BoxShadow(
              color: AppColors.getShadowLight(context),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  icon: Icons.people_outline,
                  activeIcon: Icons.people,
                  label: 'Friends',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.analytics_outlined,
                  activeIcon: Icons.analytics,
                  label: 'Insights',
                  index: 1,
                ),
                _buildAddButton(),
                _buildNavItem(
                  icon: Icons.notifications_outlined,
                  activeIcon: Icons.notifications,
                  label: 'Activity',
                  index: 3,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Account',
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? AppColors.primaryTeal
                  : AppColors.getSecondaryTextColor(context),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? AppColors.primaryTeal
                    : AppColors.getSecondaryTextColor(context),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.getPrimaryGradient(context),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryTeal.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;

  const ProfileScreen({super.key, required this.onThemeChanged});

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
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Info Card,
            FutureBuilder<List<Account>>(
              future: ApiServiceAccounts().fetchAccounts(),
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
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No account data available',
                      style: TextStyle(
                        color: AppColors.getSecondaryTextColor(context),
                      ),
                    ),
                  );
                }

                // Assuming we take the first account for the profile
                final account = snapshot.data![0];

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
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          account.customerId,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.getPrimaryTextColor(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Account Opened: ${DateFormat.yMMMd().format(account.openingDate)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.getSecondaryTextColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
                    () => onThemeChanged(ThemeMode.system),
                  ),
                  _buildThemeOption(
                    context,
                    'Light',
                    'Light theme',
                    Icons.light_mode,
                    () => onThemeChanged(ThemeMode.light),
                  ),
                  _buildThemeOption(
                    context,
                    'Dark',
                    'Dark theme',
                    Icons.dark_mode,
                    () => onThemeChanged(ThemeMode.dark),
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
}
