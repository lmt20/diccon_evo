import 'package:diccon_evo/extensions/i18n.dart';
import 'package:diccon_evo/extensions/sized_box.dart';
import 'package:flutter/material.dart';

class DictionaryWelcome extends StatelessWidget {
  const DictionaryWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/stickers/book.png'),
                height: 180,
              ),
              const SizedBox().mediumHeight(),
              Text(
                "TitleWordInDictionaryWelcomeBox".i18n,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox().mediumHeight(),
              Opacity(
                opacity: 0.5,
                child: Text(
                  "SubWordInDictionaryWelcomeBox".i18n,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
