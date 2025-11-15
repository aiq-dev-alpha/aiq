import 'package:flutter/material.dart';

class Flow extends StatefulWidget {
  final Color primaryColor;
  final VoidCallback onComplete;

  const Flow({
    Key? key,
    this.primaryColor = const Color(0xFF6200EE),
    required this.onComplete,
  }) : super(key: key);

  @override
  State<Flow> createState() => _FlowState();
}

class _FlowState extends State<Flow> {
  int _step = 0;
  final int _totalSteps = 3;

  void _nextStep() {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      widget.onComplete();
    }
  }

  void _previousStep() {
    if (_step > 0) {
      setState(() => _step--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_step + 1} of $_totalSteps'),
        backgroundColor: widget.primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Step ${_step + 1}', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_step > 0)
                  ElevatedButton(
                    onPressed: _previousStep,
                    child: const Text('Back'),
                  ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
                  onPressed: _nextStep,
                  child: Text(_step == _totalSteps - 1 ? 'Complete' : 'Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
