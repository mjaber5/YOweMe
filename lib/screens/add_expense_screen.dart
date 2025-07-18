// lib/screens/add_expense_screen.dart (Updated with theme support)
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../core/utils/constants/colors.dart';
import '../services/gemini_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedCategory = 'Food & Dining';
  List<String> _selectedFriends = [];
  bool _isAIProcessing = false;
  XFile? _receiptImage;

  final List<String> _categories = [
    'Food & Dining',
    'Transportation',
    'Entertainment',
    'Shopping',
    'Bills & Utilities',
    'Travel',
    'Healthcare',
    'Education',
    'Groceries',
    'Other',
  ];

  final List<Map<String, dynamic>> _mockFriends = [
    {'id': '1', 'name': 'Peter', 'avatar': 'P', 'color': Colors.blue},
    {'id': '2', 'name': 'Victor', 'avatar': 'V', 'color': Colors.green},
    {'id': '3', 'name': 'Camila', 'avatar': 'C', 'color': Colors.purple},
    {'id': '4', 'name': 'Alex', 'avatar': 'A', 'color': Colors.orange},
    {'id': '5', 'name': 'Arthur', 'avatar': 'A', 'color': Colors.red},
    {'id': '6', 'name': 'Paula', 'avatar': 'P', 'color': Colors.teal},
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getCardColor(context),
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.getPrimaryTextColor(context)),
        title: Text(
          'Add Expense',
          style: TextStyle(
            color: AppColors.getPrimaryTextColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              LucideIcons.camera,
              color: AppColors.getPrimaryTextColor(context),
            ),
            onPressed: _pickReceiptImage,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Receipt Image Section
              if (_receiptImage != null) _buildReceiptImageSection(),

              // Description Field
              _buildSectionCard(
                title: 'Description',
                child: TextFormField(
                  controller: _descriptionController,
                  style: TextStyle(
                    color: AppColors.getPrimaryTextColor(context),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter expense description',
                    hintStyle: TextStyle(
                      color: AppColors.getLightTextColor(context),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.getSurfaceColor(context),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.getSurfaceColor(context),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryTeal,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.getCardColor(context),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onChanged: _onDescriptionChanged,
                ),
              ),

              const SizedBox(height: 16),

              // Amount Field
              _buildSectionCard(
                title: 'Amount',
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: AppColors.getPrimaryTextColor(context),
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    prefixText: '\$ ',
                    hintStyle: TextStyle(
                      color: AppColors.getLightTextColor(context),
                    ),
                    prefixStyle: TextStyle(
                      color: AppColors.getPrimaryTextColor(context),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.getSurfaceColor(context),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.getSurfaceColor(context),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryTeal,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.getCardColor(context),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                  onChanged: _onAmountChanged,
                ),
              ),

              const SizedBox(height: 16),

              // Category Selection
              _buildSectionCard(
                title: 'Category',
                subtitle: _isAIProcessing ? 'AI is suggesting...' : null,
                child: _buildCategorySelector(),
              ),

              const SizedBox(height: 16),

              // Split With Friends
              _buildSectionCard(
                title: 'Split with',
                subtitle: '${_selectedFriends.length} friends selected',
                child: _buildFriendsSelector(),
              ),

              const SizedBox(height: 32),

              // Split Options
              _buildSplitOptionsCard(),

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.primaryTeal),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.primaryTeal),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _addExpense,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add Expense'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
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
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
              if (_isAIProcessing && title == 'Category')
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.getSecondaryTextColor(context),
              ),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildReceiptImageSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                'Receipt Image',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
              IconButton(
                icon: Icon(
                  LucideIcons.x,
                  size: 20,
                  color: AppColors.getSecondaryTextColor(context),
                ),
                onPressed: () => setState(() => _receiptImage = null),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.getSurfaceColor(context),
              borderRadius: BorderRadius.circular(12),
              image: _receiptImage != null
                  ? DecorationImage(
                      image: NetworkImage(_receiptImage!.path),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _receiptImage == null
                ? Icon(
                    LucideIcons.image,
                    size: 40,
                    color: AppColors.getSecondaryTextColor(context),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((category) {
        final isSelected = category == _selectedCategory;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = category),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryTeal
                  : AppColors.getSurfaceColor(context),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              category,
              style: TextStyle(
                fontSize: 14,
                color: isSelected
                    ? Colors.white
                    : AppColors.getPrimaryTextColor(context),
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFriendsSelector() {
    return Column(
      children: [
        // Select All Toggle
        Row(
          children: [
            Checkbox(
              value: _selectedFriends.length == _mockFriends.length,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedFriends = _mockFriends
                        .map((f) => f['id'] as String)
                        .toList();
                  } else {
                    _selectedFriends.clear();
                  }
                });
              },
              activeColor: AppColors.primaryTeal,
            ),
            Text(
              'Select All Friends',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.getPrimaryTextColor(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Friends Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: _mockFriends.length,
          itemBuilder: (context, index) {
            final friend = _mockFriends[index];
            final isSelected = _selectedFriends.contains(friend['id']);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedFriends.remove(friend['id']);
                  } else {
                    _selectedFriends.add(friend['id']);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryTeal.withOpacity(0.1)
                      : AppColors.getSurfaceColor(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryTeal
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: friend['color'],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          friend['avatar'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      friend['name'],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.primaryTeal
                            : AppColors.getPrimaryTextColor(context),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSplitOptionsCard() {
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
            'Split Options',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.getPrimaryTextColor(context),
            ),
          ),
          const SizedBox(height: 16),

          _buildSplitOption(
            'Equal Split',
            'Split equally among all participants',
            LucideIcons.users,
            true,
          ),
          const SizedBox(height: 12),
          _buildSplitOption(
            'Custom Split',
            'Set custom amounts for each person',
            LucideIcons.calculator,
            false,
          ),
          const SizedBox(height: 12),
          _buildSplitOption(
            'Percentage Split',
            'Split by percentage',
            LucideIcons.percent,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildSplitOption(
    String title,
    String description,
    IconData icon,
    bool isSelected,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryTeal.withOpacity(0.1)
            : AppColors.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primaryTeal : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected
                ? AppColors.primaryTeal
                : AppColors.getSecondaryTextColor(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.primaryTeal
                        : AppColors.getPrimaryTextColor(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.getSecondaryTextColor(context),
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            const Icon(
              LucideIcons.check,
              color: AppColors.primaryTeal,
              size: 20,
            ),
        ],
      ),
    );
  }

  void _onDescriptionChanged(String value) {
    // Trigger AI categorization when user stops typing
    if (value.isNotEmpty && _amountController.text.isNotEmpty) {
      _suggestCategory();
    }
  }

  void _onAmountChanged(String value) {
    // Trigger AI categorization when amount is entered
    if (value.isNotEmpty && _descriptionController.text.isNotEmpty) {
      _suggestCategory();
    }
  }

  Future<void> _suggestCategory() async {
    if (_isAIProcessing) return;

    setState(() => _isAIProcessing = true);

    try {
      final description = _descriptionController.text;
      final amount = double.tryParse(_amountController.text) ?? 0.0;

      final suggestedCategory = await GeminiService.categorizeExpense(
        description,
        amount,
      );

      if (_categories.contains(suggestedCategory)) {
        setState(() {
          _selectedCategory = suggestedCategory;
          _isAIProcessing = false;
        });
      } else {
        setState(() => _isAIProcessing = false);
      }
    } catch (e) {
      setState(() => _isAIProcessing = false);
    }
  }

  Future<void> _pickReceiptImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() => _receiptImage = image);

        // Here you could also implement OCR to extract expense details from the receipt
        // using Google ML Kit or other OCR services
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to capture image')));
    }
  }

  void _addExpense() {
    if (_formKey.currentState!.validate()) {
      if (_selectedFriends.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one friend')),
        );
        return;
      }

      // Here you would save the expense to your backend/database
      // For now, just show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully!')),
      );

      Navigator.pop(context);
    }
  }
}
