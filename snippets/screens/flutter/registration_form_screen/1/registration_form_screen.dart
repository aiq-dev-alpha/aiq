import 'package:flutter/material.dart';

class RegistrationFormScreen extends StatefulWidget {
  const RegistrationFormScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isSubmitting = false;

  // Step 1: Basic Information
  final _step1FormKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  String _gender = 'Prefer not to say';

  // Step 2: Account Details
  final _step2FormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Step 3: Address Information
  final _step3FormKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  String _country = 'United States';

  // Step 4: Preferences
  bool _marketingEmails = false;
  bool _pushNotifications = true;
  bool _termsAccepted = false;
  bool _privacyAccepted = false;
  String _preferredLanguage = 'English';

  final List<String> _genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final List<String> _countryOptions = ['United States', 'Canada', 'United Kingdom', 'Australia', 'Other'];
  final List<String> _languageOptions = ['English', 'Spanish', 'French', 'German', 'Chinese'];

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  bool _isStepValid(int step) {
    switch (step) {
      case 0:
        return _step1FormKey.currentState?.validate() == true;
      case 1:
        return _step2FormKey.currentState?.validate() == true;
      case 2:
        return _step3FormKey.currentState?.validate() == true;
      case 3:
        return _termsAccepted && _privacyAccepted;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_isStepValid(_currentStep)) {
      if (_currentStep < 3) {
        setState(() => _currentStep++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitRegistration() async {
    if (!_isStepValid(_currentStep)) return;

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 3));

    setState(() => _isSubmitting = false);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Registration Successful!'),
          content: const Text('Welcome! Your account has been created successfully. Please check your email to verify your account.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime.now().subtract(const Duration(days: 36500)), // 100 years ago
      lastDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      helpText: 'Select date of birth',
    );
    if (picked != null) {
      _dateOfBirthController.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  Widget _buildStep1() {
    return Form(
      key: _step1FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'First name is required' : null,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Last name is required' : null,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
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
          const SizedBox(height: 16),

          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            validator: (value) => value?.isEmpty == true ? 'Phone number is required' : null,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          InkWell(
            onTap: _selectDateOfBirth,
            child: IgnorePointer(
              child: TextFormField(
                controller: _dateOfBirthController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Date of birth is required' : null,
              ),
            ),
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: _gender,
            decoration: const InputDecoration(
              labelText: 'Gender',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            items: _genderOptions.map((gender) => DropdownMenuItem(
              value: gender,
              child: Text(gender),
            )).toList(),
            onChanged: (value) => setState(() => _gender = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _step2FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Details',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),

          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.account_circle),
              border: OutlineInputBorder(),
              helperText: 'Must be unique and at least 3 characters',
            ),
            validator: (value) {
              if (value?.isEmpty == true) return 'Username is required';
              if (value!.length < 3) return 'Username must be at least 3 characters';
              return null;
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              helperText: 'Must include uppercase, lowercase, and number',
            ),
            validator: _validatePassword,
            obscureText: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(),
            ),
            validator: _validateConfirmPassword,
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Form(
      key: _step3FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address Information',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),

          TextFormField(
            controller: _streetController,
            decoration: const InputDecoration(
              labelText: 'Street Address',
              prefixIcon: Icon(Icons.home),
              border: OutlineInputBorder(),
            ),
            validator: (value) => value?.isEmpty == true ? 'Street address is required' : null,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'City is required' : null,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'State',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'State is required' : null,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _zipController,
                  decoration: const InputDecoration(
                    labelText: 'ZIP Code',
                    prefixIcon: Icon(Icons.mail),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'ZIP code is required' : null,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _country,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                  items: _countryOptions.map((country) => DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  )).toList(),
                  onChanged: (value) => setState(() => _country = value!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferences & Terms',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),

        DropdownButtonFormField<String>(
          value: _preferredLanguage,
          decoration: const InputDecoration(
            labelText: 'Preferred Language',
            prefixIcon: Icon(Icons.language),
            border: OutlineInputBorder(),
          ),
          items: _languageOptions.map((language) => DropdownMenuItem(
            value: language,
            child: Text(language),
          )).toList(),
          onChanged: (value) => setState(() => _preferredLanguage = value!),
        ),
        const SizedBox(height: 24),

        Text(
          'Notification Preferences',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),

        CheckboxListTile(
          title: const Text('Marketing emails'),
          subtitle: const Text('Receive promotional offers and updates'),
          value: _marketingEmails,
          onChanged: (value) => setState(() => _marketingEmails = value!),
          controlAffinity: ListTileControlAffinity.leading,
        ),

        CheckboxListTile(
          title: const Text('Push notifications'),
          subtitle: const Text('Receive important app notifications'),
          value: _pushNotifications,
          onChanged: (value) => setState(() => _pushNotifications = value!),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 16),

        const Divider(),
        const SizedBox(height: 16),

        CheckboxListTile(
          title: const Text('I accept the Terms of Service'),
          subtitle: const Text('Required to create an account'),
          value: _termsAccepted,
          onChanged: (value) => setState(() => _termsAccepted = value!),
          controlAffinity: ListTileControlAffinity.leading,
        ),

        CheckboxListTile(
          title: const Text('I accept the Privacy Policy'),
          subtitle: const Text('Required to create an account'),
          value: _privacyAccepted,
          onChanged: (value) => setState(() => _privacyAccepted = value!),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: (_currentStep + 1) / 4),
        ),
      ),
      body: Column(
        children: [
          // Step indicator
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: List.generate(4, (index) {
                final isActive = index == _currentStep;
                final isCompleted = index < _currentStep;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: isCompleted || isActive
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                          child: isCompleted
                              ? const Icon(Icons.check, color: Colors.white, size: 16)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isActive ? Colors.white : Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ['Basic', 'Account', 'Address', 'Finish'][index],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            color: isActive ? Theme.of(context).primaryColor : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          // Form content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildStep1(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildStep2(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildStep3(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildStep4(),
                ),
              ],
            ),
          ),

          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _currentStep == 3
                        ? (_isStepValid(_currentStep) ? _submitRegistration : null)
                        : (_isStepValid(_currentStep) ? _nextStep : null),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_currentStep == 3 ? 'Create Account' : 'Next'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}