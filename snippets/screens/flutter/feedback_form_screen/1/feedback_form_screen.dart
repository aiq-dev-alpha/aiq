import 'package:flutter/material.dart';

class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackController = TextEditingController();
  final _improvementsController = TextEditingController();

  String _feedbackType = 'General';
  double _satisfactionRating = 5.0;
  bool _wouldRecommend = true;
  bool _allowContact = false;
  bool _isSubmitting = false;

  final List<String> _feedbackTypes = [
    'General',
    'Bug Report',
    'Feature Request',
    'UI/UX',
    'Performance',
    'Support',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    _improvementsController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isSubmitting = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback!'),
            backgroundColor: Colors.green,
          ),
        );
        _resetForm();
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _feedbackController.clear();
    _improvementsController.clear();
    setState(() {
      _feedbackType = 'General';
      _satisfactionRating = 5.0;
      _wouldRecommend = true;
      _allowContact = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Feedback'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Information',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Your Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Feedback Details',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _feedbackType,
                        decoration: const InputDecoration(
                          labelText: 'Feedback Type',
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(),
                        ),
                        items: _feedbackTypes
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _feedbackType = value!),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Overall Satisfaction: ${_satisfactionRating.toInt()}/10',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Slider(
                        value: _satisfactionRating,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: _satisfactionRating.toInt().toString(),
                        onChanged: (value) => setState(() => _satisfactionRating = value),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _feedbackController,
                        decoration: const InputDecoration(
                          labelText: 'Your Feedback',
                          prefixIcon: Icon(Icons.feedback),
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          hintText: 'Please share your thoughts and experiences...',
                        ),
                        validator: (value) => value?.isEmpty == true ? 'Feedback is required' : null,
                        maxLines: 4,
                        maxLength: 1000,
                        textInputAction: TextInputAction.newline,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _improvementsController,
                        decoration: const InputDecoration(
                          labelText: 'Suggestions for Improvement (Optional)',
                          prefixIcon: Icon(Icons.lightbulb),
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          hintText: 'What could we do better?',
                        ),
                        maxLines: 3,
                        maxLength: 500,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional Questions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Would you recommend us to others?',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Yes'),
                              value: true,
                              groupValue: _wouldRecommend,
                              onChanged: (value) => setState(() => _wouldRecommend = value!),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('No'),
                              value: false,
                              groupValue: _wouldRecommend,
                              onChanged: (value) => setState(() => _wouldRecommend = value!),
                            ),
                          ),
                        ],
                      ),

                      CheckboxListTile(
                        title: const Text('Allow us to contact you for follow-up'),
                        subtitle: const Text('We may reach out for clarification or updates'),
                        value: _allowContact,
                        onChanged: (value) => setState(() => _allowContact = value!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Submit Feedback',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 16),

              OutlinedButton(
                onPressed: _isSubmitting ? null : _resetForm,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Clear Form'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}