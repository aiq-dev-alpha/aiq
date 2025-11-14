import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MaintenanceScreen extends StatefulWidget {
  final String? title;
  final String? message;
  final DateTime? estimatedEnd;
  final VoidCallback? onRefresh;
  final String? supportEmail;

  const MaintenanceScreen({
    super.key,
    this.title,
    this.message,
    this.estimatedEnd,
    this.onRefresh,
    this.supportEmail,
  });

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _toolsController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _toolsAnimation;

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
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _toolsController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _toolsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _toolsController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _toolsController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _toolsController.dispose();
    super.dispose();
  }

  String _formatEstimatedTime() {
    if (widget.estimatedEnd == null) return '';

    final now = DateTime.now();
    final difference = widget.estimatedEnd!.difference(now);

    if (difference.isNegative) {
      return 'Expected to be resolved soon';
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return 'Expected back in ${hours}h ${minutes}m';
    } else {
      return 'Expected back in ${minutes}m';
    }
  }

  void _copyEmail() {
    if (widget.supportEmail != null) {
      Clipboard.setData(ClipboardData(text: widget.supportEmail!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
                    children: [
                      const SizedBox(height: 60),
                      // Maintenance illustration
                      AnimatedBuilder(
                        animation: _toolsController,
                        builder: (context, child) {
                          return Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(80),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Main wrench icon
                                Icon(
                                  Icons.build,
                                  size: 60,
                                  color: const Color(0xFFF59E0B),
                                ),
                                // Animated tools around
                                Positioned(
                                  top: 20 + (10 * _toolsAnimation.value),
                                  right: 30,
                                  child: Transform.rotate(
                                    angle: _toolsAnimation.value * 0.5,
                                    child: Icon(
                                      Icons.settings,
                                      size: 20,
                                      color: const Color(0xFFF59E0B).withOpacity(0.6),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 30 + (8 * _toolsAnimation.value),
                                  left: 25,
                                  child: Transform.rotate(
                                    angle: -_toolsAnimation.value * 0.3,
                                    child: Icon(
                                      Icons.handyman,
                                      size: 18,
                                      color: const Color(0xFFF59E0B).withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      // Content
                      Text(
                        widget.title ?? 'Under Maintenance',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.message ??
                            'We\'re currently performing scheduled maintenance to improve your AIQ experience. Thank you for your patience!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                      if (widget.estimatedEnd != null) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFF59E0B).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.schedule,
                                color: Color(0xFFF59E0B),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _formatEstimatedTime(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF92400E),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const Spacer(),
                      // Status updates section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.info_outline,
                                  color: Color(0xFF6366F1),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'What we\'re working on:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '• Improving quiz loading performance\n• Adding new AI challenges\n• Enhancing user experience\n• Server optimization',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Action buttons
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: widget.onRefresh ?? () {
                                // Simulate refresh
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Checking status...'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.refresh, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Check Status',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (widget.supportEmail != null) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton(
                                onPressed: _copyEmail,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF6B7280),
                                  side: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.email, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Contact Support',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Follow us on social media for live updates',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF9CA3AF),
                        ),
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