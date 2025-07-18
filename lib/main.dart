import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoweme/core/utils/theme/theme.dart';
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

  // Try to load environment variables - handle if file doesn't exist
  try {
    await dotenv.load(fileName: ".env");
    print("✅ Environment file loaded successfully");

    // Initialize Gemini AI only if API key is available
    if (dotenv.env['GEMINI_API_KEY'] != null &&
        dotenv.env['GEMINI_API_KEY']!.isNotEmpty) {
      GeminiService.initialize();
      print("✅ Gemini AI initialized successfully");
    } else {
      print("⚠️ Gemini API key not found - AI features will be disabled");
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

class YOweMeApp extends StatelessWidget {
  final bool isLoggedIn;

  const YOweMeApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YOweMe - Smart Expense Splitting',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: isLoggedIn ? const MainNavigationScreen() : const OTPScreen(),
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
        ),
        '/add-expense': (context) => const AddExpenseScreen(),
        '/ai-insights': (context) => const AIInsightsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
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

  final List<Widget> _screens = [
    const DashboardScreen(),
    const AIInsightsScreen(),
    const AddExpenseScreen(),
    const NotificationsScreen(),
    const PlaceholderScreen(title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white),
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
                  ? const Color(0xFF2C5F5A)
                  : const Color(0xFF6B7280),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? const Color(0xFF2C5F5A)
                    : const Color(0xFF6B7280),
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
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2C5F5A), Color(0xFF1E4A43)],
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.construction,
                size: 48,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '$title Screen',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming soon...',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}
