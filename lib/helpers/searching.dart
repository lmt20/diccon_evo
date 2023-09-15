import 'package:diccon_evo/extensions/string.dart';
import 'package:flutter/foundation.dart';

import '../config/properties.dart';
import '../models/word.dart';
import 'history_manager.dart';

class Searching {
  static Word? getDefinition(String searchWord) {
    var refineWord = searchWord.removeSpecialCharacters().trim();
    if (kDebugMode) {
      print("refined word:$refineWord");
    }
    for (int i = 0; i < Properties.wordList.length; i++) {
      String word = Properties.wordList[i].word;
      if (word.startsWith("$refineWord${Properties.blankSpace}")) {
        /// Add found word to history file
        HistoryManager.saveWordToHistory(Properties.wordList[i]);
        return Properties.wordList[i];
      }
      if (word.startsWith(refineWord.substring(0, refineWord.length - 1)) &&
          (refineWord.lastIndexOf('s') == (refineWord.length - 1))) {
        /// Add found word to history file
        HistoryManager.saveWordToHistory(Properties.wordList[i]);
        return Properties.wordList[i];
      }
      if (word.startsWith(refineWord)) {
        /// Add found word to history file
        HistoryManager.saveWordToHistory(Properties.wordList[i]);
        return Properties.wordList[i];
      }
    }
    return null;
  }
}
