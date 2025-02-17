import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:diccon_evo/src/core/core.dart';
import 'package:diccon_evo/src/presentation/presentation.dart';

class StoryClickableWords extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Function(String word, String sentence)? onWordTap;

  const StoryClickableWords({
    super.key,
    required this.text,
    this.onWordTap,
    this.style,
  });

  @override
  State<StoryClickableWords> createState() => _StoryClickableWordsState();
}

class _StoryClickableWordsState extends State<StoryClickableWords> {
  final StreamController<int> _hoverIndexController = StreamController<int>();

  // New method to find the sentence containing the clicked word
  String getSentenceContainingWord(String clickedWord, List<String> words) {
    for (var i = 0; i < words.length; i++) {
      if (words[i] == clickedWord) {
        // Find the boundaries of the sentence
        int start = i;
        int end = i;
        while (start > 0 && !words[start - 1].endsWith('.')) {
          start--;
        }
        while (end < words.length - 1 && !words[end].endsWith('.')) {
          end++;
        }

        // Extract the sentence
        return words.sublist(start, end + 1).join(' ');
      }
    }
    return '';
  }

  @override
  void dispose() {
    _hoverIndexController.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final List<String> words = widget.text.split(' ');

    return defaultTargetPlatform.isMobile()
        ?
        // We don't want to change cursor or underline text on mobile
        // Which make the performance decrease a lot
        RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              children: [
                for (var i = 0; i < words.length; i++)
                  TextSpan(
                      text: '${words[i]} ',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          if (widget.onWordTap != null) {
                            String sentence = getSentenceContainingWord(words[i], words);
                            widget.onWordTap!(words[i], sentence);
                            // New: Get the sentence and do something with it
                            if (kDebugMode) {
                              print('Clicked word: ${words[i]}, Sentence: $sentence');
                            }
                          }
                        },
                      style: widget.style),
              ],
            ),
          )
        : StreamBuilder(
      stream: _hoverIndexController.stream,
      initialData: -1,
      builder: (context, snapshot) {
        return RichText(
          text: TextSpan(
            children: [
              for (var i = 0; i < words.length; i++)
                TextSpan(
                  text: '${words[i]} ',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (widget.onWordTap != null) {
                        String sentence = getSentenceContainingWord(words[i], words);
                        widget.onWordTap!(words[i], sentence);
                        if (kDebugMode) {
                          print('Clicked word: ${words[i]}, Sentence: $sentence');
                        }
                      }
                    },
                  onEnter: (_) {
                    _hoverIndexController.add(i);
                  },
                  onExit: (_) {
                    _hoverIndexController.add(-1);
                  },
                  style: widget.style ??
                      TextStyle(
                        decoration: snapshot.data == i
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                ),
            ],
          ),
        );
      },
    );
  }
}
