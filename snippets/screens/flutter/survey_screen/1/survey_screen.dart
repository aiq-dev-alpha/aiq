import 'package:flutter/material.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final PageController _pageController = PageController();
  int _currentQuestionIndex = 0;
  bool _isSubmitting = false;

  final Map<String, dynamic> _responses = {};

  final List<SurveyQuestion> _questions = [
    SurveyQuestion(
      id: 'demographics',
      title: 'Tell us about yourself',
      type: QuestionType.multipleChoice,
      question: 'What is your age group?',
      isRequired: true,
      options: ['18-24', '25-34', '35-44', '45-54', '55-64', '65+'],
    ),
    SurveyQuestion(
      id: 'usage_frequency',
      title: 'Usage Patterns',
      type: QuestionType.singleChoice,
      question: 'How often do you use our app?',
      isRequired: true,
      options: ['Daily', 'Weekly', 'Monthly', 'Rarely', 'First time'],
    ),
    SurveyQuestion(
      id: 'satisfaction_rating',
      title: 'Satisfaction Rating',
      type: QuestionType.scale,
      question: 'How satisfied are you with our service?',
      isRequired: true,
      scaleMin: 1,
      scaleMax: 10,
    ),
    SurveyQuestion(
      id: 'features_used',
      title: 'Feature Usage',
      type: QuestionType.checkbox,
      question: 'Which features do you use most? (Select all that apply)',
      isRequired: false,
      options: [
        'Dashboard',
        'Reports',
        'Settings',
        'Search',
        'Notifications',
        'Export Data',
      ],
    ),
    SurveyQuestion(
      id: 'improvement_suggestions',
      title: 'Your Feedback',
      type: QuestionType.text,
      question: 'What improvements would you like to see?',
      isRequired: false,
      placeholder: 'Share your thoughts and suggestions...',
    ),
    SurveyQuestion(
      id: 'recommendation',
      title: 'Final Question',
      type: QuestionType.yesNo,
      question: 'Would you recommend our app to others?',
      isRequired: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isCurrentQuestionAnswered() {
    final question = _questions[_currentQuestionIndex];
    final response = _responses[question.id];

    if (!question.isRequired) return true;

    switch (question.type) {
      case QuestionType.singleChoice:
      case QuestionType.multipleChoice:
      case QuestionType.yesNo:
        return response != null;
      case QuestionType.checkbox:
        return response is List && response.isNotEmpty;
      case QuestionType.scale:
        return response != null;
      case QuestionType.text:
        return response != null && response.toString().trim().isNotEmpty;
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() => _currentQuestionIndex++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() => _currentQuestionIndex--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitSurvey() async {
    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isSubmitting = false);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Thank You!'),
          content: const Text('Your survey responses have been submitted successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildQuestionWidget(SurveyQuestion question) {
    switch (question.type) {
      case QuestionType.singleChoice:
      case QuestionType.multipleChoice:
        return _buildChoiceQuestion(question);
      case QuestionType.checkbox:
        return _buildCheckboxQuestion(question);
      case QuestionType.scale:
        return _buildScaleQuestion(question);
      case QuestionType.text:
        return _buildTextQuestion(question);
      case QuestionType.yesNo:
        return _buildYesNoQuestion(question);
    }
  }

  Widget _buildChoiceQuestion(SurveyQuestion question) {
    return Column(
      children: question.options!.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: _responses[question.id],
          onChanged: (value) {
            setState(() => _responses[question.id] = value);
          },
        );
      }).toList(),
    );
  }

  Widget _buildCheckboxQuestion(SurveyQuestion question) {
    List<String> selectedOptions = _responses[question.id] ?? [];

    return Column(
      children: question.options!.map((option) {
        return CheckboxListTile(
          title: Text(option),
          value: selectedOptions.contains(option),
          onChanged: (checked) {
            setState(() {
              if (checked == true) {
                selectedOptions.add(option);
              } else {
                selectedOptions.remove(option);
              }
              _responses[question.id] = selectedOptions;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildScaleQuestion(SurveyQuestion question) {
    double currentValue = (_responses[question.id] ?? question.scaleMin!).toDouble();

    return Column(
      children: [
        Text(
          'Rating: ${currentValue.toInt()}/${question.scaleMax}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Slider(
          value: currentValue,
          min: question.scaleMin!.toDouble(),
          max: question.scaleMax!.toDouble(),
          divisions: question.scaleMax! - question.scaleMin!,
          label: currentValue.toInt().toString(),
          onChanged: (value) {
            setState(() => _responses[question.id] = value.toInt());
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${question.scaleMin}'),
            Text('${question.scaleMax}'),
          ],
        ),
      ],
    );
  }

  Widget _buildTextQuestion(SurveyQuestion question) {
    return TextFormField(
      initialValue: _responses[question.id] ?? '',
      decoration: InputDecoration(
        hintText: question.placeholder,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      maxLength: 500,
      onChanged: (value) => _responses[question.id] = value,
    );
  }

  Widget _buildYesNoQuestion(SurveyQuestion question) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<bool>(
            title: const Text('Yes'),
            value: true,
            groupValue: _responses[question.id],
            onChanged: (value) => setState(() => _responses[question.id] = value),
          ),
        ),
        Expanded(
          child: RadioListTile<bool>(
            title: const Text('No'),
            value: false,
            groupValue: _responses[question.id],
            onChanged: (value) => setState(() => _responses[question.id] = value),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: progress),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final question = _questions[index];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              child: Text('${index + 1}'),
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    question.title,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${index + 1} of ${_questions.length}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          question.question,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (question.isRequired)
                          const Text(
                            '* Required',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        const SizedBox(height: 20),
                        _buildQuestionWidget(question),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (_currentQuestionIndex > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousQuestion,
                  child: const Text('Previous'),
                ),
              ),
            if (_currentQuestionIndex > 0) const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _currentQuestionIndex == _questions.length - 1
                    ? (_isCurrentQuestionAnswered() ? _submitSurvey : null)
                    : (_isCurrentQuestionAnswered() ? _nextQuestion : null),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_currentQuestionIndex == _questions.length - 1
                        ? 'Submit Survey'
                        : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyQuestion {
  final String id;
  final String title;
  final QuestionType type;
  final String question;
  final bool isRequired;
  final List<String>? options;
  final int? scaleMin;
  final int? scaleMax;
  final String? placeholder;

  SurveyQuestion({
    required this.id,
    required this.title,
    required this.type,
    required this.question,
    this.isRequired = false,
    this.options,
    this.scaleMin,
    this.scaleMax,
    this.placeholder,
  });
}

enum QuestionType {
  singleChoice,
  multipleChoice,
  checkbox,
  scale,
  text,
  yesNo,
}