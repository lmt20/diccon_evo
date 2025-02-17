import 'package:diccon_evo/src/core/core.dart';
import 'package:diccon_evo/src/presentation/presentation.dart';
import 'package:flutter/material.dart';

class GetMoreButton extends StatelessWidget {
  final VoidCallback onTap;
  const GetMoreButton({
    super.key, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: context.theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(32)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Get more',
              style: TextStyle(
                  color: context.theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.chevron_right,
              color: context.theme.colorScheme.onPrimary,
            )
          ],
        ),
      ),
    );
  }
}
