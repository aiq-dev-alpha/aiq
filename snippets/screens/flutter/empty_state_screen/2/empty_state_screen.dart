import 'package:flutter/material.dart';

class EmptyStateScreen extends StatefulWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final String? buttonText;
  final VoidCallback? onAction;
  final Widget? illustration;

  const EmptyStateScreen({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.buttonText,
    this.onAction,
    this.illustration,
  });

  @override
  State<EmptyStateScreen> createState() => _EmptyStateScreenState();
}

class _EmptyStateScreenState extends State<EmptyStateScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Illustration or icon
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: widget.illustration ??
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6B7280).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Icon(
                                widget.icon ?? Icons.inbox,
                                size: 60,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                      ),
                      const SizedBox(height: 32),
                      // Content
                      SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            Text(
                              widget.title ?? 'Nothing here yet',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.message ??
                                  'It looks like there\'s no content to show right now. Try refreshing or come back later.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF6B7280),
                                height: 1.5,
                              ),
                            ),
                            if (widget.onAction != null) ...[
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: widget.onAction,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6366F1),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    widget.buttonText ?? 'Refresh',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
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

// Specific empty state variations
class QuizEmptyState extends EmptyStateScreen {
  const QuizEmptyState({super.key})
      : super(
          title: 'No Quizzes Available',
          message: 'Check back later for new AI challenges and tests to expand your knowledge.',
          icon: Icons.quiz,
          buttonText: 'Refresh',
        );
}

class ResultsEmptyState extends EmptyStateScreen {
  const ResultsEmptyState({super.key})
      : super(
          title: 'No Results Yet',
          message: 'Complete your first quiz to see your AIQ score and progress.',
          icon: Icons.analytics,
          buttonText: 'Take a Quiz',
        );
}

class LeaderboardEmptyState extends EmptyStateScreen {
  const LeaderboardEmptyState({super.key})
      : super(
          title: 'Leaderboard Coming Soon',
          message: 'The leaderboard will show top performers once more users join.',
          icon: Icons.leaderboard,
          buttonText: 'Invite Friends',
        );
}

class NotificationsEmptyState extends EmptyStateScreen {
  const NotificationsEmptyState({super.key})
      : super(
          title: 'No Notifications',
          message: 'You\'re all caught up! We\'ll notify you about new quizzes and achievements.',
          icon: Icons.notifications_none,
        );
}

class SearchEmptyState extends EmptyStateScreen {
  const SearchEmptyState({super.key})
      : super(
          title: 'No Results Found',
          message: 'Try adjusting your search terms or browse our available categories.',
          icon: Icons.search_off,
          buttonText: 'Browse Categories',
        );
}