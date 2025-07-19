import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yoweme/core/utils/theme/theme.dart';
import 'package:yoweme/core/utils/constants/colors.dart';
import 'package:yoweme/feature/settings/profile.dart';
import 'package:yoweme/l10n/app_localizations.dart';
import 'package:yoweme/providers/locale_provider.dart';
import 'package:yoweme/providers/theme_provider.dart';

import 'package:yoweme/screens/dashboard_screen.dart';
import 'package:yoweme/screens/friend_detail_screen.dart';
import 'package:yoweme/screens/add_expense_screen.dart';
import 'package:yoweme/screens/ai_insights_screen.dart';
import 'package:yoweme/screens/notification_screen.dart';
import 'package:yoweme/screens/otp_screen.dart';
import 'package:yoweme/screens/otp_verification_screen.dart';

import 'package:yoweme/services/gemini_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print("✅ Environment file loaded successfully");

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
  }

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(YOweMeApp(isLoggedIn: isLoggedIn));
}

class YOweMeApp extends StatelessWidget {
  final bool isLoggedIn;

  const YOweMeApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return MaterialApp(
            title: 'YOweMe - Smart Expense Splitting',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('ar')],
            home: isLoggedIn ? const OTPScreen() : const MainNavigationScreen(),
            debugShowCheckedModeBanner: false,
            routes: {
              '/otp': (context) => const OTPScreen(),
              '/otp-verification': (context) =>
                  const OTPVerificationScreen(phoneNumber: ''),
              '/main': (context) => const MainNavigationScreen(),
              '/dashboard': (context) => const DashboardScreen(),
              '/friend-detail': (context) => const FriendDetailScreen(
                friendName: 'Peter Clarkson',
                balance: -154.68,
                friendId: '1',
                transactions: [],
              ),
              '/add-expense': (context) => const AddExpenseScreen(),
              '/ai-insights': (context) => const AIInsightsScreen(),
              '/notifications': (context) => const NotificationsScreen(),
            },
          );
        },
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    const DashboardScreen(),
    const AIInsightsScreen(),
    const AddExpenseScreen(),
    const NotificationsScreen(), // Placeholder for NotificationsScreen
    const ProfileScreen(), // Placeholder for ProfileScreen
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
