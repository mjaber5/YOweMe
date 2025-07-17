// lib/services/gemini_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yoweme/model/expense.dart';
import 'package:yoweme/model/user.dart';

class GeminiService {
  static GenerativeModel? _model;

  static void initialize() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey != null) {
      _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    }
  }

  // Generate spending insights
  static Future<Map<String, dynamic>> generateSpendingInsights(
    List<Expense> expenses,
    User currentUser,
    List<User> friends,
  ) async {
    if (_model == null) throw Exception('Gemini not initialized');

    final expenseData = expenses
        .map(
          (e) => {
            'amount': e.amount,
            'category': e.category,
            'date': e.createdAt.toIso8601String(),
            'participants': e.participants.length,
          },
        )
        .toList();

    final prompt =
        '''
    Analyze this expense data and provide insights in JSON format:
    
    Expenses: ${expenseData.toString()}
    Current User: ${currentUser.name}
    Friends: ${friends.map((f) => f.name).toList()}
    
    Please provide:
    1. Monthly spending trend
    2. Top spending categories
    3. Most frequent expense partners
    4. Spending pattern analysis
    5. Budget recommendations
    6. Unusual spending alerts
    
    Return only valid JSON with these keys:
    - monthlyTrend: array of {month, amount}
    - topCategories: array of {category, amount, percentage}
    - frequentPartners: array of {name, frequency}
    - patterns: {description: string, insights: array}
    - recommendations: array of strings
    - alerts: array of {type, message, severity}
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);

      // Parse the JSON response
      final jsonResponse = response.text;
      if (jsonResponse != null) {
        // You might need to clean the response if it contains markdown formatting
        final cleanJson = jsonResponse
            .replaceAll('```json', '')
            .replaceAll('```', '');
        return {'success': true, 'data': cleanJson};
      }
      return {'success': false, 'error': 'No response from AI'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Predict future expenses
  static Future<Map<String, dynamic>> predictFutureExpenses(
    List<Expense> historicalExpenses,
  ) async {
    if (_model == null) throw Exception('Gemini not initialized');

    final expenseData = historicalExpenses
        .map(
          (e) => {
            'amount': e.amount,
            'category': e.category,
            'date': e.createdAt.toIso8601String(),
          },
        )
        .toList();

    final prompt =
        '''
    Based on this historical expense data, predict future spending patterns:
    
    Historical Data: ${expenseData.toString()}
    
    Provide predictions for:
    1. Next month's estimated spending by category
    2. Seasonal spending patterns
    3. Potential cost-saving opportunities
    4. Budget allocation recommendations
    
    Return only valid JSON with these keys:
    - nextMonthPrediction: {totalAmount, byCategory: [{category, amount}]}
    - seasonalPatterns: array of {season, trends}
    - costSavingTips: array of strings
    - budgetAllocation: [{category, recommendedPercentage}]
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);

      final jsonResponse = response.text;
      if (jsonResponse != null) {
        final cleanJson = jsonResponse
            .replaceAll('```json', '')
            .replaceAll('```', '');
        return {'success': true, 'data': cleanJson};
      }
      return {'success': false, 'error': 'No response from AI'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Categorize expense automatically
  static Future<String> categorizeExpense(
    String description,
    double amount,
  ) async {
    if (_model == null) throw Exception('Gemini not initialized');

    final prompt =
        '''
    Categorize this expense based on the description and amount:
    
    Description: "$description"
    Amount: \$${amount.toStringAsFixed(2)}
    
    Choose from these categories:
    - Food & Dining
    - Transportation
    - Entertainment
    - Shopping
    - Bills & Utilities
    - Travel
    - Healthcare
    - Education
    - Groceries
    - Other
    
    Return only the category name.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);

      return response.text?.trim() ?? 'Other';
    } catch (e) {
      return 'Other';
    }
  }

  // Generate settlement recommendations
  static Future<Map<String, dynamic>> generateSettlementRecommendations(
    Map<String, double> balances,
  ) async {
    if (_model == null) throw Exception('Gemini not initialized');

    final prompt =
        '''
    Optimize these debt settlements to minimize the number of transactions:
    
    Balances: ${balances.toString()}
    
    Provide the most efficient settlement plan that minimizes transactions.
    
    Return JSON with:
    - optimizedTransactions: [{from, to, amount}]
    - totalTransactions: number
    - savings: {originalTransactions, optimizedTransactions, saved}
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);

      final jsonResponse = response.text;
      if (jsonResponse != null) {
        final cleanJson = jsonResponse
            .replaceAll('```json', '')
            .replaceAll('```', '');
        return {'success': true, 'data': cleanJson};
      }
      return {'success': false, 'error': 'No response from AI'};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
