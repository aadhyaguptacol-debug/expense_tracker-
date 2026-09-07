import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = '';
  String result = '0';

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color backgroundColor = Color(0xFFE1DDD8);
  static const Color blueColor = Color(0xFF0878EE);
  static const Color navyColor = Color(0xFF061B3A);

  // ==========================================================
  // BUTTON PRESS
  // ==========================================================

  void _press(String value) {
    setState(() {
      switch (value) {
        case 'AC':
          expression = '';
          result = '0';
          break;

        case '⌫':
          if (expression.isNotEmpty) {
            expression =
                expression.substring(0, expression.length - 1);
          }
          break;

        case '=':
          _calculate();
          break;

        case '%':
          _percentage();
          break;

        default:
          expression += value;
          break;
      }
    });
  }

  // ==========================================================
  // PERCENTAGE
  // ==========================================================

  void _percentage() {
    if (expression.isEmpty) return;

    final match = RegExp(r'(\d+\.?\d*)$').firstMatch(expression);

    if (match == null) return;

    final number = double.tryParse(match.group(1)!);

    if (number == null) return;

    final percentage = number / 100;

    expression = expression.substring(0, match.start) +
        _formatNumber(percentage);
  }

  // ==========================================================
  // CALCULATE
  // ==========================================================

  void _calculate() {
    if (expression.isEmpty) return;

    try {
      final tokens = _tokenize(expression);

      if (tokens.isEmpty) return;

      final value = _evaluate(tokens);

      result = _formatNumber(value);
    } catch (_) {
      result = 'Error';
    }
  }

  // ==========================================================
  // TOKENIZE
  // ==========================================================

  List<String> _tokenize(String input) {
    final List<String> tokens = [];
    String number = '';

    for (int i = 0; i < input.length; i++) {
      final char = input[i];

      if (_isDigit(char) || char == '.') {
        number += char;
      } else if ('+-×÷'.contains(char)) {
        if (number.isNotEmpty) {
          tokens.add(number);
          number = '';
        }

        tokens.add(char);
      }
    }

    if (number.isNotEmpty) {
      tokens.add(number);
    }

    return tokens;
  }

  // ==========================================================
  // EVALUATE
  // ==========================================================

  double _evaluate(List<String> tokens) {
    final List<String> values = List.from(tokens);

    // --------------------------------------------------------
    // MULTIPLICATION / DIVISION
    // --------------------------------------------------------

    int i = 0;

    while (i < values.length) {
      if (values[i] == '×' || values[i] == '÷') {
        final double left = double.parse(values[i - 1]);
        final double right = double.parse(values[i + 1]);

        double calculated;

        if (values[i] == '×') {
          calculated = left * right;
        } else {
          if (right == 0) {
            throw Exception('Division by zero');
          }

          calculated = left / right;
        }

        values[i - 1] = _formatNumber(calculated);
        values.removeAt(i);
        values.removeAt(i);

        i--;
      }

      i++;
    }

    // --------------------------------------------------------
    // ADDITION / SUBTRACTION
    // --------------------------------------------------------

    double total = double.parse(values[0]);

    i = 1;

    while (i < values.length) {
      final operator = values[i];
      final double number = double.parse(values[i + 1]);

      if (operator == '+') {
        total += number;
      } else if (operator == '-') {
        total -= number;
      }

      i += 2;
    }

    return total;
  }

  // ==========================================================
  // DIGIT CHECK
  // ==========================================================

  bool _isDigit(String value) {
    return RegExp(r'^\d$').hasMatch(value);
  }

  // ==========================================================
  // NUMBER FORMAT
  // ==========================================================

  String _formatNumber(double value) {
    if (value.isNaN || value.isInfinite) {
      return 'Error';
    }

    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(8).replaceFirst(RegExp(r'0+$'), '');
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black26,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
            color: Colors.black,
          ),
        ),

        title: const Text(
          'Calculator',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: SafeArea(
        child: Column(
          children: [
            // --------------------------------------------------
            // DISPLAY
            // --------------------------------------------------

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  30,
                  18,
                  10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        expression.isEmpty ? '0' : expression,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 68,
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      result,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 42,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --------------------------------------------------
            // CALCULATOR BUTTONS
            // --------------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                18,
                5,
                18,
                18,
              ),
              child: _buildCalculatorGrid(),
            ),
          ],
        ),
      ),

      // ======================================================
      // BOTTOM PLUS BUTTON
      // ======================================================

      floatingActionButton: _buildAddButton(),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      // ======================================================
      // BOTTOM NAVIGATION
      // ======================================================

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ==========================================================
  // CALCULATOR GRID
  // ==========================================================

  Widget _buildCalculatorGrid() {
    return Column(
      children: [
        Row(
          children: [
            _button(
              text: 'AC',
              background: navyColor,
              textColor: Colors.white,
              onPressed: () => _press('AC'),
            ),
            _button(
              text: '( )',
              background: blueColor,
              textColor: Colors.white,
              onPressed: () {
                // Parentheses can be expanded later.
              },
            ),
            _button(
              text: '%',
              background: blueColor,
              textColor: Colors.white,
              onPressed: () => _press('%'),
            ),
            _button(
              text: '÷',
              background: blueColor,
              textColor: Colors.white,
              onPressed: () => _press('÷'),
            ),
          ],
        ),

        Row(
          children: [
            _button(
              text: '7',
              onPressed: () => _press('7'),
            ),
            _button(
              text: '8',
              onPressed: () => _press('8'),
            ),
            _button(
              text: '9',
              onPressed: () => _press('9'),
            ),
            _button(
              text: '×',
              background: blueColor,
              textColor: Colors.white,
              onPressed: () => _press('×'),
            ),
          ],
        ),

        Row(
          children: [
            _button(
              text: '4',
              onPressed: () => _press('4'),
            ),
            _button(
              text: '5',
              onPressed: () => _press('5'),
            ),
            _button(
              text: '6',
              onPressed: () => _press('6'),
            ),
            _button(
              text: '−',
              background: blueColor,
              textColor: Colors.white,
              onPressed: () => _press('-'),
            ),
          ],
        ),

        Row(
          children: [
            _button(
              text: '1',
              onPressed: () => _press('1'),
            ),
            _button(
              text: '2',
              onPressed: () => _press('2'),
            ),
            _button(
              text: '3',
              onPressed: () => _press('3'),
            ),
            _button(
              text: '+',
              background: blueColor,
              textColor: Colors.white,
              onPressed: () => _press('+'),
            ),
          ],
        ),

        Row(
          children: [
            _button(
              text: '0',
              onPressed: () => _press('0'),
            ),
            _button(
              text: '.',
              onPressed: () => _press('.'),
            ),
            _button(
              icon: Icons.backspace_outlined,
              onPressed: () => _press('⌫'),
            ),
            _button(
              text: '=',
              background: navyColor,
              textColor: Colors.white,
              onPressed: () => _press('='),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================================
  // CALCULATOR BUTTON
  // ==========================================================

  Widget _button({
    String? text,
    IconData? icon,
    Color background = Colors.white,
    Color textColor = navyColor,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: AspectRatio(
          aspectRatio: 1,
          child: Material(
            color: background,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: Center(
                child: icon != null
                    ? Icon(
                        icon,
                        size: 32,
                        color: textColor,
                      )
                    : Text(
                        text ?? '',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // ANIMATED PLUS BUTTON
  // ==========================================================

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        // Expense logging screen will be connected later.
      },
      child: Container(
        width: 108,
        height: 108,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: blueColor,
          border: Border.all(
            color: backgroundColor,
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
    );
  }

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

  Widget _buildBottomNavigation() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: blueColor,
            width: 5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home_filled),
          _navIcon(Icons.calculate_outlined),
          const SizedBox(width: 75),
          _navIcon(Icons.history),
          _navIcon(Icons.person_outline),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        icon,
        color: blueColor,
        size: 27,
      ),
    );
  }
}