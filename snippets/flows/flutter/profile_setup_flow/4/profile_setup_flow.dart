import 'package:flutter/material.dart';

class ProfileSetupFlowTheme {
  final Color primaryColor;
  final Color backgroundColor;
  final Color buttonColor;

  const ProfileSetupFlowTheme({
    this.primaryColor = const Color(0xFF6200EE),
    this.backgroundColor = Colors.white,
    this.buttonColor = const Color(0xFF6200EE),
  });
}

class ProfileSetupFlow {
  final ProfileSetupFlowTheme theme;

  const ProfileSetupFlow({this.theme = const ProfileSetupFlowTheme()});

  void start(BuildContext context, {Function(ProfileData)? onComplete}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ProfileSetupController(
          theme: theme,
          onComplete: onComplete,
        ),
      ),
    );
  }
}

class _ProfileSetupController extends StatefulWidget {
  final ProfileSetupFlowTheme theme;
  final Function(ProfileData)? onComplete;

  const _ProfileSetupController({
    required this.theme,
    this.onComplete,
  });

  @override
  State<_ProfileSetupController> createState() => _ProfileSetupControllerState();
}

class _ProfileSetupControllerState extends State<_ProfileSetupController> {
  int _currentStep = 0;
  final _profileData = ProfileData();

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      widget.onComplete?.call(_profileData);
      Navigator.of(context).pop();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile Setup'),
        backgroundColor: widget.theme.primaryColor,
      ),
      body: IndexedStack(
        index: _currentStep,
        children: [
          _BasicInfoStep(
            theme: widget.theme,
            data: _profileData,
            onNext: _nextStep,
          ),
          _InterestsStep(
            theme: widget.theme,
            data: _profileData,
            onNext: _nextStep,
            onBack: _previousStep,
          ),
          _PreferencesStep(
            theme: widget.theme,
            data: _profileData,
            onComplete: _nextStep,
            onBack: _previousStep,
          ),
        ],
      ),
    );
  }
}

class _BasicInfoStep extends StatelessWidget {
  final ProfileSetupFlowTheme theme;
  final ProfileData data;
  final VoidCallback onNext;

  const _BasicInfoStep({
    required this.theme,
    required this.data,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Basic Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => data.name = v,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Bio',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onChanged: (v) => data.bio = v,
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.buttonColor,
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: onNext,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}

class _InterestsStep extends StatelessWidget {
  final ProfileSetupFlowTheme theme;
  final ProfileData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _InterestsStep({
    required this.theme,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Select Interests',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _InterestChip('Technology', theme),
                _InterestChip('Sports', theme),
                _InterestChip('Music', theme),
                _InterestChip('Art', theme),
                _InterestChip('Travel', theme),
                _InterestChip('Food', theme),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: theme.buttonColor),
                  onPressed: onNext,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  final String label;
  final ProfileSetupFlowTheme theme;

  const _InterestChip(this.label, this.theme);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: theme.primaryColor),
      ),
      child: Text(label),
    );
  }
}

class _PreferencesStep extends StatelessWidget {
  final ProfileSetupFlowTheme theme;
  final ProfileData data;
  final VoidCallback onComplete;
  final VoidCallback onBack;

  const _PreferencesStep({
    required this.theme,
    required this.data,
    required this.onComplete,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Preferences',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          SwitchListTile(
            title: const Text('Email Notifications'),
            value: data.emailNotifications,
            onChanged: (v) => data.emailNotifications = v,
          ),
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: data.pushNotifications,
            onChanged: (v) => data.pushNotifications = v,
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: theme.buttonColor),
                  onPressed: onComplete,
                  child: const Text('Complete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileData {
  String name = '';
  String bio = '';
  List<String> interests = [];
  bool emailNotifications = true;
  bool pushNotifications = true;
}
