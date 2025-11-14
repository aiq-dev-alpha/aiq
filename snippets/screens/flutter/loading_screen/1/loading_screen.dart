import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadingScreen extends StatefulWidget {
  final String? title;
  final String? message;
  final bool showProgress;
  final double? progress;
  final Color? primaryColor;

  const LoadingScreen({
    super.key,
    this.title,
    this.message,
    this.showProgress = false,
    this.progress,
    this.primaryColor,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> _loadingMessages = [
    'Preparing your experience...',
    'Loading AI challenges...',
    'Setting up your profile...',
    'Almost ready...',
  ];

  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: widget.primaryColor == null
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
    _fadeController.forward();

    // Cycle through loading messages
    _startMessageCycle();
  }

  void _startMessageCycle() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentMessageIndex =
              (_currentMessageIndex + 1) % _loadingMessages.length;
        });
        _startMessageCycle();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.primaryColor ?? const Color(0xFF6366F1);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color,
              color.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated loading indicator
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: RotationTransition(
                              turns: _rotationAnimation,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Icon(
                                    Icons.psychology,
                                    size: 32,
                                    color: color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    // Title
                    Text(
                      widget.title ?? 'Loading',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Animated message
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        widget.message ?? _loadingMessages[_currentMessageIndex],
                        key: ValueKey(_currentMessageIndex),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Progress indicator
                    if (widget.showProgress) ...[
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            if (widget.progress != null) ...[
                              Text(
                                '${(widget.progress! * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: widget.progress,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                minHeight: 4,
                              ),
                            ] else ...[
                              LinearProgressIndicator(
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                minHeight: 4,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ] else ...[
                      // Dots loading indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.4, end: 1.0),
                            duration: Duration(
                              milliseconds: 600 + (index * 200),
                            ),
                            builder: (context, value, child) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(value),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Specific loading screen variations
class QuizLoadingScreen extends LoadingScreen {
  const QuizLoadingScreen({super.key})
      : super(
          title: 'Preparing Quiz',
          message: 'Loading questions and setting up your challenge...',
          showProgress: true,
        );
}

class ProfileLoadingScreen extends LoadingScreen {
  const ProfileLoadingScreen({super.key})
      : super(
          title: 'Setting up Profile',
          message: 'Creating your personalized AIQ experience...',
        );
}

class ResultsLoadingScreen extends LoadingScreen {
  const ResultsLoadingScreen({super.key})
      : super(
          title: 'Calculating Score',
          message: 'Analyzing your responses and computing your AIQ...',
          showProgress: true,
          primaryColor: Color(0xFF10B981),
        );
}