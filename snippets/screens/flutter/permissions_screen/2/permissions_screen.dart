import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<PermissionItem> _permissions = [
    PermissionItem(
      icon: Icons.notifications,
      title: 'Notifications',
      description: 'Get notified about new challenges and your progress',
      isRequired: false,
      isGranted: false,
    ),
    PermissionItem(
      icon: Icons.camera_alt,
      title: 'Camera',
      description: 'Take photos for your profile and share achievements',
      isRequired: false,
      isGranted: false,
    ),
    PermissionItem(
      icon: Icons.mic,
      title: 'Microphone',
      description: 'Use voice commands for hands-free navigation',
      isRequired: false,
      isGranted: false,
    ),
    PermissionItem(
      icon: Icons.location_on,
      title: 'Location',
      description: 'Find nearby users and location-based challenges',
      isRequired: false,
      isGranted: false,
    ),
  ];

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _requestPermission(int index) async {
    // Simulate permission request
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _permissions[index].isGranted = !_permissions[index].isGranted;
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _permissions[index].isGranted
              ? '${_permissions[index].title} permission granted'
              : '${_permissions[index].title} permission denied',
        ),
        backgroundColor: _permissions[index].isGranted
            ? Colors.green
            : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _continueToApp() {
    Navigator.of(context).pushReplacementNamed('/interests');
  }

  void _skipPermissions() {
    Navigator.of(context).pushReplacementNamed('/interests');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 50 * _slideAnimation.value),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Header
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.security,
                              color: Color(0xFF6366F1),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Permissions',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                Text(
                                  'Help us personalize your experience',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'We\'d like your permission to access the following features to enhance your AIQ experience:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Permissions list
                      Expanded(
                        child: ListView.builder(
                          itemCount: _permissions.length,
                          itemBuilder: (context, index) {
                            final permission = _permissions[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFE5E7EB),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: permission.isGranted
                                        ? const Color(0xFF10B981).withOpacity(0.1)
                                        : const Color(0xFF6B7280).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    permission.icon,
                                    color: permission.isGranted
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      permission.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    if (permission.isRequired) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEF4444),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Required',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    permission.description,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6B7280),
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: 80,
                                  child: ElevatedButton(
                                    onPressed: () => _requestPermission(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: permission.isGranted
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFF6366F1),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      permission.isGranted ? 'Granted' : 'Allow',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Action buttons
                      const SizedBox(height: 24),
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _continueToApp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _skipPermissions,
                            child: const Text(
                              'Skip for now',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PermissionItem {
  final IconData icon;
  final String title;
  final String description;
  final bool isRequired;
  bool isGranted;

  PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.isRequired,
    required this.isGranted,
  });
}