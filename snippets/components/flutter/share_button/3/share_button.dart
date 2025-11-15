import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final List<ShareOption>? shareOptions;
  final Color? color;
  final double size;
  final String? label;

  const CustomButton({
    Key? key,
    this.onPressed,
    this.shareOptions,
    this.color,
    this.size = 40,
    this.label,
  }) : super(key: key);
  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class ShareOption {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  const ShareOption({
    required this.name,
    required this.icon,
    required this.onTap,
  });
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  bool _showOptions = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleOptions() {
    setState(() {
      _showOptions = !_showOptions;
      if (_showOptions) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).primaryColor;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (widget.label != null)
          ElevatedButton.icon(
            onPressed: widget.shareOptions != null ? _toggleOptions : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Icon(Icons.share, size: widget.size * 0.6),
            label: Text(
              widget.label!,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          )
        else
          IconButton(
            onPressed: widget.shareOptions != null ? _toggleOptions : widget.onPressed,
            icon: Icon(Icons.share, size: widget.size, color: color),
          ),
        if (_showOptions && widget.shareOptions != null)
          Positioned(
            top: -60,
            left: 0,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.shareOptions!.map((option) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: IconButton(
                            onPressed: () {
                              option.onTap();
                              _toggleOptions();
                            },
                            icon: Icon(option.icon),
                            tooltip: option.name,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
