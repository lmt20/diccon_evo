import 'package:diccon_evo/components/header.dart';
import 'package:diccon_evo/components/welcome_box.dart';
import 'package:diccon_evo/viewModels/file_handler.dart';
import 'package:diccon_evo/viewModels/word_handler.dart';
import 'package:translator/translator.dart';
import 'package:flutter/material.dart';

import '../global.dart';
import '../models/word.dart';
import '../components/dictionary_buble.dart';
import '../viewModels/searching.dart';

class DictionaryView extends StatefulWidget {
  const DictionaryView({super.key});

  @override
  _DictionaryViewState createState() => _DictionaryViewState();
}

class _DictionaryViewState extends State<DictionaryView>
    with AutomaticKeepAliveClientMixin {
  final List<Widget> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _chatListController = ScrollController();
  final FocusNode _textFieldFocusNode = FocusNode();
  final translator = GoogleTranslator();

  @override
  void initState() {
    // TODO: implement initState
    _messages.add(WelcomeBox());

    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Future<Translation> translate(String word) async {
    return await translator.translate(word, from: 'auto', to: 'vi');
  }

  void _handleSubmitted(String searchWord) async {
    _textController.clear();
    Word? wordResult;
    var emptyWord = Word(word: searchWord);

    /// Add left bubble as user message
    _messages.add(DictionaryBubble(isMachine: false, message: emptyWord));
    try {
      /// This line is the skeleton of finding word in dictionary
      wordResult = Searching.getDefinition(searchWord);
      print(wordResult);
      if (wordResult!= null) {
        /// Right bubble represent machine reply
        _messages.add(DictionaryBubble(
          isMachine: true,
          message: wordResult!,
          onWordTap: (clickedWord) {
            clickedWord = WordHandler.removeSpecialCharacters(clickedWord);
            _handleSubmitted(clickedWord);
          },
        ));

        /// Add found word to history file
        await FileHandler.saveToHistory(wordResult);
      }
      else {
        await translate(searchWord).then((translatedWord) {
          _messages.add(DictionaryBubble(
            isMachine: true,
            message: Word(word: searchWord, meaning: translatedWord.text),
            onWordTap: (clickedWord) {
              clickedWord = WordHandler.removeSpecialCharacters(clickedWord);
              _handleSubmitted(clickedWord);
            },
          ));
        });
      }
    } catch (e) {
      print("Exception is thrown when searching in dictionary");
      /// When a word can't be found. It'll show a message to notify that error.
      _messages.add(const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Sorry, we couldn't find this word at this time.")
        ],
      ));
    }
    setState(() {});
    _textFieldFocusNode.requestFocus();

    /// Delay the scroll animation until after the list has been updated
    Future.delayed(const Duration(milliseconds: 300), () {
      _chatListController.animateTo(
        _chatListController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: Header(title: Global.DICTIONARY, icon: Icons.search, actions: [
        IconButton(onPressed: (){
          Global.pageController.jumpToPage(AppViews.historyView.index);
        }, icon: Icon(Icons.history))
      ],),
      body: Column(
        children: [

          Expanded(
            /// List of all bubble messages on a conversation
            child: ListView.builder(
              itemCount: _messages.length,
              controller: _chatListController,
              itemBuilder: (BuildContext context, int index) {
                return _messages[index];
              },
            ),
          ),

          /// TextField for user to enter their words
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                      //focusNode: _textFieldFocusNode,
                      onSubmitted: (value) {
                        _handleSubmitted(value);
                      },
                      decoration: InputDecoration(
                        hintText: "Send a message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      controller: _textController,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
