import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // ==========================================================
  // NAVIGATION
  // ==========================================================

  int selectedIndex = 0;

  // ==========================================================
  // ADD BUTTON ANIMATION
  // ==========================================================

  late AnimationController _addButtonController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _moveAnimation;

  // ==========================================================
  // BUDGET
  // ==========================================================

  final double monthlyLimit = 4000;
  final double spentThisMonth = 2000;

  // ==========================================================
  // TRANSACTIONS
  // Negative = outgoing
  // Positive = incoming
  // ==========================================================

  final List<TransactionModel> transactions = [
    const TransactionModel(
      name: 'Uber',
      date: 'Today, 9:01',
      amount: -21,
    ),
    const TransactionModel(
      name: 'General Store',
      date: 'Today, 9:01',
      amount: 9,
    ),
    const TransactionModel(
      name: 'General Store',
      date: 'Today, 9:01',
      amount: 9,
    ),
    const TransactionModel(
      name: 'General Store',
      date: 'Today, 9:01',
      amount: -9,
    ),
    const TransactionModel(
      name: 'General Store',
      date: 'Today, 9:01',
      amount: 9,
    ),
  ];

  // ==========================================================
  // CALCULATED VALUES
  // ==========================================================

  double get remainingAmount {
    return monthlyLimit - spentThisMonth;
  }

  double get spentPercentage {
    if (monthlyLimit <= 0) {
      return 0;
    }

    return (spentThisMonth / monthlyLimit).clamp(0.0, 1.0);
  }

  // ==========================================================
  // INITIALIZE ANIMATION
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
  // DISPOSE ANIMATION
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
      // BODY
      // ======================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            28,
            20,
            110,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 30),

              _buildBudgetCard(),

              const SizedBox(height: 38),

              _buildTransactions(),
            ],
          ),
        ),
      ),

      // ======================================================
      // ADD BUTTON
      // ======================================================

      floatingActionButton: _buildAddButton(),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      // ======================================================
      // BOTTOM NAVIGATION
      // ======================================================

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Welcome, ',
                  style: TextStyle(
                    color: Color(0xFF0878EE),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: 'Richie hfhksj',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        GestureDetector(
          onTap: () {
            // Profile screen will be connected later.
          },
          child: const Icon(
            Icons.account_circle_outlined,
            color: Colors.black,
            size: 36,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // BUDGET CARD
  // ==========================================================

  Widget _buildBudgetCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        26,
        38,
        26,
        28,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0878EE),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: Colors.white,
          width: 7,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spent this month',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '\$${spentThisMonth.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 28),

          _buildProgressBar(),

          const SizedBox(height: 28),

          Text(
            '\$${remainingAmount.toStringAsFixed(0)} left',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PROGRESS BAR
  // ==========================================================

  Widget _buildProgressBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;
        final double redWidth = totalWidth * spentPercentage;

        return SizedBox(
          height: 5,
          child: Stack(
            children: [
              Container(
                width: totalWidth,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                width: redWidth,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF2020),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================
  // TRANSACTIONS
  // ==========================================================

  Widget _buildTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            'Transactions',
            style: TextStyle(
              color: Colors.black,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(height: 16),

        ...transactions.map(
          (transaction) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: _buildTransactionCard(transaction),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // TRANSACTION CARD
  // ==========================================================

  Widget _buildTransactionCard(
    TransactionModel transaction,
  ) {
    final bool isIncoming = transaction.amount >= 0;

    return Container(
      width: double.infinity,
      height: 76,
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  transaction.date,
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
          // Run pop / bounce animation.
          await _addButtonController.forward(from: 0);

          // Expense logging screen will be connected later.
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
                color: Colors.black.withOpacity(0.18),
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
  // BOTTOM NAVIGATION BAR
  // ==========================================================

  Widget _buildBottomNavigationBar() {
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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

  // ==========================================================
  // NAVIGATION ITEM
  // ==========================================================

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

class TransactionModel {
  final String name;
  final String date;
  final double amount;

  const TransactionModel({
    required this.name,
    required this.date,
    required this.amount,
  });
}