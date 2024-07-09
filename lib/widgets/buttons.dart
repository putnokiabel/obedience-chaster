import 'package:flutter/material.dart';

class LargePrimaryPillButton extends StatelessWidget {
  const LargePrimaryPillButton({
    super.key,
    required this.onPressed,
    this.style,
    this.enabled = true,
    this.elevation = 3,
    required this.child,
  });

  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool enabled;
  final double elevation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: (style ?? const ButtonStyle()).copyWith(
        minimumSize: const ButtonSizeOverride.large(),
        shape: const ButtonShapeOverride.pill(),
        backgroundColor: ButtonColorOverride(
          enabled
              ? colorScheme.primary
              : colorScheme.onSurface.withOpacity(0.04),
        ),
        foregroundColor: ButtonColorOverride(
          enabled
              ? colorScheme.onPrimary
              : colorScheme.onPrimary.withOpacity(0.48),
        ),
        overlayColor: ButtonColorOverride(
          colorScheme.onPrimary.withOpacity(enabled ? 0.08 : 0),
        ),
        elevation: ButtonElevationOverride(enabled ? elevation : 0),
        textStyle: const ButtonTextStyleOverride(
          TextStyle(
            fontFamily: 'Figtree',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      child: child,
    );
  }
}

class PrimaryPillButton extends StatelessWidget {
  const PrimaryPillButton({
    super.key,
    required this.onPressed,
    this.style,
    this.enabled = true,
    this.elevation = 3,
    required this.child,
  });

  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool enabled;
  final double elevation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: (style ?? const ButtonStyle()).copyWith(
        shape: const ButtonShapeOverride.pill(),
        backgroundColor: ButtonColorOverride(
          enabled
              ? colorScheme.primary
              : colorScheme.onSurface.withOpacity(0.04),
        ),
        foregroundColor: ButtonColorOverride(
          enabled
              ? colorScheme.onPrimary
              : colorScheme.onPrimary.withOpacity(0.48),
        ),
        overlayColor: ButtonColorOverride(
          colorScheme.onPrimary.withOpacity(enabled ? 0.08 : 0),
        ),
        elevation: ButtonElevationOverride(enabled ? elevation : 0),
        textStyle: const ButtonTextStyleOverride(
          TextStyle(
            fontFamily: 'Figtree',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      child: child,
    );
  }
}

class SecondaryPillButton extends StatelessWidget {
  const SecondaryPillButton({
    super.key,
    required this.onPressed,
    this.style,
    this.enabled = true,
    this.elevation = 3,
    required this.child,
  });

  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool enabled;
  final double elevation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: (style ?? const ButtonStyle()).copyWith(
        shape: const ButtonShapeOverride.pill(),
        backgroundColor: ButtonColorOverride(
          enabled
              ? colorScheme.secondary
              : colorScheme.onSurface.withOpacity(0.04),
        ),
        foregroundColor: ButtonColorOverride(
          enabled
              ? colorScheme.onSecondary
              : colorScheme.onSecondary.withOpacity(0.48),
        ),
        overlayColor: ButtonColorOverride(
          colorScheme.onSecondary.withOpacity(enabled ? 0.08 : 0),
        ),
        elevation: ButtonElevationOverride(enabled ? elevation : 0),
        textStyle: const ButtonTextStyleOverride(
          TextStyle(
            fontFamily: 'Figtree',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      child: child,
    );
  }
}

class LargeFlatPillButton extends StatelessWidget {
  const LargeFlatPillButton({
    super.key,
    required this.onPressed,
    this.style,
    this.enabled = true,
    this.showBackground = false,
    required this.child,
  });

  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool enabled;
  final bool showBackground;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: onPressed,
      style: (style ?? const ButtonStyle()).copyWith(
        minimumSize: const ButtonSizeOverride.large(),
        shape: const ButtonShapeOverride.pill(),
        foregroundColor: ButtonColorOverride(
          colorScheme.onSurface.withOpacity(enabled ? 0.8 : 0.48),
        ),
        backgroundColor: !showBackground
            ? null
            : ButtonColorOverride(
                colorScheme.onSurface.withOpacity(0.04),
              ),
        overlayColor: ButtonColorOverride(
          colorScheme.onPrimary.withOpacity(0.04),
        ),
        textStyle: const ButtonTextStyleOverride(
          TextStyle(
            fontFamily: 'Figtree',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      child: DefaultTextStyle.merge(
        textAlign: TextAlign.center,
        child: child,
      ),
    );
  }
}

class FlatPillButton extends StatelessWidget {
  const FlatPillButton({
    super.key,
    required this.onPressed,
    this.style,
    this.enabled = true,
    this.showBackground = false,
    required this.child,
  });

  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final bool enabled;
  final bool showBackground;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: onPressed,
      style: (style ?? const ButtonStyle()).copyWith(
        minimumSize: const ButtonSizeOverride(Size.square(48)),
        shape: const ButtonShapeOverride.pill(),
        foregroundColor: ButtonColorOverride(
          colorScheme.onSurface.withOpacity(enabled ? 0.8 : 0.48),
        ),
        backgroundColor: !showBackground
            ? null
            : ButtonColorOverride(
                colorScheme.onSurface.withOpacity(0.04),
              ),
        overlayColor: ButtonColorOverride(
          colorScheme.onPrimary.withOpacity(0.04),
        ),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
        textStyle: const ButtonTextStyleOverride(
          TextStyle(
            fontFamily: 'Figtree',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      child: child,
    );
  }
}

class FlatIconButton extends StatelessWidget {
  const FlatIconButton({
    super.key,
    required this.onPressed,
    this.style,
    this.enabled = true,
    this.showBackground = true,
    required this.tooltip,
    required this.child,
  });

  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final String? tooltip;
  final bool enabled;
  final bool showBackground;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onPressed,
      style: (style ?? const ButtonStyle()).merge(
        ButtonStyle(
          minimumSize: const ButtonSizeOverride(Size(56, 56)),
          shape: ButtonShapeOverride(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          backgroundColor: !showBackground
              ? null
              : ButtonColorOverride(colorScheme.onSurface.withOpacity(0.04)),
          foregroundColor: ButtonColorOverride(
            enabled
                ? colorScheme.onSurface
                : colorScheme.onSurface.withOpacity(0.48),
          ),
          overlayColor: ButtonColorOverride(
            colorScheme.onPrimary.withOpacity(enabled ? 0.04 : 0),
          ),
        ),
      ),
      tooltip: tooltip,
      icon: child,
    );
  }
}

class ButtonElevationOverride implements WidgetStateProperty<double?> {
  const ButtonElevationOverride(this.elevation);

