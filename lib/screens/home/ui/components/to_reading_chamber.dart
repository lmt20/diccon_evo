import 'package:diccon_evo/extensions/i18n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'feature_button.dart';

class ToReadingChamberButton extends StatelessWidget {
  const ToReadingChamberButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FeatureButton(
      onTap: () {
        context.pushNamed('reading-chamber');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "199",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            "stories to read".i18n,
          ),
          const Spacer(),
          Text(
            "For all levels and audiences".i18n,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
