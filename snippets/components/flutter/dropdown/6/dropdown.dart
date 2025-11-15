import 'package:flutter/material.dart';

class DropdownConfig {
  final Color borderColor;
  final Color fillColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;

  const DropdownConfig({
    this.borderColor = const Color(0xFFE0E0E0),
    this.fillColor = Colors.white,
    this.textColor = Colors.black87,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });
}

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final DropdownConfig? config;

  const CustomDropdown({
    Key? key,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? const DropdownConfig();

    return Container(
      decoration: BoxDecoration(
        color: effectiveConfig.fillColor,
        borderRadius: BorderRadius.circular(effectiveConfig.borderRadius),
        border: Border.all(color: effectiveConfig.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: hint != null
              ? Padding(
                  padding: effectiveConfig.padding,
                  child: Text(hint!, style: TextStyle(color: Colors.grey[600])),
                )
              : null,
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item.value,
                    child: Padding(
                      padding: effectiveConfig.padding,
                      child: Row(
                        children: [
                          if (item.icon != null) ...[
                            Icon(item.icon, size: 20, color: effectiveConfig.textColor),
                            const SizedBox(width: 12),
                          ],
                          Text(
                            item.label,
                            style: TextStyle(color: effectiveConfig.textColor),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          icon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(Icons.arrow_drop_down, color: effectiveConfig.textColor),
          ),
        ),
      ),
    );
  }
}

class DropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  DropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });
}
