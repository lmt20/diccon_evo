import 'dart:ui';

import 'package:diccon_evo/extensions/sized_box.dart';
import 'package:flutter/material.dart';
import 'circle_button.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    this.actions,
    this.title,
  });

  final List<Widget>? actions;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          // Blur layers
          BackdropFilter(filter: ImageFilter.blur(
            sigmaX: 4.0, sigmaY: 4.0,
          ),
          child: Container(),
          ),
          // Gradient layers
  Container(
    height: 81,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).appBarTheme.backgroundColor!,
            Theme.of(context).appBarTheme.backgroundColor!,
            Theme.of(context).appBarTheme.backgroundColor!,
            Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.9),
            Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.5),
          ]
        )
      ),
  ),
          // Child layers
          Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleButton(
                    iconData: Icons.arrow_back,
                    onTap: () {
                      Navigator.pop(context);
                    }),
                const SizedBox().mediumWidth(),
                title != null
                    ? Text(
                        title!,
                        style: const TextStyle(fontSize: 28),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  width: 16,
                ),
                const Spacer(),
                actions != null
                    ? Row(
                        children: actions!,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
