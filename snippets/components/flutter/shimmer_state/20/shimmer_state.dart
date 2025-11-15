import 'package:flutter/material.dart';

class StateComponent extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color iconColor;
  final Widget? action;
  
  const StateComponent({
    Key? key,
    required this.message,
    this.icon = Icons.info_outline,
    this.iconColor = Colors.grey,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: iconColor),
          const SizedBox(height: 24),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          if (action != null) ...[
            const SizedBox(height: 32),
            action!,
          ],
        ],
      ),
    );
  }

  factory StateComponent.empty({String? message, Widget? action}) {
    return StateComponent(
      message: message ?? 'No data available',
      icon: Icons.inbox_outlined,
      iconColor: Colors.grey,
      action: action,
    );
  }

  factory StateComponent.loading({String? message}) {
    return StateComponent(
      message: message ?? 'Loading...',
      icon: Icons.hourglass_empty,
      iconColor: Colors.blue,
    );
  }

  factory StateComponent.error({String? message, Widget? action}) {
    return StateComponent(
      message: message ?? 'Something went wrong',
      icon: Icons.error_outline,
      iconColor: Colors.red,
      action: action,
    );
  }
}
