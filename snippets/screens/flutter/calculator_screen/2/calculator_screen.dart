import 'package:flutter/material.dart';
import 'dart:math';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _previousValue = '';
  String _operation = '';
  bool _userIsTyping = false;
  bool _showHistory = false;
  List<String> _history = [];

  void _numberPressed(String number) {
    setState(() {
      if (_userIsTyping) {
        if (_display.length < 12) {
          _display = _display == '0' ? number : _display + number;
        }
      } else {
        _display = number;
        _userIsTyping = true;
      }
    });
  }

  void _decimalPressed() {
    if (!_display.contains('.') && _userIsTyping) {
      setState(() {
        _display += '.';
      });
    } else if (!_userIsTyping) {
      setState(() {
        _display = '0.';
        _userIsTyping = true;
      });
    }
  }

  void _operationPressed(String operation) {
    if (_previousValue.isNotEmpty && _operation.isNotEmpty && _userIsTyping) {
      _calculateResult();
    }

    setState(() {
      _previousValue = _display;
      _operation = operation;
      _userIsTyping = false;
    });
  }

  void _calculateResult() {
    if (_previousValue.isEmpty || _operation.isEmpty) return;

    double prev = double.tryParse(_previousValue) ?? 0;
    double current = double.tryParse(_display) ?? 0;
    double result = 0;

    String calculation = '$_previousValue $_operation $_display';

    switch (_operation) {
      case '+':
        result = prev + current;
        break;
      case '-':
        result = prev - current;
        break;
      case '×':
        result = prev * current;
        break;
      case '÷':
        if (current != 0) {
          result = prev / current;
        } else {
          _showError('Cannot divide by zero');
          return;
        }
        break;
      case '%':
        result = prev % current;
        break;
      case '^':
        result = pow(prev, current).toDouble();
        break;
    }

    setState(() {
      _display = _formatResult(result);
      _history.insert(0, '$calculation = ${_formatResult(result)}');
      if (_history.length > 50) {
        _history = _history.take(50).toList();
      }
      _previousValue = '';
      _operation = '';
      _userIsTyping = false;
    });
  }

  void _equalsPressed() {
    _calculateResult();
  }

  void _clearPressed() {
    setState(() {
      _display = '0';
      _previousValue = '';
      _operation = '';
      _userIsTyping = false;
    });
  }

  void _clearEntryPressed() {
    setState(() {
      _display = '0';
      _userIsTyping = false;
    });
  }

  void _backspacePressed() {
    if (_userIsTyping && _display.length > 1) {
      setState(() {
        _display = _display.substring(0, _display.length - 1);
      });
    } else {
      setState(() {
        _display = '0';
        _userIsTyping = false;
      });
    }
  }

  void _signPressed() {
    if (_display != '0') {
      setState(() {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
        } else {
          _display = '-$_display';
        }
      });
    }
  }

  void _scientificFunction(String function) {
    double current = double.tryParse(_display) ?? 0;
    double result = 0;
    String calculation = '$function($_display)';

    try {
      switch (function) {
        case 'sin':
          result = sin(current * pi / 180); // Convert to radians
          break;
        case 'cos':
          result = cos(current * pi / 180);
          break;
        case 'tan':
          result = tan(current * pi / 180);
          break;
        case 'ln':
          if (current > 0) {
            result = log(current);
          } else {
            _showError('Invalid input for ln');
            return;
          }
          break;
        case 'log':
          if (current > 0) {
            result = log(current) / ln10;
          } else {
            _showError('Invalid input for log');
            return;
          }
          break;
        case '√':
          if (current >= 0) {
            result = sqrt(current);
          } else {
            _showError('Invalid input for √');
            return;
          }
          break;
        case 'x²':
          result = current * current;
          calculation = '($_display)²';
          break;
        case '1/x':
          if (current != 0) {
            result = 1 / current;
            calculation = '1/($_display)';
          } else {
            _showError('Cannot divide by zero');
            return;
          }
          break;
        case '!':
          if (current >= 0 && current == current.floor() && current <= 170) {
            result = _factorial(current.toInt()).toDouble();
            calculation = '$_display!';
          } else {
            _showError('Invalid input for factorial');
            return;
          }
          break;
      }

      setState(() {
        _display = _formatResult(result);
        _history.insert(0, '$calculation = ${_formatResult(result)}');
        if (_history.length > 50) {
          _history = _history.take(50).toList();
        }
        _userIsTyping = false;
      });
    } catch (e) {
      _showError('Math error');
    }
  }

  int _factorial(int n) {
    if (n <= 1) return 1;
    return n * _factorial(n - 1);
  }

  String _formatResult(double result) {
    if (result.isInfinite) return 'Infinity';
    if (result.isNaN) return 'Error';

    if (result == result.truncateToDouble()) {
      return result.truncate().toString();
    } else {
      String formatted = result.toString();
      if (formatted.contains('e')) {
        return result.toStringAsExponential(6);
      }
      if (formatted.length > 12) {
        return result.toStringAsFixed(8);
      }
      return formatted;
    }
  }

  void _showError(String message) {
    setState(() {
      _display = 'Error';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _display = '0';
          _userIsTyping = false;
        });
      }
    });
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    Color? color,
    Color? textColor,
    double flex = 1,
    IconData? icon,
  }) {
    return Expanded(
      flex: flex.round(),
      child: Container(
        margin: const EdgeInsets.all(2),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey.shade200,
            foregroundColor: textColor ?? Colors.black87,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 1,
          ),
          child: icon != null
              ? Icon(icon, size: 20)
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCalculatorBody() {
    return Column(
      children: [
        // Display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          color: Colors.black87,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (_operation.isNotEmpty)
                Text(
                  '$_previousValue $_operation',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                _display,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),

        // Scientific functions row
        Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildScientificButton('sin', () => _scientificFunction('sin')),
                _buildScientificButton('cos', () => _scientificFunction('cos')),
                _buildScientificButton('tan', () => _scientificFunction('tan')),
                _buildScientificButton('ln', () => _scientificFunction('ln')),
                _buildScientificButton('log', () => _scientificFunction('log')),
                _buildScientificButton('√', () => _scientificFunction('√')),
                _buildScientificButton('x²', () => _scientificFunction('x²')),
                _buildScientificButton('1/x', () => _scientificFunction('1/x')),
                _buildScientificButton('x!', () => _scientificFunction('!')),
                _buildScientificButton('π', () => _numberPressed(pi.toString())),
                _buildScientificButton('e', () => _numberPressed(e.toString())),
              ],
            ),
          ),
        ),

        // Button grid
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                // First row
                Expanded(
                  child: Row(
                    children: [
                      _buildButton(
                        text: 'C',
                        onPressed: _clearPressed,
                        color: Colors.red.shade400,
                        textColor: Colors.white,
                      ),
                      _buildButton(
                        text: 'CE',
                        onPressed: _clearEntryPressed,
                        color: Colors.orange.shade400,
                        textColor: Colors.white,
                      ),
                      _buildButton(
                        text: '',
                        icon: Icons.backspace_outlined,
                        onPressed: _backspacePressed,
                        color: Colors.orange.shade400,
                        textColor: Colors.white,
                      ),
                      _buildButton(
                        text: '÷',
                        onPressed: () => _operationPressed('÷'),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),

                // Second row
                Expanded(
                  child: Row(
                    children: [
                      _buildButton(text: '7', onPressed: () => _numberPressed('7')),
                      _buildButton(text: '8', onPressed: () => _numberPressed('8')),
                      _buildButton(text: '9', onPressed: () => _numberPressed('9')),
                      _buildButton(
                        text: '×',
                        onPressed: () => _operationPressed('×'),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),

                // Third row
                Expanded(
                  child: Row(
                    children: [
                      _buildButton(text: '4', onPressed: () => _numberPressed('4')),
                      _buildButton(text: '5', onPressed: () => _numberPressed('5')),
                      _buildButton(text: '6', onPressed: () => _numberPressed('6')),
                      _buildButton(
                        text: '-',
                        onPressed: () => _operationPressed('-'),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),

                // Fourth row
                Expanded(
                  child: Row(
                    children: [
                      _buildButton(text: '1', onPressed: () => _numberPressed('1')),
                      _buildButton(text: '2', onPressed: () => _numberPressed('2')),
                      _buildButton(text: '3', onPressed: () => _numberPressed('3')),
                      _buildButton(
                        text: '+',
                        onPressed: () => _operationPressed('+'),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),

                // Fifth row
                Expanded(
                  child: Row(
                    children: [
                      _buildButton(text: '±', onPressed: _signPressed),
                      _buildButton(text: '0', onPressed: () => _numberPressed('0')),
                      _buildButton(text: '.', onPressed: _decimalPressed),
                      _buildButton(
                        text: '=',
                        onPressed: _equalsPressed,
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScientificButton(String text, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey.shade100,
          foregroundColor: Colors.blueGrey.shade800,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: const Size(50, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calculation History',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _history.clear();
                  });
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _history.isEmpty
                ? const Center(
                    child: Text(
                      'No calculations yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final calculation = _history[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            calculation,
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              final result = calculation.split(' = ').last;
                              setState(() {
                                _display = result;
                                _showHistory = false;
                                _userIsTyping = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Result copied to calculator'),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showHistory = !_showHistory;
              });
            },
            icon: Icon(_showHistory ? Icons.calculate : Icons.history),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _showHistory ? _buildHistoryList() : _buildCalculatorBody(),
      ),
    );
  }
}