import 'package:diccon_evo/src/core/core.dart';
import 'package:diccon_evo/src/presentation/presentation.dart';

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
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                    context.theme.colorScheme.primary,
                    BlendMode.srcIn),
                child: Image(
                  image: AssetImage(LocalDirectory.getRandomIllustrationImage()),
                  height: 180,
                ),
              ),
              const VerticalSpacing.large(),
              Text(
                "TitleWordInDictionaryWelcomeBox".i18n,
                style: context.theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const VerticalSpacing.medium(),
              Opacity(
                opacity: 0.5,
                child: Text(
                  "SubWordInDictionaryWelcomeBox".i18n,
                  style: context.theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
