import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  // ==========================================================
  // NAVIGATION
  // ==========================================================

  int selectedIndex = 2;

  // ==========================================================
  // ADD BUTTON ANIMATION
  // ==========================================================

  late AnimationController _addButtonController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _moveAnimation;

  // ==========================================================
  // TRANSACTIONS
  // ==========================================================

  final List<HistoryTransaction> transactions = [
    HistoryTransaction(
      id: '1',
      name: 'Uber',
      date: DateTime.now(),
      amount: -21,
    ),
    HistoryTransaction(
      id: '2',
      name: 'General Store',
      date: DateTime.now(),
      amount: 9,
    ),
    HistoryTransaction(
      id: '3',
      name: 'General Store',
      date: DateTime.now(),
      amount: 9,
    ),
    HistoryTransaction(
      id: '4',
      name: 'General Store',
      date: DateTime.now(),
      amount: -9,
    ),
    HistoryTransaction(
      id: '5',
      name: 'General Store',
      date: DateTime.now(),
      amount: 9,
    ),
    HistoryTransaction(
      id: '6',
      name: 'General Store',
      date: DateTime.now().subtract(
        const Duration(days: 1),
      ),
      amount: 9,
    ),
    HistoryTransaction(
      id: '7',
      name: 'General Store',
      date: DateTime.now().subtract(
        const Duration(days: 5),
      ),
      amount: 9,
    ),
    HistoryTransaction(
      id: '8',
      name: 'General Store',
      date: DateTime.now().subtract(
        const Duration(days: 10),
      ),
      amount: 9,
    ),
  ];

  // ==========================================================
  // SELECTED TRANSACTIONS
  // ==========================================================

  final Set<String> selectedTransactions = {};

  bool get allSelected {
    return transactions.isNotEmpty &&
        selectedTransactions.length == transactions.length;
  }

  bool get hasSelection {
    return selectedTransactions.isNotEmpty;
  }

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    _addButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.0,
            end: 1.12,
          ).chain(
            CurveTween(
              curve: Curves.easeOut,
            ),
          ),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.12,
            end: 0.95,
          ).chain(
            CurveTween(
              curve: Curves.easeInOut,
            ),
          ),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.95,
            end: 1.0,
          ).chain(
            CurveTween(
              curve: Curves.elasticOut,
            ),
          ),
          weight: 45,
        ),
      ],
    ).animate(_addButtonController);

    _moveAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0,
            end: -14,
          ).chain(
            CurveTween(
              curve: Curves.easeOut,
            ),
          ),
          weight: 30,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: -14,
            end: 5,
          ).chain(
            CurveTween(
              curve: Curves.easeInOut,
            ),
          ),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 5,
            end: 0,
          ).chain(
            CurveTween(
              curve: Curves.elasticOut,
            ),
          ),
          weight: 45,
        ),
      ],
    ).animate(_addButtonController);
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _addButtonController.dispose();
    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1DDD8),

      // ======================================================
      // TOP BAR
      // ======================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black26,
        automaticallyImplyLeading: true,

        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),

        actions: [
          if (hasSelection)
            IconButton(
              onPressed: _deleteSelectedTransactions,
              icon: const Icon(
                Icons.delete_outline,
                color: Color(0xFFFF1616),
                size: 25,
              ),
            ),
        ],
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: SafeArea(
        child: transactions.isEmpty
            ? _buildEmptyState()
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  19,
                  31,
                  19,
                  115,
                ),
                children: [
                  _buildTransactionsHeader(),

                  const SizedBox(height: 12),

                  ...transactions.map(
                    (transaction) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 9,
                        ),
                        child: _buildTransactionCard(
                          transaction,
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),

      // ======================================================
      // ADD BUTTON
      // ======================================================

      floatingActionButton: _buildAddButton(),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      // ======================================================
      // BOTTOM BAR
      // ======================================================

      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ==========================================================
  // TRANSACTIONS HEADER
  // ==========================================================

  Widget _buildTransactionsHeader() {
    return Row(
      children: [
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 0),
            child: Text(
              'Transactions',
              style: TextStyle(
                color: Colors.black,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),

        // Select all checkbox
        GestureDetector(
          onTap: _toggleSelectAll,
          child: SizedBox(
            width: 34,
            height: 34,
            child: Checkbox(
              value: allSelected,
              tristate: false,
              onChanged: (_) {
                _toggleSelectAll();
              },
              activeColor: const Color(0xFF0878EE),
              checkColor: Colors.white,
              side: const BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // TRANSACTION CARD
  // ==========================================================

  Widget _buildTransactionCard(
    HistoryTransaction transaction,
  ) {
    final bool isIncoming = transaction.amount >= 0;
    final bool isSelected =
        selectedTransactions.contains(transaction.id);

    return GestureDetector(
      onLongPress: () {
        _showTransactionOptions(transaction);
      },
      onTap: () {
        if (hasSelection) {
          _toggleTransactionSelection(transaction.id);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        height: 76,
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE7F1FF)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(
                  color: const Color(0xFF0878EE),
                  width: 2,
                )
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _formatTransactionDate(
                      transaction.date,
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              '${isIncoming ? '+' : '-'}\$${transaction.amount.abs().toStringAsFixed(0)}',
              style: TextStyle(
                color: isIncoming
                    ? const Color(0xFF087A14)
                    : const Color(0xFFFF1616),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // DATE FORMATTER
  // ==========================================================

  String _formatTransactionDate(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final transactionDay = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final difference =
        today.difference(transactionDay).inDays;

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Yesterday';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]}';
  }

  // ==========================================================
  // SELECT / DESELECT TRANSACTION
  // ==========================================================

  void _toggleTransactionSelection(String id) {
    setState(() {
      if (selectedTransactions.contains(id)) {
        selectedTransactions.remove(id);
      } else {
        selectedTransactions.add(id);
      }
    });
  }

  // ==========================================================
  // SELECT ALL
  // ==========================================================

  void _toggleSelectAll() {
    setState(() {
      if (allSelected) {
        selectedTransactions.clear();
      } else {
        selectedTransactions.clear();

        for (final transaction in transactions) {
          selectedTransactions.add(transaction.id);
        }
      }
    });
  }

  // ==========================================================
  // LONG PRESS OPTIONS
  // ==========================================================

  void _showTransactionOptions(
    HistoryTransaction transaction,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 18),

                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFFF1616),
                  ),
                  title: const Text(
                    'Delete transaction',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    _deleteSingleTransaction(
                      transaction,
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  title: const Text('Cancel'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // DELETE SINGLE TRANSACTION
  // ==========================================================

  Future<void> _deleteSingleTransaction(
    HistoryTransaction transaction,
  ) async {
    final bool? shouldDelete =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete transaction?',
          ),
          content: Text(
            'Delete "${transaction.name}" from your history?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Color(0xFFFF1616),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      setState(() {
        transactions.removeWhere(
          (item) => item.id == transaction.id,
        );

        selectedTransactions.remove(
          transaction.id,
        );
      });
    }
  }

  // ==========================================================
  // DELETE SELECTED
  // ==========================================================

  Future<void> _deleteSelectedTransactions() async {
    if (!hasSelection) return;

    final int count = selectedTransactions.length;

    final bool? shouldDelete =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete transactions?',
          ),
          content: Text(
            'Delete $count selected transaction${count == 1 ? '' : 's'}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Color(0xFFFF1616),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      setState(() {
        transactions.removeWhere(
          (transaction) =>
              selectedTransactions.contains(
            transaction.id,
          ),
        );

        selectedTransactions.clear();
      });
    }
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 60,
            color: Colors.black38,
          ),

          SizedBox(height: 15),

          Text(
            'No transactions yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ANIMATED PLUS BUTTON
  // ==========================================================

  Widget _buildAddButton() {
    return AnimatedBuilder(
      animation: _addButtonController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            _moveAnimation.value,
          ),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () async {
          await _addButtonController.forward(
            from: 0,
          );

          // Expense logging screen will be connected here.
        },
        child: Container(
          width: 108,
          height: 108,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0878EE),
            border: Border.all(
              color: const Color(0xFFE1DDD8),
              width: 9,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.18,
                ),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 42,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

  Widget _buildBottomBar() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFF0878EE),
            width: 5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.home_filled,
            index: 0,
          ),

          _buildNavItem(
            icon: Icons.calculate_outlined,
            index: 1,
          ),

          const SizedBox(width: 75),

          _buildNavItem(
            icon: Icons.history,
            index: 2,
          ),

          _buildNavItem(
            icon: Icons.person_outline,
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
  }) {
    return IconButton(
      onPressed: () {
        setState(() {
          selectedIndex = index;
        });
      },
      icon: Icon(
        icon,
        size: 27,
        color: const Color(0xFF0878EE),
      ),
    );
  }
}

// ============================================================
// TRANSACTION MODEL
// ============================================================

class HistoryTransaction {
  final String id;
  final String name;
  final DateTime date;
  final double amount;

  const HistoryTransaction({
    required this.id,
    required this.name,
    required this.date,
    required this.amount,
  });
}