import 'package:diccon_evo/views/components/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../cubits/setting_cubit.dart';
import '../models/setting.dart';
import '../views/components/setting_section.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(
        icon: Icons.settings,
        title: "Settings",
      ),
      body: BlocBuilder<SettingCubit, Setting>(builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SettingSection(title: 'Dictionary Section', children: [
                  Row(children: [
                    const Text("Number of synonyms"),
                    const SizedBox(
                      width: 8,
                    ),
                    DropdownButton<int>(
                      focusColor: Colors.white,
                      value: state.numberOfSynonyms,
                      hint: const Text('Select a number'),
                      onChanged: (int? newValue) {
                        context
                            .read<SettingCubit>()
                            .setNumberOfSynonyms(newValue!);
                      },
                      items: [
                        DropdownMenuItem<int>(
                          value: 10,
                          child: Text(10.toString()),
                        ),
                        DropdownMenuItem<int>(
                          value: 20,
                          child: Text(20.toString()),
                        ),
                        DropdownMenuItem<int>(
                          value: 30,
                          child: Text(30.toString()),
                        ),
                      ],
                    ),
                  ]),
                  Row(children: [
                    const Text("Number of antonyms"),
                    const SizedBox(
                      width: 8,
                    ),
                    DropdownButton<int>(
                      focusColor: Colors.white,
                      value: state.numberOfAntonyms,
                      hint: const Text('Select a number'),
                      onChanged: (int? newValue) {
                        context
                            .read<SettingCubit>()
                            .setNumberOfAntonyms(newValue!);
                      },
                      items: [
                        DropdownMenuItem<int>(
                          value: 10,
                          child: Text(10.toString()),
                        ),
                        DropdownMenuItem<int>(
                          value: 20,
                          child: Text(20.toString()),
                        ),
                        DropdownMenuItem<int>(
                          value: 30,
                          child: Text(30.toString()),
                        ),
                      ],
                    ),
                  ])
                ]),
                SettingSection(
                  title: 'Reading Section',
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.text_increase),
                        Slider(
                            min: 0.1,
                            value: state.readingFontSize! / 70,
                            onChanged: (newValue) {
                              context
                                  .read<SettingCubit>()
                                  .setReadingFontSize(newValue * 70);
                            }),
                      ],
                    ),
                    Text(
                      "Sample text that will be displayed on Reading.",
                      style: TextStyle(fontSize: state.readingFontSize),
                    )
                  ],
                ),
                const SettingSection(
                  title: "About",
                  children: [
                    Row(
                      children: [
                        Text("Diccon Evo", style: TextStyle()),

                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text("© 2023 Zeroboy. All rights reserved."),
                        Spacer(),
                        Text("1.1.1"),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    const Text(
                      "Available at",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      height: 200,
                      width: 370,
                      child: GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        children: [
                          microsoftStoreBadge(),
                          amazonStoreBadge(),
                          playStoreBadge(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget playStoreBadge() {
    return InkWell(
      onTap: () async {
        final Uri url = Uri.parse(
            'https://play.google.com/store/apps/details?id=com.zeroboy.diccon_evo');
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
        }
      }, // Replace with your image path

      child: Image.asset(
        "assets/badges/en_badge_web_generic.png",
      ),
    );
  }

  Widget amazonStoreBadge() {
    return InkWell(
      onTap: () async {
        final Uri url =
            Uri.parse('https://www.amazon.com/dp/B0CBP3XSQJ/ref=apps_sf_sta');
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
        }
      }, // Replace with your image path

      child: Image.asset(
        "assets/badges/amazon-appstore-badge-english-white.png",
      ),
    );
  }

  Widget microsoftStoreBadge() {
    return InkWell(
      onTap: () async {
        final Uri url = Uri.parse(
            'https://apps.microsoft.com/store/detail/diccon-evo/9NPF4HBMNG5D');
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
        }
      }, // Replace with your image path

      child: SvgPicture.asset(
        "assets/badges/ms-en-US-dark.svg",
      ),
    );
  }
}