  final double elevation;

  @override
  double? resolve(Set<WidgetState> states) {
    return states.contains(WidgetState.pressed) && elevation > 1
        ? elevation - 1
        : elevation;
  }
}

class ButtonColorOverride implements WidgetStateProperty<Color?> {
  const ButtonColorOverride(this.color);

  final Color color;

  @override
  Color? resolve(Set<WidgetState> states) {
    return color;
  }
}

class ButtonTextStyleOverride implements WidgetStateProperty<TextStyle?> {
  const ButtonTextStyleOverride(this.style);

  final TextStyle style;

  @override
  TextStyle? resolve(Set<WidgetState> states) {
    return style;
  }
}

class ButtonSizeOverride implements WidgetStateProperty<Size?> {
  const ButtonSizeOverride(this.size);

  const ButtonSizeOverride.large() : size = const Size(248, 60);

  final Size size;

  @override
  Size? resolve(Set<WidgetState> states) {
    return size;
  }
}

class ButtonShapeOverride implements WidgetStateProperty<OutlinedBorder?> {
  const ButtonShapeOverride(this.border);

  const ButtonShapeOverride.pill()
      : border = const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        );

  final OutlinedBorder border;

  @override
  OutlinedBorder? resolve(Set<WidgetState> states) {
    return border;
  }
}
