import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final Function(List<String>)? onFilesSelected;
  final List<String> allowedExtensions;
  final bool multiple;
  final Color? backgroundColor;
  final IconData? icon;

  const CustomButton({
    Key? key,
    this.label = 'Upload Files',
    this.onFilesSelected,
    this.allowedExtensions = const [],
    this.multiple = false,
    this.backgroundColor,
    this.icon,
  }) : super(key: key);
  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isDragging = false;

  void _handleUpload() {
    // Simulate file selection
    final files = ['example_file.pdf'];
    widget.onFilesSelected?.call(files);
  }
  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: _handleUpload,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isDragging = true),
        onExit: (_) => setState(() => _isDragging = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: _isDragging ? bgColor.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: _isDragging ? bgColor : Colors.grey.shade300,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon ?? Icons.cloud_upload,
                size: 64,
                color: _isDragging ? bgColor : Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _isDragging ? bgColor : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Drag and drop files here or click to browse',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.allowedExtensions.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Allowed: ${widget.allowedExtensions.join(', ')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
