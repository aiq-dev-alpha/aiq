import 'package:flutter/material.dart';

class ScreenWidget extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color textColor;

  const ScreenWidget({
    Key? key,
    this.primaryColor = const Color(0xFF3B82F6),
    this.secondaryColor = const Color(0xFF8B5CF6),
    this.backgroundColor = const Color(0xFFF9FAFB),
    this.surfaceColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF111827),
  }) : super(key: key);

  @override
  State<ScreenWidget> createState() => _ScreenWidgetState();
}

class _ScreenWidgetState extends State<ScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: widget.primaryColor,
        title: const Text('Screen'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Content area',
                    style: TextStyle(color: widget.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
