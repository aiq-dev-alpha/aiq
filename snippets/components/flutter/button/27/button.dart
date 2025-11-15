import 'package:flutter/material.dart';

abstract class ButtonStyler {
  Color getBackgroundColor(ButtonState state);
  Color getTextColor(ButtonState state);
  BorderRadius get borderRadius;
  EdgeInsets get padding;
  TextStyle get textStyle;
}

enum ButtonState { normal, disabled, loading }

class GradientButtonStyle implements ButtonStyler {
  final List<Color> gradientColors;

  const GradientButtonStyle({
    this.gradientColors = const [Color(0xFF6200EE), Color(0xFF3700B3)],
  });

  @override
  Color getBackgroundColor(ButtonState state) => Colors.transparent;

  @override
  Color getTextColor(ButtonState state) => Colors.white;

  @override
  BorderRadius get borderRadius => BorderRadius.circular(24);

  @override
  EdgeInsets get padding => const EdgeInsets.symmetric(horizontal: 32, vertical: 12);

  @override
  TextStyle get textStyle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final ButtonStyler styler;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.label,
    this.onTap,
    ButtonStyler? styler,
    this.isLoading = false,
  })  : styler = styler ?? const GradientButtonStyle(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = isLoading
        ? ButtonState.loading
        : (onTap == null ? ButtonState.disabled : ButtonState.normal);

    return GestureDetector(
      onTap: state == ButtonState.normal ? onTap : null,
      child: Container(
        padding: styler.padding,
        decoration: BoxDecoration(
          gradient: styler is GradientButtonStyle
              ? LinearGradient(colors: (styler as GradientButtonStyle).gradientColors)
              : null,
          color: styler is! GradientButtonStyle ? styler.getBackgroundColor(state) : null,
          borderRadius: styler.borderRadius,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(styler.getTextColor(state)),
                  ),
                )
              : Text(
                  label,
                  style: styler.textStyle.copyWith(color: styler.getTextColor(state)),
                ),
        ),
      ),
    );
  }
}
