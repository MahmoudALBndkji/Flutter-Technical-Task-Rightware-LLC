import 'package:flutter/material.dart';

/// Wraps a child with staggered fade and slide transitions for settings screen.
class SettingsAnimatedSection extends StatelessWidget {
  const SettingsAnimatedSection({
    super.key,
    required this.fade,
    required this.slide,
    required this.child,
  });

  final Animation<double> fade;
  final Animation<Offset> slide;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: child,
      ),
    );
  }
}
