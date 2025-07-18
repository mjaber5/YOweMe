import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yoweme/l10n/app_localizations.dart';
import 'dart:io';
import 'package:yoweme/model/expense.dart';
import 'package:yoweme/model/user.dart';
import '../core/utils/constants/colors.dart';

class AIInsightsScreen extends StatefulWidget {
  const AIInsightsScreen({super.key});

  @override
  State<AIInsightsScreen> createState() => _AIInsightsScreenState();
}

class _AIInsightsScreenState extends State<AIInsightsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _isGeneratingPDF = false;
  Map<String, dynamic>? _insights;
  Map<String, dynamic>? _predictions;
  Map<String, dynamic> _reportData = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAIInsights();
    _generateReportData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateReportData() {
    _reportData = {
      'summary': {
        'totalExpenses': 1247.50,
        'monthlyAverage': 982.30,
        'topCategory': 'Food & Dining',
        'mostActiveUser': 'Victor',
        'changeFromLastMonth': 12.5,
      },
      'categories': [
        {
          'name': 'Food & Dining',
          'amount': 425.30,
          'percentage': 34,
          'color': 'orange',
        },
        {
          'name': 'Transportation',
          'amount': 287.20,
          'percentage': 23,
          'color': 'blue',
        },
        {
          'name': 'Entertainment',
          'amount': 186.50,
          'percentage': 15,
          'color': 'purple',
        },
        {
          'name': 'Shopping',
          'amount': 149.60,
          'percentage': 12,
          'color': 'green',
        },
        {'name': 'Others', 'amount': 198.90, 'percentage': 16, 'color': 'grey'},
      ],
      'monthlyTrend': [
        {'month': 'Jan', 'amount': 800.0},
        {'month': 'Feb', 'amount': 950.0},
        {'month': 'Mar', 'amount': 1200.0},
        {'month': 'Apr', 'amount': 1100.0},
        {'month': 'May', 'amount': 1300.0},
        {'month': 'Jun', 'amount': 980.0},
        {'month': 'Jul', 'amount': 1150.0},
        {'month': 'Aug', 'amount': 1250.0},
        {'month': 'Sep', 'amount': 1400.0},
        {'month': 'Oct', 'amount': 1200.0},
        {'month': 'Nov', 'amount': 1100.0},
        {'month': 'Dec', 'amount': 1247.0},
      ],
      'insights': [
        {
          'type': 'alert',
          'title': 'Spending Alert',
          'description': 'You\'ve spent 23% more on dining this month',
          'recommendation':
              'Consider cooking at home more often to reduce dining expenses.',
        },
        {
          'type': 'tip',
          'title': 'Smart Tip',
          'description':
              'Consider using group transportation to save \$45/month',
          'recommendation':
              'Coordinate with friends for shared rides to reduce transportation costs.',
        },
        {
          'type': 'achievement',
          'title': 'Achievement',
          'description': 'You saved \$120 compared to last month!',
          'recommendation':
              'Keep up the good work! Continue your current spending habits.',
        },
      ],
      'predictions': [
        {
          'title': 'Next Month Forecast',
          'amount': 1180.00,
          'description': 'Based on your spending patterns',
          'confidence': 85,
        },
        {
          'title': 'Year-end Projection',
          'amount': 14250.00,
          'description': 'Estimated total annual expenses',
          'confidence': 78,
        },
        {
          'title': 'Savings Opportunity',
          'amount': 324.00,
          'description': 'Potential monthly savings identified',
          'confidence': 92,
        },
      ],
      'generatedAt': DateTime.now(),
    };
  }

  Future<void> _loadAIInsights() async {
    setState(() => _isLoading = true);

    try {
      // Mock data for demonstration - replace with real data
      final List<Expense> mockExpenses = []; // Your expense data
      final Account mockUser = Account(
        customerId: 'IND_CUST_001',
        openingDate: DateTime.now(),
      );
      final List<Account> mockFriends = []; // Friends list

      // Simulate AI processing
      await Future.delayed(const Duration(seconds: 2));

      // Debug: Print monthlyTrend data types
      print('Monthly Trend Data: ${_reportData['monthlyTrend']}');
      for (var item in _reportData['monthlyTrend']) {
        print(
          'Month: ${item['month']}, Amount: ${item['amount']} (${item['amount'].runtimeType})',
        );
      }

      setState(() {
        _insights = _reportData;
        _predictions = _reportData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('Failed to load AI insights. Please try again: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackgroundColor(context),
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.getPrimaryTextColor(context)),
        title: Text(
          l10n.aiInsights,
          style: TextStyle(
            color: AppColors.getPrimaryTextColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              LucideIcons.share,
              color: AppColors.getPrimaryTextColor(context),
            ),
            onPressed: () => _shareReport(l10n),
          ),
          IconButton(
            icon: Icon(
              LucideIcons.download,
              color: AppColors.getPrimaryTextColor(context),
            ),
            onPressed: () => _downloadPDF(l10n),
          ),
          IconButton(
            icon: Icon(
              LucideIcons.refreshCw,
              color: AppColors.getPrimaryTextColor(context),
            ),
            onPressed: _loadAIInsights,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryTeal,
          unselectedLabelColor: AppColors.getSecondaryTextColor(context),
          indicatorColor: AppColors.primaryTeal,
          dividerColor: AppColors.getSurfaceColor(context),
          tabs: [
            Tab(text: 'Overview'),
            Tab(text: l10n.financialPredictions),
            Tab(text: l10n.reports),
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingState(l10n)
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(l10n),
                _buildPredictionsTab(l10n),
                _buildReportsTab(l10n),
              ],
            ),
    );
  }

  Widget _buildLoadingState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primaryTeal),
          const SizedBox(height: 16),
          Text(
            'AI is analyzing your expenses...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.getSecondaryTextColor(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few moments',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.getLightTextColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExecutiveSummaryCard(l10n),
          const SizedBox(height: 20),
          _buildSpendingSummaryCard(l10n),
          const SizedBox(height: 20),
          _buildMonthlyTrendCard(l10n),
          const SizedBox(height: 20),
          _buildCategoryBreakdownCard(l10n),
          const SizedBox(height: 20),
          _buildQuickInsightsCard(l10n),
        ],
      ),
    );
  }

  Widget _buildExecutiveSummaryCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.getPrimaryGradient(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowMedium(context),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  LucideIcons.brain,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.executiveSummary,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.aiPoweredInsights,
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.keyFindings,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryPoint('📈', l10n.spendingIncreased),
          _buildSummaryPoint('🍽️', l10n.foodDiningTop),
          _buildSummaryPoint('💡', l10n.potentialSavings),
          _buildSummaryPoint('🎯', l10n.onTrackBudget),
        ],
      ),
    );
  }

  Widget _buildSummaryPoint(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingSummaryCard(AppLocalizations l10n) {
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
              Text(
                l10n.financialMetrics,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  l10n.thisMonth,
                  '\$1,247.50',
                  '+12.5%',
                  AppColors.positiveGreen,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  l10n.avgMonth,
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
                  l10n.topCategory,
                  'Food & Dining',
                  '34%',
                  AppColors.neutralBlue,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  l10n.mostActive,
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
          style: TextStyle(
            fontSize: 12,
            color: AppColors.getSecondaryTextColor(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.getPrimaryTextColor(context),
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

  Widget _buildMonthlyTrendCard(AppLocalizations l10n) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.monthlySpendingTrend,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '12 Months',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child:
                _reportData['monthlyTrend'] == null ||
                    _reportData['monthlyTrend'].isEmpty
                ? const Center(child: Text('No data available'))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 250,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: AppColors.getShadowLight(
                            context,
                          ).withOpacity(0.2),
                          strokeWidth: 1,
                        ),
                        getDrawingVerticalLine: (value) => FlLine(
                          color: AppColors.getShadowLight(
                            context,
                          ).withOpacity(0.2),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 250,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '\$${value.toInt()}',
                                style: TextStyle(
                                  color: AppColors.getSecondaryTextColor(
                                    context,
                                  ),
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final int index = value.toInt();
                              if (index < 0 ||
                                  index >= _reportData['monthlyTrend'].length) {
                                return const Text('');
                              }
                              final month =
                                  _reportData['monthlyTrend'][index]['month'];
                              return Text(
                                month,
                                style: TextStyle(
                                  color: AppColors.getSecondaryTextColor(
                                    context,
                                  ),
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _buildChartSpots(),
                          isCurved: true,
                          color: AppColors.primaryTeal,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.primaryTeal.withOpacity(0.1),
                          ),
                        ),
                      ],
                      minX: 0,
                      maxX: (_reportData['monthlyTrend'].length - 1).toDouble(),
                      minY: 0,
                      maxY: 1500,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _buildChartSpots() {
    final List<FlSpot> spots = [];

    for (int i = 0; i < _reportData['monthlyTrend'].length; i++) {
      final monthData = _reportData['monthlyTrend'][i];
      final amount = monthData['amount'];

      double yValue = 0.0;
      if (amount is num) {
        yValue = amount.toDouble();
      } else if (amount is String) {
        yValue = double.tryParse(amount) ?? 0.0;
      }

      spots.add(FlSpot(i.toDouble(), yValue));
    }

    return spots;
  }

  Widget _buildCategoryBreakdownCard(AppLocalizations l10n) {
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
          Text(
            l10n.categoryBreakdown,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.getPrimaryTextColor(context),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: List.generate(_reportData['categories'].length, (
                  index,
                ) {
                  final category = _reportData['categories'][index];
                  return PieChartSectionData(
                    color: _getCategoryColor(category['color']),
                    value: category['percentage'].toDouble(),
                    title: '${category['percentage']}%',
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: _reportData['categories'].map<Widget>((category) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(category['color']),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${category['name']}: \$${category['amount']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.getSecondaryTextColor(context),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'orange':
        return Colors.orange;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      case 'green':
        return Colors.green;
      case 'grey':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  Widget _buildQuickInsightsCard(AppLocalizations l10n) {
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
          Text(
            l10n.quickInsights,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.getPrimaryTextColor(context),
            ),
          ),
          const SizedBox(height: 16),
          ..._reportData['insights'].map<Widget>((insight) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildInsightItem(
                insight['type'],
                insight['title'],
                insight['description'],
                insight['recommendation'],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInsightItem(
    String type,
    String title,
    String description,
    String recommendation,
  ) {
    IconData icon;
    Color color;
    switch (type) {
      case 'alert':
        icon = LucideIcons.alertTriangle;
        color = AppColors.negativeRed;
        break;
      case 'tip':
        icon = LucideIcons.lightbulb;
        color = AppColors.primaryTeal;
        break;
      case 'achievement':
        icon = LucideIcons.trophy;
        color = AppColors.positiveGreen;
        break;
      default:
        icon = LucideIcons.info;
        color = AppColors.neutralBlue;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.getSecondaryTextColor(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Recommendation: $recommendation',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.getLightTextColor(context),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionsTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.financialPredictions,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.getPrimaryTextColor(context),
            ),
          ),
          const SizedBox(height: 20),
          ..._reportData['predictions'].map<Widget>((prediction) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.getCardColor(context),
                  borderRadius: BorderRadius.circular(12),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          prediction['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getPrimaryTextColor(context),
                          ),
                        ),
                        Text(
                          'Confidence: ${prediction['confidence']}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.getSecondaryTextColor(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${prediction['amount'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prediction['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.getSecondaryTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildReportsTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.reports,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.getPrimaryTextColor(context),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _downloadPDF(l10n),
            icon: const Icon(LucideIcons.download),
            label: Text(l10n.downloadFullReport),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _shareReport(l10n),
            icon: const Icon(LucideIcons.share),
            label: Text(l10n.shareReport),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.getCardColor(context),
              borderRadius: BorderRadius.circular(12),
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
                  l10n.reportDetails,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getPrimaryTextColor(context),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${l10n.generated}: ${_reportData['generatedAt'].toString().substring(0, 16)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.getSecondaryTextColor(context),
                  ),
                ),
                const SizedBox(height: 8),
               Text(
  '${l10n.totalExpenses}: \$${(_reportData['summary']!['totalExpenses'] as double).toStringAsFixed(2)}',
  style: TextStyle(
    fontSize: 14,
    color: AppColors.getSecondaryTextColor(context),
  ),
),
                const SizedBox(height: 8),
                Text(
                  '${l10n.categoriesAnalyzed}: ${_reportData['categories'].length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.getSecondaryTextColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadPDF(AppLocalizations l10n) async {
    setState(() => _isGeneratingPDF = true);
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Financial Insights Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Summary',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
            pw.Bullet(
  text:
      '${l10n.totalExpenses}: \$${(_reportData['summary']!['totalExpenses'] as double).toStringAsFixed(2)}',
),
pw.Bullet(
  text:
      'Monthly Average: \$${(_reportData['summary']!['monthlyAverage'] as double).toStringAsFixed(2)}',
),
pw.Bullet(
  text: '${l10n.topCategory}: ${_reportData['summary']!['topCategory']}',
),
              pw.SizedBox(height: 20),
              pw.Text(
                'Insights',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              ..._reportData['insights'].map<pw.Widget>((insight) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        insight['title'],
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(insight['description']),
                      pw.Text(
                        'Recommendation: ${insight['recommendation']}',
                        style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
                      ),
                    ],
                  ),
                );
              }).toList(),
              pw.SizedBox(height: 20),
              pw.Text(
                'Predictions',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              ..._reportData['predictions'].map<pw.Widget>((prediction) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        prediction['title'],
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                     pw.Text(
  '\$${prediction['amount'].toStringAsFixed(2)} (${prediction['confidence']}% confidence)',
),
                      pw.Text(prediction['description']),
                    ],
                  ),
                );
              }).toList(),
            ];
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/financial_insights.pdf');
      await file.writeAsBytes(await pdf.save());

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'financial_insights.pdf',
      );
    } catch (e) {
      _showErrorDialog('Failed to generate PDF: $e');
    } finally {
      setState(() => _isGeneratingPDF = false);
    }
  }

  Future<void> _shareReport(AppLocalizations l10n) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Financial Insights Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Summary',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          pw.Bullet(
  text:
      '${l10n.totalExpenses}: \$${(_reportData['summary']!['totalExpenses'] as double).toStringAsFixed(2)}',
),
pw.Bullet(
  text:
      'Monthly Average: \$${(_reportData['summary']!['monthlyAverage'] as double).toStringAsFixed(2)}',
),
            pw.Bullet(
              text: '${l10n.topCategory}: ${_reportData['summary']['topCategory']}',
            ),
          ],
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/financial_insights_share.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Check out my financial insights report!');
    } catch (e) {
      _showErrorDialog('Failed to share report: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }
}