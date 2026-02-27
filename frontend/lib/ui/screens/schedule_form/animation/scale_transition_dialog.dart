import 'package:flutter/material.dart';

class ScaleTransitionDialog extends StatelessWidget {
  final Widget child;
  const ScaleTransitionDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(child: child);
  }

  static void show(BuildContext context, Widget content) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => content,
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }
}
