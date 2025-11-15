import 'package:flutter/material.dart';

class ControlComponent extends StatefulWidget {
  final Color activeColor;
  final Color inactiveColor;
  final List<String> options;
  final Function(int)? onChanged;
  
  const ControlComponent({
    Key? key,
    this.activeColor = const Color(0xFF6200EE),
    this.inactiveColor = Colors.grey,
    this.options = const [],
    this.onChanged,
  }) : super(key: key);

  @override
  State<ControlComponent> createState() => _ControlComponentState();
}

class _ControlComponentState extends State<ControlComponent> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final items = widget.options.isEmpty
        ? ['Option 1', 'Option 2', 'Option 3']
        : widget.options;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        items.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(items[index]),
            selected: _selected == index,
            selectedColor: widget.activeColor,
            onSelected: (selected) {
              if (selected) {
                setState(() => _selected = index);
                widget.onChanged?.call(index);
              }
            },
          ),
        ),
      ),
    );
  }
}
