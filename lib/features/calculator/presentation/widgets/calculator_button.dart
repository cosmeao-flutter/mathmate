import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';
import 'package:math_mate/core/constants/responsive_dimensions.dart';
import 'package:math_mate/core/theme/calculator_colors.dart';
import 'package:math_mate/features/settings/presentation/cubit/accessibility_cubit.dart';

/// Defines the visual style variants for calculator buttons.
///
/// Each type has different background and text colors to help users
/// visually distinguish between different button categories.
enum CalculatorButtonType {
  /// Number buttons (0-9) - white background, dark text.
  number,

  /// Operator buttons (+, −, ×, ÷) - blue background, white text.
  operator,

  /// Function buttons (C, %, ±, parentheses) - gray background, dark text.
  function,

  /// Equals button - blue background, white text (same as operator).
  equals,
}

/// A reusable calculator button widget with press animation and haptic feedback.
///
/// This widget provides:
/// - Rounded rectangle shape per PRD specifications
/// - Press animation (scales to 0.95 when pressed)
/// - Color variants based on [CalculatorButtonType]
/// - Haptic feedback on press
/// - Accessibility support with semantic labels
///
/// Example usage:
/// ```dart
/// CalculatorButton(
///   label: '7',
///   onPressed: () => bloc.add(DigitPressed('7')),
///   type: CalculatorButtonType.number,
///   semanticLabel: 'Seven',
/// )
/// ```
class CalculatorButton extends StatefulWidget {
  /// Creates a calculator button.
  ///
  /// The [label] parameter is required and specifies the text to display.
  /// The [onPressed] callback is triggered when the button is tapped.
  /// If [onPressed] is null, the button will be disabled.
  const CalculatorButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.type = CalculatorButtonType.number,
    this.semanticLabel,
    this.dimensions,
  });

  /// The text to display on the button (e.g., "7", "+", "C").
  final String label;

  /// Callback triggered when the button is pressed.
  /// If null, the button is disabled.
  final VoidCallback? onPressed;

  /// The visual style variant of the button.
  /// Defaults to [CalculatorButtonType.number].
  final CalculatorButtonType type;

  /// Optional semantic label for screen readers.
  /// If not provided, [label] is used.
  final String? semanticLabel;

  /// Optional responsive dimensions for scaling button size and font.
  /// When null, falls back to [AppDimensions] defaults.
  final ResponsiveDimensions? dimensions;

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin {
  /// Animation controller for the press scale animation.
  late AnimationController _animationController;

  /// The scale animation (1.0 → 0.95 → 1.0).
  late Animation<double> _scaleAnimation;

  /// Whether the button is currently being pressed.
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDimensions.animationFast),
    );

    // Create scale animation with ease curve
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: AppDimensions.buttonPressedScale,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Returns the background color based on button type and theme.
  Color _backgroundColor(CalculatorColors colors) {
    switch (widget.type) {
      case CalculatorButtonType.number:
        return colors.numberButton;
      case CalculatorButtonType.operator:
        return colors.operatorButton;
      case CalculatorButtonType.function:
        return colors.functionButton;
      case CalculatorButtonType.equals:
        return colors.equalsButton;
    }
  }

  /// Returns the text color based on button type and theme.
  Color _textColor(CalculatorColors colors) {
    switch (widget.type) {
      case CalculatorButtonType.number:
        return colors.textOnNumber;
      case CalculatorButtonType.operator:
        return colors.textOnOperator;
      case CalculatorButtonType.function:
        return colors.textOnFunction;
      case CalculatorButtonType.equals:
        return colors.textOnEquals;
    }
  }

  /// Handles the start of a press gesture.
  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed == null) return;

    setState(() => _isPressed = true);

    // Get accessibility settings
    final a11yState = context.read<AccessibilityCubit>().state;

    // Only animate if reduce motion is disabled
    if (!a11yState.reduceMotion) {
      _animationController.forward();
    }

    // Trigger haptic feedback if enabled
    if (a11yState.hapticFeedback) {
      HapticFeedback.lightImpact();
    }

    // Sound feedback would be played here if enabled
    // (requires audioplayers package - can be added later)
  }

  /// Handles the end of a press gesture.
  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed == null) return;

    setState(() => _isPressed = false);

    // Only animate if reduce motion is disabled
    final reduceMotion = context.read<AccessibilityCubit>().state.reduceMotion;
    if (!reduceMotion) {
      _animationController.reverse();
    }
  }

  /// Handles when a press gesture is cancelled.
  void _onTapCancel() {
    if (widget.onPressed == null) return;

    setState(() => _isPressed = false);

    // Only animate if reduce motion is disabled
    final reduceMotion = context.read<AccessibilityCubit>().state.reduceMotion;
    if (!reduceMotion) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get calculator colors from theme extension
    final colors = Theme.of(context).extension<CalculatorColors>()!;

    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      button: true,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.diagonal3Values(
                _scaleAnimation.value,
                _scaleAnimation.value,
                1,
              ),
              child: child,
            );
          },
          child: Material(
            color: _backgroundColor(colors),
            borderRadius: BorderRadius.circular(
              widget.dimensions?.buttonBorderRadius ??
                  AppDimensions.buttonBorderRadius,
            ),
            elevation: _isPressed ? 0 : AppDimensions.buttonElevation,
            child: Container(
              constraints: BoxConstraints(
                minHeight: widget.dimensions?.buttonHeight ??
                    AppDimensions.buttonHeight,
                minWidth: widget.dimensions?.buttonMinSize ??
                    AppDimensions.buttonMinSize,
              ),
              alignment: Alignment.center,
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: widget.dimensions?.fontSizeButton ??
                      AppDimensions.fontSizeButton,
                  fontWeight: FontWeight.w500,
                  color: _textColor(colors),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
