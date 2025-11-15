import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  final Function(String?)? onImageSelected;
  final String? initialImageUrl;
  final double width;
  final double height;

  const CustomPicker({
    Key? key,
    this.onImageSelected,
    this.initialImageUrl,
    this.width = 200,
    this.height = 200,
  }) : super(key: key);

  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
  }

  void _selectImage() {
    // Simulate image selection
    setState(() {
      _imageUrl = 'https://picsum.photos/${widget.width.toInt()}/${widget.height.toInt()}';
    });
    widget.onImageSelected?.call(_imageUrl);
  }

  void _removeImage() {
    setState(() {
      _imageUrl = null;
    });
    widget.onImageSelected?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: _imageUrl != null
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    _imageUrl!,
                    width: widget.width,
                    height: widget.height,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      _buildActionButton(
                        icon: Icons.edit,
                        onPressed: _selectImage,
                      ),
                      const SizedBox(width: 8),
                      _buildActionButton(
                        icon: Icons.delete,
                        onPressed: _removeImage,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: _selectImage,
              borderRadius: BorderRadius.circular(14),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Add Image',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
        color: color ?? Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
      ),
    );
  }
}
