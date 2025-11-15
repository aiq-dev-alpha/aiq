import 'package:flutter/material.dart';

class CreationFlow extends StatefulWidget {
  final Color primaryColor;
  final Function(Map<String, dynamic>)? onComplete;

  const CreationFlow({
    Key? key,
    this.primaryColor = const Color(0xFF6200EE),
    this.onComplete,
  }) : super(key: key);

  @override
  State<CreationFlow> createState() => _CreationFlowState();
}

class _CreationFlowState extends State<CreationFlow> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _currentStep = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _complete() {
    final data = {
      'title': _titleController.text,
      'description': _descriptionController.text,
    };
    widget.onComplete?.call(data);
    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
        backgroundColor: widget.primaryColor,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            _complete();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        steps: [
          Step(
            title: const Text('Title'),
            content: TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Enter title'),
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Description'),
            content: TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Enter description'),
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Review'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${_titleController.text}'),
                const SizedBox(height: 8),
                Text('Description: ${_descriptionController.text}'),
              ],
            ),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }
}
