import 'package:flutter/material.dart';

class ApplicationFormScreen extends StatefulWidget {
  const ApplicationFormScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _personalFormKey = GlobalKey<FormState>();
  final _professionalFormKey = GlobalKey<FormState>();
  final _documentsFormKey = GlobalKey<FormState>();

  // Personal Information
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _dobController = TextEditingController();
  final _ssnController = TextEditingController();
  String _gender = 'Prefer not to say';
  String _maritalStatus = 'Single';

  // Professional Information
  final _currentEmployerController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _workAddressController = TextEditingController();
  final _supervisorController = TextEditingController();
  final _supervisorPhoneController = TextEditingController();
  final _annualIncomeController = TextEditingController();
  final _yearsEmployedController = TextEditingController();
  final _previousEmployerController = TextEditingController();
  final _educationController = TextEditingController();
  final _skillsController = TextEditingController();
  String _employmentStatus = 'Full-time';
  String _educationLevel = 'High School';

  // Documents & References
  final _reference1NameController = TextEditingController();
  final _reference1PhoneController = TextEditingController();
  final _reference1RelationController = TextEditingController();
  final _reference2NameController = TextEditingController();
  final _reference2PhoneController = TextEditingController();
  final _reference2RelationController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _emergencyRelationController = TextEditingController();

