import 'package:flutter/material.dart';

abstract class OnboardingFlowStyler {
  Color get primaryColor;
  Color get backgroundColor;
  Widget buildPage(OnboardingPage page);
  Widget buildProgressIndicator(int currentPage, int totalPages);
}

class ModernOnboardingStyle implements OnboardingFlowStyler {
  @override
  Color get primaryColor => const Color(0xFF6200EE);

  @override
  Color get backgroundColor => Colors.white;

  @override
  Widget buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(page.icon, size: 120, color: primaryColor),
          const SizedBox(height: 48),
          Text(
            page.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildProgressIndicator(int currentPage, int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Container(
          width: index == currentPage ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: index == currentPage ? primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class OnboardingFlow extends StatefulWidget {
  final OnboardingFlowStyler styler;
  final List<OnboardingPage> pages;
  final VoidCallback onComplete;

  const OnboardingFlow({
    Key? key,
    OnboardingFlowStyler? styler,
    List<OnboardingPage>? pages,
    required this.onComplete,
  })  : styler = styler ?? const ModernOnboardingStyle(),
        pages = pages ?? const [],
        super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.pages.isEmpty ? _defaultPages() : widget.pages;

    return Scaffold(
      backgroundColor: widget.styler.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: pages.length,
                itemBuilder: (context, index) =>
                    widget.styler.buildPage(pages[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  widget.styler.buildProgressIndicator(_currentPage, pages.length),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.styler.primaryColor,
                      ),
                      onPressed: () {
                        if (_currentPage == pages.length - 1) {
                          widget.onComplete();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        _currentPage == pages.length - 1 ? 'Get Started' : 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<OnboardingPage> _defaultPages() {
    return [
      OnboardingPage(
        icon: Icons.rocket_launch,
        title: 'Welcome',
        description: 'Get started with our amazing app',
      ),
      OnboardingPage(
        icon: Icons.star,
        title: 'Discover Features',
        description: 'Explore powerful tools at your fingertips',
      ),
      OnboardingPage(
        icon: Icons.check_circle,
        title: 'Ready to Go',
        description: 'Everything is set up and ready',
      ),
    ];
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });
}
