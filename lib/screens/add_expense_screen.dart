// lib/screens/add_expense_screen.dart (Enhanced Professional Version with Transaction Preview)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../core/utils/constants/colors.dart';
import '../services/gemini_service.dart';
import 'expense_detail_screen.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  late AnimationController _previewAnimationController;
  late AnimationController _formAnimationController;

  String _selectedSplitOption = 'Equal Split';
  String _selectedCategory = 'Food & Dining';
  List<String> _selectedFriends = [];
  bool _isAIProcessing = false;
  bool _showPreview = false;
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
    {
      'id': '1',
      'name': 'Peter Clarkson',
      'email': 'peter.clarkson@example.com',
      'avatar':
          'https://api.dicebear.com/7.x/avataaars/png?seed=Peter&backgroundColor=4285F4',
      'isOnline': true,
    },
    {
      'id': '2',
      'name': 'Victor Martinez',
      'email': 'victor.martinez@example.com',
      'avatar':
          'https://api.dicebear.com/7.x/avataaars/png?seed=Victor&backgroundColor=34A853',
      'isOnline': false,
    },
    {
      'id': '3',
      'name': 'Camila Rodriguez',
      'email': 'camila.rodriguez@example.com',
      'avatar':
          'https://api.dicebear.com/7.x/avataaars/png?seed=Camila&backgroundColor=9C27B0',
      'isOnline': true,
    },
    {
      'id': '4',
      'name': 'Alexander Thompson',
      'email': 'alex.thompson@example.com',
      'avatar':
          'https://api.dicebear.com/7.x/avataaars/png?seed=Alex&backgroundColor=FF9800',
      'isOnline': true,
    },
    {
      'id': '5',
      'name': 'Arthur Williams',
      'email': 'arthur.williams@example.com',
      'avatar':
          'https://api.dicebear.com/7.x/avataaars/png?seed=Arthur&backgroundColor=F44336',
      'isOnline': false,
    },
    {
      'id': '6',
      'name': 'Paula Anderson',
      'email': 'paula.anderson@example.com',
      'avatar':
          'https://api.dicebear.com/7.x/avataaars/png?seed=Paula&backgroundColor=00BCD4',
      'isOnline': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _previewAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Start with form visible
    // Don't auto-forward the animation
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _previewAnimationController.dispose();
    _formAnimationController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _descriptionController.clear();
      _amountController.clear();
      _notesController.clear();
      _selectedCategory = 'Food & Dining';
      _selectedFriends.clear();
      _selectedSplitOption = 'Equal Split';
      _receiptImage = null;
      _isAIProcessing = false;
      _showPreview = false;
    });
  }

  void _showTransactionPreview() {
    if (_formKey.currentState!.validate() && _selectedFriends.isNotEmpty) {
      setState(() => _showPreview = true);
      HapticFeedback.mediumImpact();
    } else if (_selectedFriends.isEmpty) {
      _showFriendsError();
    }
  }

  void _goBackToForm() {
    setState(() => _showPreview = false);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SafeArea(
        child: _showPreview ? _buildPreviewView() : _buildFormView(),
      ),
    );
  }

  Widget _buildFormView() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        LucideIcons.x,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const Text(
                    'Add Expense',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: _pickReceiptImage,
                      icon: const Icon(
                        LucideIcons.camera,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.plus, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        const Text(
                          'New Transaction',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (_selectedFriends.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_selectedFriends.length + 1} people',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        // Form Content
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (_receiptImage != null) _buildReceiptImageSection(),
                  _buildAmountSection(),
                  const SizedBox(height: 20),
                  _buildDescriptionSection(),
                  const SizedBox(height: 20),
                  _buildCategorySection(),
                  const SizedBox(height: 20),
                  _buildFriendsSelectionCard(),
                  const SizedBox(height: 20),
                  _buildSplitOptionsCard(),
                  const SizedBox(height: 20),
                  _buildNotesSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),

        // Bottom Actions
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.getCardColor(context),
            border: Border(
              top: BorderSide(
                color: AppColors.getSecondaryTextColor(
                  context,
                ).withOpacity(0.1),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _resetForm();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: AppColors.getSecondaryTextColor(context),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: AppColors.getSecondaryTextColor(context),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _showTransactionPreview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.eye, size: 18),
                      const SizedBox(width: 8),
                      const Text('Preview Transaction'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewView() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final splitAmount = amount / (_selectedFriends.length + 1);

    return Container(
      color: AppColors.getBackgroundColor(context),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: _goBackToForm,
                        icon: const Icon(
                          LucideIcons.arrowLeft,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Text(
                      'Transaction Preview',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => _showMoreOptions(),
                        icon: const Icon(
                          LucideIcons.moreVertical,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '#EXP${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Pending',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _descriptionController.text.isEmpty
                      ? 'Expense Description'
                      : _descriptionController.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Split between ${_selectedFriends.length + 1} people',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Preview Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildPreviewOverviewCard(amount, splitAmount),
                  const SizedBox(height: 20),
                  _buildPreviewDetailsCard(),
                  const SizedBox(height: 20),
                  _buildPreviewParticipantsCard(splitAmount),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Confirm Actions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.getCardColor(context),
              border: Border(
                top: BorderSide(
                  color: AppColors.getSecondaryTextColor(
                    context,
                  ).withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _goBackToForm,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.primaryTeal),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: AppColors.primaryTeal),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _confirmAddExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.check, size: 18),
                        const SizedBox(width: 8),
                        const Text('Confirm & Add'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewOverviewCard(double amount, double splitAmount) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowLight(context),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.getSecondaryTextColor(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'JOD ${amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTeal,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _getCategoryIcon(_selectedCategory),
                  size: 32,
                  color: AppColors.primaryTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.getSurfaceColor(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildOverviewItem(
                    'Per Person',
                    'JOD ${splitAmount.toStringAsFixed(2)}',
                    LucideIcons.users,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.getSecondaryTextColor(
                    context,
                  ).withOpacity(0.2),
                ),
                Expanded(
                  child: _buildOverviewItem(
                    'Split Type',
                    _selectedSplitOption,
                    LucideIcons.calculator,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(20),
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
                LucideIcons.fileText,
                size: 20,
                color: AppColors.primaryTeal,
              ),
              const SizedBox(width: 12),
              Text(
                'Transaction Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDetailRow('Paid by', 'You', LucideIcons.creditCard),
          const SizedBox(height: 16),
          _buildDetailRow(
            'Date',
            _formatDate(DateTime.now()),
            LucideIcons.calendar,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'Category',
            _selectedCategory,
            _getCategoryIcon(_selectedCategory),
          ),
          if (_notesController.text.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildDetailRow(
              'Notes',
              _notesController.text,
              LucideIcons.messageSquare,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewParticipantsCard(double splitAmount) {
    final allParticipants = [
      {
        'name': 'You',
        'email': 'you@example.com',
        'amount': splitAmount,
        'avatar': 'Y',
        'color': AppColors.primaryTeal,
        'paid': true,
      },
      ..._selectedFriends.map((friendId) {
        final friend = _mockFriends.firstWhere((f) => f['id'] == friendId);
        return {
          'name': friend['name'],
          'email': friend['email'],
          'amount': splitAmount,
          'avatar': friend['name'].toString().substring(0, 1).toUpperCase(),
          'color': AppColors.primaryTeal,
          'paid': false,
        };
      }).toList(),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(20),
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
              Row(
                children: [
                  Icon(
                    LucideIcons.users,
                    size: 20,
                    color: AppColors.primaryTeal,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Participants',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getPrimaryTextColor(context),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${allParticipants.length} people',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...allParticipants.asMap().entries.map((entry) {
            final index = entry.key;
            final participant = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == allParticipants.length - 1 ? 0 : 16,
              ),
              child: _buildPreviewParticipantRow(participant),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPreviewParticipantRow(Map<String, dynamic> participant) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: participant['paid']
            ? AppColors.positiveGreen.withOpacity(0.05)
            : AppColors.negativeRed.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: participant['paid']
              ? AppColors.positiveGreen.withOpacity(0.2)
              : AppColors.negativeRed.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: participant['color'],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                participant['avatar'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getPrimaryTextColor(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  participant['email'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.getSecondaryTextColor(context),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: participant['paid']
                        ? AppColors.positiveGreen.withOpacity(0.2)
                        : AppColors.negativeRed.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    participant['paid'] ? 'Will Pay' : 'Owes',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: participant['paid']
                          ? AppColors.positiveGreen
                          : AppColors.negativeRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'JOD ${participant['amount'].toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.getPrimaryTextColor(context),
            ),
          ),
        ],
      ),
    );
  }

  // Form sections (keeping existing implementations but enhanced)
  Widget _buildAmountSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(20),
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
                child: Icon(
                  LucideIcons.dollarSign,
                  size: 16,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.getPrimaryTextColor(context),
            ),
            decoration: InputDecoration(
              hintText: '0.00',
              prefixText: 'JOD ',
              hintStyle: TextStyle(
                color: AppColors.getLightTextColor(context),
                fontSize: 32,
              ),
              prefixStyle: TextStyle(
                color: AppColors.primaryTeal,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
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
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(20),
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
                child: Icon(
                  LucideIcons.type,
                  size: 16,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _descriptionController,
            style: TextStyle(
              color: AppColors.getPrimaryTextColor(context),
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'What was this expense for?',
              hintStyle: TextStyle(color: AppColors.getLightTextColor(context)),
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
              fillColor: AppColors.getSurfaceColor(context),
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
            onChanged: _onDescriptionChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(20),
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
                child: Icon(
                  _getCategoryIcon(_selectedCategory),
                  size: 16,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
              if (_isAIProcessing)
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
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((category) {
              final isSelected = category == _selectedCategory;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedCategory = category);
                  HapticFeedback.selectionClick();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryTeal
                        : AppColors.getSurfaceColor(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryTeal
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : AppColors.getPrimaryTextColor(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected
                              ? Colors.white
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
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(20),
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
                child: Icon(
                  LucideIcons.messageSquare,
                  size: 16,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Notes (Optional)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            style: TextStyle(
              color: AppColors.getPrimaryTextColor(context),
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Add any additional notes...',
              hintStyle: TextStyle(color: AppColors.getLightTextColor(context)),
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
              fillColor: AppColors.getSurfaceColor(context),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  // Keep existing implementations for other sections with minor enhancements
  Widget _buildReceiptImageSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(20),
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      LucideIcons.image,
                      size: 16,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Receipt Image',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getPrimaryTextColor(context),
                    ),
                  ),
                ],
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
          const SizedBox(height: 20),
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

  Widget _buildFriendsSelectionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(20),
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
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        LucideIcons.users,
                        size: 16,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Split with Friends',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getPrimaryTextColor(context),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_selectedFriends.length} selected',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Selected Friends Preview
          if (_selectedFriends.isNotEmpty) ...[
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedFriends.length > 5
                    ? 5
                    : _selectedFriends.length,
                itemBuilder: (context, index) {
                  if (index == 4 && _selectedFriends.length > 5) {
                    return Container(
                      width: 48,
                      height: 48,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.getSurfaceColor(context),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.primaryTeal.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '+${_selectedFriends.length - 4}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ),
                    );
                  }

                  final friendId = _selectedFriends[index];
                  final friend = _mockFriends.firstWhere(
                    (f) => f['id'] == friendId,
                  );

                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.primaryTeal,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.network(
                          friend['avatar'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.getSurfaceColor(context),
                              child: Icon(
                                LucideIcons.user,
                                color: AppColors.getSecondaryTextColor(context),
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Add Friends Button
          GestureDetector(
            onTap: _showFriendsBottomSheet,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryTeal.withOpacity(0.3),
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primaryTeal.withOpacity(0.05),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _selectedFriends.isEmpty
                        ? LucideIcons.userPlus
                        : LucideIcons.users,
                    color: AppColors.primaryTeal,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedFriends.isEmpty
                        ? 'Select Friends'
                        : 'Manage Friends',
                    style: const TextStyle(
                      color: AppColors.primaryTeal,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
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

  Widget _buildSplitOptionsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(20),
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
                child: Icon(
                  LucideIcons.calculator,
                  size: 16,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Split Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSplitOption(
            title: 'Equal Split',
            subtitle: 'Split equally among all participants',
            icon: LucideIcons.users,
          ),
          const SizedBox(height: 12),
          _buildSplitOption(
            title: 'Custom Split',
            subtitle: 'Set custom amounts for each person',
            icon: LucideIcons.calculator,
          ),
          const SizedBox(height: 12),
          _buildSplitOption(
            title: 'Percentage Split',
            subtitle: 'Split by percentage',
            icon: LucideIcons.percent,
          ),
        ],
      ),
    );
  }

  Widget _buildSplitOption({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedSplitOption == title;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedSplitOption = title);
        HapticFeedback.selectionClick();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryTeal.withOpacity(0.1)
              : AppColors.getSurfaceColor(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primaryTeal
                  : AppColors.getPrimaryTextColor(context),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isSelected
                          ? AppColors.primaryTeal
                          : AppColors.getPrimaryTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.getSecondaryTextColor(context),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryTeal,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Widget _buildOverviewItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryTeal),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.getSecondaryTextColor(context),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.getPrimaryTextColor(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.primaryTeal),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.getSecondaryTextColor(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getPrimaryTextColor(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
      case 'groceries':
        return LucideIcons.utensils;
      case 'transportation':
        return LucideIcons.car;
      case 'entertainment':
        return LucideIcons.film;
      case 'shopping':
        return LucideIcons.shoppingBag;
      case 'bills & utilities':
        return LucideIcons.receipt;
      case 'travel':
        return LucideIcons.plane;
      case 'healthcare':
        return LucideIcons.heart;
      case 'education':
        return LucideIcons.graduationCap;
      default:
        return LucideIcons.tag;
    }
  }

  void _onDescriptionChanged(String value) {
    if (value.isNotEmpty && _amountController.text.isNotEmpty) {
      _suggestCategory();
    }
  }

  void _onAmountChanged(String value) {
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
        HapticFeedback.mediumImpact();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to capture image');
    }
  }

  void _showFriendsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: AppColors.getCardColor(context),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.getSecondaryTextColor(
                      context,
                    ).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Friends',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getPrimaryTextColor(context),
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                if (_selectedFriends.length ==
                                    _mockFriends.length) {
                                  _selectedFriends.clear();
                                } else {
                                  _selectedFriends = _mockFriends
                                      .map((f) => f['id'] as String)
                                      .toList();
                                }
                              });
                              setState(() {});
                            },
                            child: Text(
                              _selectedFriends.length == _mockFriends.length
                                  ? 'Deselect All'
                                  : 'Select All',
                              style: const TextStyle(
                                color: AppColors.primaryTeal,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              LucideIcons.x,
                              color: AppColors.getSecondaryTextColor(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _mockFriends.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final friend = _mockFriends[index];
                      final isSelected = _selectedFriends.contains(
                        friend['id'],
                      );

                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setModalState(() {
                            if (isSelected) {
                              _selectedFriends.remove(friend['id']);
                            } else {
                              _selectedFriends.add(friend['id']);
                            }
                          });
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryTeal.withOpacity(0.1)
                                : AppColors.getSurfaceColor(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryTeal
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primaryTeal
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(26),
                                      child: Image.network(
                                        friend['avatar'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: AppColors.getSurfaceColor(
                                              context,
                                            ),
                                            child: Icon(
                                              LucideIcons.user,
                                              color:
                                                  AppColors.getSecondaryTextColor(
                                                    context,
                                                  ),
                                              size: 28,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  if (friend['isOnline'])
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: AppColors.positiveGreen,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppColors.getCardColor(
                                              context,
                                            ),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      friend['name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? AppColors.primaryTeal
                                            : AppColors.getPrimaryTextColor(
                                                context,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      friend['email'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.getSecondaryTextColor(
                                          context,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: friend['isOnline']
                                                ? AppColors.positiveGreen
                                                : AppColors.getSecondaryTextColor(
                                                    context,
                                                  ).withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          friend['isOnline']
                                              ? 'Online'
                                              : 'Offline',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: friend['isOnline']
                                                ? AppColors.positiveGreen
                                                : AppColors.getSecondaryTextColor(
                                                    context,
                                                  ),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryTeal
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryTeal
                                        : AppColors.getSecondaryTextColor(
                                            context,
                                          ).withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.getCardColor(context),
                    border: Border(
                      top: BorderSide(
                        color: AppColors.getSecondaryTextColor(
                          context,
                        ).withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_selectedFriends.length} friends selected',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.getPrimaryTextColor(context),
                              ),
                            ),
                            if (_selectedFriends.isNotEmpty &&
                                _amountController.text.isNotEmpty)
                              Text(
                                'Split: JOD ${_calculateSplitAmount().toStringAsFixed(2)} per person',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.getSecondaryTextColor(
                                    context,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _selectedFriends.isNotEmpty
                            ? () => Navigator.pop(context)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryTeal,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              AppColors.getSecondaryTextColor(
                                context,
                              ).withOpacity(0.3),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.getCardColor(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.getSecondaryTextColor(
                  context,
                ).withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Transaction Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.getPrimaryTextColor(context),
              ),
            ),
            const SizedBox(height: 24),
            _buildOption(
              icon: LucideIcons.share2,
              title: 'Share Preview',
              subtitle: 'Share transaction details with friends',
              onTap: () => Navigator.pop(context),
            ),
            _buildOption(
              icon: LucideIcons.download,
              title: 'Save as Draft',
              subtitle: 'Save this expense as a draft',
              onTap: () => Navigator.pop(context),
            ),
            _buildOption(
              icon: LucideIcons.copy,
              title: 'Duplicate Expense',
              subtitle: 'Create a similar expense quickly',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.getSecondaryTextColor(
                  context,
                ).withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primaryTeal, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.getPrimaryTextColor(context),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.getSecondaryTextColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.getSecondaryTextColor(context),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateSplitAmount() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final totalPeople = _selectedFriends.length + 1;
    return totalPeople > 0 ? amount / totalPeople : 0.0;
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void _showFriendsError() {
    _showErrorSnackBar('Please select at least one friend');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.alertCircle, color: Colors.white, size: 10),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.negativeRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _confirmAddExpense() {
    HapticFeedback.mediumImpact();

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final splitAmount = _calculateSplitAmount();

    // Create the expense data
    final expenseData = {
      'id':
          '#EXP${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      'description': _descriptionController.text,
      'amount': amount,
      'category': _selectedCategory,
      'friends': _selectedFriends,
      'splitOption': _selectedSplitOption,
      'notes': _notesController.text,
      'receiptImage': _receiptImage,
      'splitAmount': splitAmount,
      'timestamp': DateTime.now(),
      'paidBy': 'You',
      'status': 'Pending',
      'participants': [
        'You',
        ..._selectedFriends.map(
          (id) => _mockFriends.firstWhere((f) => f['id'] == id)['name'],
        ),
      ],
    };

    // Show success animation first
    _showSuccessDialog(expenseData);
  }

  void _showSuccessDialog(Map<String, dynamic> expenseData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.getCardColor(context),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.getShadowLight(context),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Animation
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.positiveGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  LucideIcons.checkCircle,
                  size: 40,
                  color: AppColors.positiveGreen,
                ),
              ),
              const SizedBox(height: 24),

              // Success Title
              Text(
                'Transaction Created!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getPrimaryTextColor(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Transaction Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.getSurfaceColor(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount:',
                          style: TextStyle(
                            color: AppColors.getSecondaryTextColor(context),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'JOD ${expenseData['amount'].toStringAsFixed(2)}',
                          style: TextStyle(
                            color: AppColors.getPrimaryTextColor(context),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Split between:',
                          style: TextStyle(
                            color: AppColors.getSecondaryTextColor(context),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${expenseData['participants'].length} people',
                          style: TextStyle(
                            color: AppColors.getPrimaryTextColor(context),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Per person:',
                          style: TextStyle(
                            color: AppColors.getSecondaryTextColor(context),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'JOD ${expenseData['splitAmount'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.primaryTeal,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to main screen
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: AppColors.getSecondaryTextColor(context),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: AppColors.getSecondaryTextColor(context),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        _navigateToExpenseDetail(expenseData);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('View Details'),
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

  void _navigateToExpenseDetail(Map<String, dynamic> expenseData) {
    // Navigate to expense detail screen with the created expense data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseDetailScreen(
          expenseId: expenseData['id'],
          description: expenseData['description'],
          amount: expenseData['amount'],
          paidBy: expenseData['paidBy'],
          participants: List<String>.from(expenseData['participants']),
          category: expenseData['category'],
          createdDate: expenseData['timestamp'],
          status: expenseData['status'],
        ),
      ),
    );
  }
}
