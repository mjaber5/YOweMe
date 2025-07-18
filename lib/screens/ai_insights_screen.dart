// lib/screens/ai_insights_screen.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:yoweme/model/expense.dart';
import 'package:yoweme/model/user.dart';
import '../core/utils/constants/colors.dart';
import '../services/gemini_service.dart';

class AIInsightsScreen extends StatefulWidget {
  const AIInsightsScreen({super.key});

  @override
  State<AIInsightsScreen> createState() => _AIInsightsScreenState();
}

class _AIInsightsScreenState extends State<AIInsightsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  Map<String, dynamic>? _insights;
  Map<String, dynamic>? _predictions;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAIInsights();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAIInsights() async {
    setState(() => _isLoading = true);

    try {
      // Mock data for demonstration - replace with real data
      final List<Expense> mockExpenses = []; // Your expense data
      final User mockUser = User(
        id: '1',
        name: 'Current User',
        email: 'user@example.com',
        createdAt: DateTime.now(),
      ); // Current user
      final List<User> mockFriends = []; // Friends list

      // Call Gemini AI services
      final insightsResult = await GeminiService.generateSpendingInsights(
        mockExpenses, // Pass List<Expense>
        mockUser, // Pass User
        mockFriends,
      );

      final predictionsResult = await GeminiService.predictFutureExpenses(
        mockExpenses,
      );

      setState(() {
        _insights = insightsResult;
        _predictions = predictionsResult;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          'AI Insights',
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              LucideIcons.refreshCw,
              color: AppColors.primaryText,
            ),
            onPressed: _loadAIInsights,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryTeal,
          unselectedLabelColor: AppColors.secondaryText,
          indicatorColor: AppColors.primaryTeal,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Predictions'),
            Tab(text: 'Reports'),
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildPredictionsTab(),
                _buildReportsTab(),
              ],
            ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primaryTeal),
          SizedBox(height: 16),
          Text(
            'AI is analyzing your expenses...',
            style: TextStyle(fontSize: 16, color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Spending Summary Card
          _buildSpendingSummaryCard(),
          const SizedBox(height: 20),

          // Monthly Trend Chart
          _buildMonthlyTrendCard(),
          const SizedBox(height: 20),

          // Category Breakdown
          _buildCategoryBreakdownCard(),
          const SizedBox(height: 20),

          // Quick Insights
          _buildQuickInsightsCard(),
        ],
      ),
    );
  }

  Widget _buildSpendingSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.trendingUp,
                  color: AppColors.primaryTeal,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Spending Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'This Month',
                  '\$1,247.50',
                  '+12.5%',
                  AppColors.positiveGreen,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  'Avg/Month',
                  '\$982.30',
                  '-8.2%',
                  AppColors.negativeRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'Top Category',
                  'Food & Dining',
                  '34%',
                  AppColors.neutralBlue,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  'Most Active',
                  'Victor',
                  '12 expenses',
                  AppColors.primaryTeal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    String label,
    String value,
    String change,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          change,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyTrendCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Spending Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 1500,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 800),
                      const FlSpot(1, 950),
                      const FlSpot(2, 1200),
                      const FlSpot(3, 1100),
                      const FlSpot(4, 1300),
                      const FlSpot(5, 980),
                      const FlSpot(6, 1150),
                      const FlSpot(7, 1250),
                      const FlSpot(8, 1400),
                      const FlSpot(9, 1200),
                      const FlSpot(10, 1100),
                      const FlSpot(11, 1247),
                    ],
                    isCurved: true,
                    color: AppColors.primaryTeal,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primaryTeal.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdownCard() {
    final categories = [
      {
        'name': 'Food & Dining',
        'amount': 425.30,
        'percentage': 34,
        'color': Colors.orange,
      },
      {
        'name': 'Transportation',
        'amount': 287.20,
        'percentage': 23,
        'color': Colors.blue,
      },
      {
        'name': 'Entertainment',
        'amount': 186.50,
        'percentage': 15,
        'color': Colors.purple,
      },
      {
        'name': 'Shopping',
        'amount': 149.60,
        'percentage': 12,
        'color': Colors.green,
      },
      {
        'name': 'Others',
        'amount': 198.90,
        'percentage': 16,
        'color': Colors.grey,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spending by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 20),

          ...categories
              .map((category) => _buildCategoryItem(category))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: category['color'],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category['name'],
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primaryText,
              ),
            ),
          ),
          Text(
            '\$${category['amount'].toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${category['percentage']}%',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInsightsCard() {
    final insights = [
      {
        'title': 'Spending Alert',
        'description': 'You\'ve spent 23% more on dining this month',
        'icon': LucideIcons.alertTriangle,
        'color': AppColors.warning,
      },
      {
        'title': 'Smart Tip',
        'description': 'Consider using group transportation to save \$45/month',
        'icon': LucideIcons.lightbulb,
        'color': AppColors.info,
      },
      {
        'title': 'Achievement',
        'description': 'You saved \$120 compared to last month!',
        'icon': LucideIcons.trophy,
        'color': AppColors.success,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Insights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 16),

          ...insights.map((insight) => _buildInsightItem(insight)).toList(),
        ],
      ),
    );
  }

  Widget _buildInsightItem(Map<String, dynamic> insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: insight['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: insight['color'].withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(insight['icon'], color: insight['color'], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight['title'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: insight['color'],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight['description'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildPredictionCard(
            'Next Month Forecast',
            '\$1,180.00',
            'Based on your spending patterns',
            LucideIcons.calendar,
            AppColors.primaryTeal,
          ),
          const SizedBox(height: 16),
          _buildPredictionCard(
            'Year-end Projection',
            '\$14,250.00',
            'Estimated total annual expenses',
            LucideIcons.trendingUp,
            AppColors.neutralBlue,
          ),
          const SizedBox(height: 16),
          _buildPredictionCard(
            'Savings Opportunity',
            '\$324.00',
            'Potential monthly savings identified',
            LucideIcons.piggyBank,
            AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionCard(
    String title,
    String amount,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildReportOption(
            'Monthly Report',
            'Detailed breakdown of this month\'s expenses',
            LucideIcons.fileText,
            () => _generateReport('monthly'),
          ),
          const SizedBox(height: 16),
          _buildReportOption(
            'Quarterly Analysis',
            'Comprehensive spending analysis for Q1 2024',
            LucideIcons.barChart3,
            () => _generateReport('quarterly'),
          ),
          const SizedBox(height: 16),
          _buildReportOption(
            'Year-end Summary',
            'Complete financial overview for 2024',
            LucideIcons.calendar,
            () => _generateReport('yearly'),
          ),
          const SizedBox(height: 16),
          _buildReportOption(
            'Custom Report',
            'Generate report for specific date range',
            LucideIcons.settings,
            () => _generateReport('custom'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportOption(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primaryTeal, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              color: AppColors.secondaryText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _generateReport(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Generate ${type.toUpperCase()} Report'),
        content: const Text('AI is generating your personalized report...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$type report generated successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }
}
