import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  final List<String> allowedExtensions;
  final Function(List<PickedFile>)? onFilesSelected;
  final bool multipleFiles;

  const CustomPicker({
    Key? key,
    this.allowedExtensions = const [],
    this.onFilesSelected,
    this.multipleFiles = false,
  }) : super(key: key);
  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class PickedFile {
  final String name;
  final int size;
  final String extension;

  const PickedFile({
    required this.name,
    required this.size,
    required this.extension,
  });
}

class _CustomPickerState extends State<CustomPicker> {
  final List<PickedFile> _selectedFiles = [];

  void _handleFilePick() {
    // Simulate file picking
    setState(() {
      _selectedFiles.add(
        PickedFile(
          name: 'example_file.pdf',
          size: 1024 * 512,
          extension: 'pdf',
        ),
      );
    });
    widget.onFilesSelected?.call(_selectedFiles);
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
    widget.onFilesSelected?.call(_selectedFiles);
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: _handleFilePick,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Click to upload files',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'or drag and drop',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
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
          if (_selectedFiles.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...List.generate(_selectedFiles.length, (index) {
              final file = _selectedFiles[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.insert_drive_file,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _formatFileSize(file.size),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => _removeFile(index),
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
