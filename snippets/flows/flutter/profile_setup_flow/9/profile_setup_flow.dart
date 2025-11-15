import 'package:flutter/material.dart';

class ProfileSetupFlow extends StatefulWidget {
  final Color primaryColor;
  final VoidCallback onComplete;

  const ProfileSetupFlow({
    Key? key,
    this.primaryColor = const Color(0xFF6200EE),
    required this.onComplete,
  }) : super(key: key);

  @override
  State<ProfileSetupFlow> createState() => _ProfileSetupFlowState();
}

class _ProfileSetupFlowState extends State<ProfileSetupFlow> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setup'),
        backgroundColor: widget.primaryColor,
      ),
      body: IndexedStack(
        index: _step,
        children: [
          _buildStep('Basic Info', Icons.person),
          _buildStep('Interests', Icons.favorite),
          _buildStep('Preferences', Icons.settings),
        ],
      ),
    );
  }

  Widget _buildStep(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: widget.primaryColor),
          const SizedBox(height: 32),
          Text(title, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 48),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
            onPressed: () {
              if (_step < 2) {
                setState(() => _step++);
              } else {
                widget.onComplete();
              }
            },
            child: Text(_step < 2 ? 'Next' : 'Complete'),
          ),
        ],
      ),
    );
  }
}