  List<String> _uploadedDocuments = [];
  bool _backgroundCheckConsent = false;
  bool _drugTestConsent = false;
  bool _isSubmitting = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final List<String> _maritalOptions = ['Single', 'Married', 'Divorced', 'Widowed', 'Other'];
  final List<String> _employmentOptions = ['Full-time', 'Part-time', 'Contract', 'Unemployed', 'Student'];
  final List<String> _educationOptions = ['High School', 'Associate Degree', 'Bachelor\'s Degree', 'Master\'s Degree', 'Doctorate', 'Other'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _dobController.dispose();
    _ssnController.dispose();
    _currentEmployerController.dispose();
    _jobTitleController.dispose();
    _workAddressController.dispose();
    _supervisorController.dispose();
    _supervisorPhoneController.dispose();
    _annualIncomeController.dispose();
    _yearsEmployedController.dispose();
    _previousEmployerController.dispose();
    _educationController.dispose();
    _skillsController.dispose();
    _reference1NameController.dispose();
    _reference1PhoneController.dispose();
    _reference1RelationController.dispose();
    _reference2NameController.dispose();
    _reference2PhoneController.dispose();
    _reference2RelationController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
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

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validateSSN(String? value) {
    if (value == null || value.isEmpty) {
      return 'SSN is required';
    }
    if (!RegExp(r'^\d{3}-\d{2}-\d{4}$').hasMatch(value)) {
      return 'Please enter SSN in format: 123-45-6789';
    }
    return null;
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
      _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  void _uploadDocument() {
    // Simulate document upload
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Document Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Driver\'s License',
            'Passport',
            'Resume',
            'Cover Letter',
            'References',
            'Transcripts',
          ].map((doc) => ListTile(
            title: Text(doc),
            onTap: () {
              setState(() {
                _uploadedDocuments.add('$doc.pdf');
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$doc uploaded successfully')),
              );
            },
          )).toList(),
        ),
      ),
    );
  }

  void _removeDocument(String document) {
    setState(() {
      _uploadedDocuments.remove(document);
    });
  }

  bool _isFormValid() {
    return _personalFormKey.currentState?.validate() == true &&
        _professionalFormKey.currentState?.validate() == true &&
        _backgroundCheckConsent &&
        _drugTestConsent;
  }

  void _submitApplication() async {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields and consent forms')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 3));

    setState(() => _isSubmitting = false);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Application Submitted!'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Thank you for your application. We have received your information and will review it shortly.'),
              SizedBox(height: 12),
              Text('Application ID: APP-2024-001234'),
              SizedBox(height: 8),
              Text('You will receive a confirmation email within 24 hours.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPersonalTab() {
    return Form(
      key: _personalFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

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
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              validator: _validatePhone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            InkWell(
              onTap: _selectDateOfBirth,
              child: IgnorePointer(
                child: TextFormField(
                  controller: _dobController,
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

            TextFormField(
              controller: _ssnController,
              decoration: const InputDecoration(
                labelText: 'Social Security Number',
                prefixIcon: Icon(Icons.security),
                border: OutlineInputBorder(),
                helperText: 'Format: 123-45-6789',
              ),
              validator: _validateSSN,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    items: _genderOptions.map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    )).toList(),
                    onChanged: (value) => setState(() => _gender = value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _maritalStatus,
                    decoration: const InputDecoration(
                      labelText: 'Marital Status',
                      border: OutlineInputBorder(),
                    ),
                    items: _maritalOptions.map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    )).toList(),
                    onChanged: (value) => setState(() => _maritalStatus = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text(
              'Address Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Street Address',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty == true ? 'Address is required' : null,
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
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty == true ? 'City is required' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      labelText: 'State',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty == true ? 'State is required' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _zipController,
                    decoration: const InputDecoration(
                      labelText: 'ZIP',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty == true ? 'ZIP is required' : null,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalTab() {
    return Form(
      key: _professionalFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Employment Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _employmentStatus,
              decoration: const InputDecoration(
                labelText: 'Employment Status',
                prefixIcon: Icon(Icons.work),
                border: OutlineInputBorder(),
              ),
              items: _employmentOptions.map((status) => DropdownMenuItem(
                value: status,
                child: Text(status),
              )).toList(),
              onChanged: (value) => setState(() => _employmentStatus = value!),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _currentEmployerController,
              decoration: const InputDecoration(
                labelText: 'Current Employer',
                prefixIcon: Icon(Icons.business),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _jobTitleController,
              decoration: const InputDecoration(
                labelText: 'Job Title',
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _workAddressController,
              decoration: const InputDecoration(
                labelText: 'Work Address',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _supervisorController,
                    decoration: const InputDecoration(
                      labelText: 'Supervisor Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _supervisorPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Supervisor Phone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _annualIncomeController,
                    decoration: const InputDecoration(
                      labelText: 'Annual Income',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _yearsEmployedController,
                    decoration: const InputDecoration(
                      labelText: 'Years Employed',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _previousEmployerController,
              decoration: const InputDecoration(
                labelText: 'Previous Employer (Optional)',
                prefixIcon: Icon(Icons.history),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Education & Skills',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _educationLevel,
              decoration: const InputDecoration(
                labelText: 'Education Level',
                prefixIcon: Icon(Icons.school),
                border: OutlineInputBorder(),
              ),
              items: _educationOptions.map((education) => DropdownMenuItem(
                value: education,
                child: Text(education),
              )).toList(),
              onChanged: (value) => setState(() => _educationLevel = value!),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _educationController,
              decoration: const InputDecoration(
                labelText: 'School/Institution',
                prefixIcon: Icon(Icons.account_balance),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _skillsController,
              decoration: const InputDecoration(
                labelText: 'Relevant Skills',
                prefixIcon: Icon(Icons.lightbulb),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              maxLength: 300,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'References & Documents',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),

          Text(
            'References',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Reference 1'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _reference1NameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _reference1PhoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _reference1RelationController,
                          decoration: const InputDecoration(
                            labelText: 'Relationship',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
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
                  const Text('Reference 2'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _reference2NameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _reference2PhoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _reference2RelationController,
                          decoration: const InputDecoration(
                            labelText: 'Relationship',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Emergency Contact',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _emergencyNameController,
            decoration: const InputDecoration(
              labelText: 'Emergency Contact Name',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _emergencyPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _emergencyRelationController,
                  decoration: const InputDecoration(
                    labelText: 'Relationship',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            'Document Uploads',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (_uploadedDocuments.isEmpty)
                    const Text(
                      'No documents uploaded yet',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    ..._uploadedDocuments.map((doc) => ListTile(
                      leading: const Icon(Icons.description),
                      title: Text(doc),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeDocument(doc),
                      ),
                    )).toList(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _uploadDocument,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload Document'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Consent Forms',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text('Background Check Consent'),
                    subtitle: const Text('I consent to a background check being performed'),
                    value: _backgroundCheckConsent,
                    onChanged: (value) => setState(() => _backgroundCheckConsent = value!),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: const Text('Drug Test Consent'),
                    subtitle: const Text('I consent to drug testing if required'),
                    value: _drugTestConsent,
                    onChanged: (value) => setState(() => _drugTestConsent = value!),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
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
        title: const Text('Job Application'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Personal', icon: Icon(Icons.person)),
            Tab(text: 'Professional', icon: Icon(Icons.work)),
            Tab(text: 'Documents', icon: Icon(Icons.description)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPersonalTab(),
          _buildProfessionalTab(),
          _buildDocumentsTab(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitApplication,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Submit Application',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }
}