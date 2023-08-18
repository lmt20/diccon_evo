import 'package:diccon_evo/services/thesaurus_service.dart';
import 'package:diccon_evo/views/components/header.dart';
import 'package:diccon_evo/helpers/file_handler.dart';
import 'package:diccon_evo/repositories/thesaurus_repository.dart';
import 'package:diccon_evo/helpers/word_handler.dart';
import 'package:diccon_evo/views/word_history.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../blocs/chat_list/chat_list_bloc.dart';
import '../helpers/image_handler.dart';
import '../properties.dart';
import '../models/word.dart';
import '../helpers/platform_check.dart';
import 'components/suggested_item.dart';
import '../extensions/i18n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DictionaryView extends StatefulWidget {
  const DictionaryView({super.key});

  @override
  State<DictionaryView> createState() => _DictionaryViewState();
}

class _DictionaryViewState extends State<DictionaryView>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _chatListController = ScrollController();
  ImageHandler imageProvider = ImageHandler();
  late List<String> _listSynonyms = [];
  late List<String> _listAntonyms = [];
  late List<String> suggestionWords = [];
  late String imageUrl = '';
  bool hasImages = false;
  bool hasAntonyms = false;
  bool hasSynonyms = false;
  bool hasSuggestionWords = true;
  late String currentSearchWord = '';

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void resetSuggestion() {
    setState(() {
      hasImages = false;
      hasAntonyms = false;
      hasSynonyms = false;
    });
  }

  void scrollToBottom() {
    /// Delay the scroll animation until after the list has been updated
    Future.delayed(const Duration(milliseconds: 300), () {
      _chatListController.animateTo(
        _chatListController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _handleSubmitted(
      String searchWord, BuildContext context, ChatListState state) async {
    searchWord = WordHandler.removeSpecialCharacters(searchWord);
    currentSearchWord = searchWord;
    var chatListBloc = context.read<ChatListBloc>();
    _textController.clear();
    resetSuggestion();
    Word? wordResult;

    /// Add left bubble as user message
    chatListBloc.add(AddUserMessage(providedWord: searchWord));
    try {
      /// Right bubble represent machine reply
      chatListBloc.add(AddLocalTranslation(
        providedWord: searchWord,
        onWordTap: (clickedWord) {
          clickedWord = WordHandler.removeSpecialCharacters(clickedWord);
          _handleSubmitted(clickedWord, context, state);
        },
      ));

      /// Get and add list synonyms to message box
      _listSynonyms = Properties.thesaurusService.getSynonyms(searchWord);
      _listAntonyms = Properties.thesaurusService.getAntonyms(searchWord);
      if (_listSynonyms.isNotEmpty) {
        setState(() {
          hasSynonyms = true;
        });
      }
      if (_listAntonyms.isNotEmpty) {
        setState(() {
          hasAntonyms = true;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception is thrown when searching in dictionary");
      }

      /// When a word can't be found. It'll show a message to notify that error.
      chatListBloc.add(AddSorryMessage());
    }

    /// Find image to show
    imageUrl = await imageProvider.getImageFromPixabay(searchWord);
    if (imageUrl.isNotEmpty) {
      setState(() {
        hasImages = true;
      });
    }

    if (PlatformCheck.isMobile()) {
      // Remove focus out of TextField in DictionaryView
      Properties.textFieldFocusNode.unfocus();
    } else {
      // On desktop we request focus, not on mobile
      Properties.textFieldFocusNode.requestFocus();
    }

    /// Unnecessary task that do not required to be display on screen will be run after all
    /// Delay the scroll animation until after the list has been updated
    scrollToBottom();
    setState(() {
      suggestionWords.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var chatListBloc = context.read<ChatListBloc>();
    return Scaffold(
      appBar: Header(
        title: Properties.dictionary.i18n,
        actions: [
          IconButton(
              onPressed: () {
                // Remove focus out of TextField in DictionaryView
                Properties.textFieldFocusNode.unfocus();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HistoryView()));
              },
              icon: const Icon(Icons.history))
        ],
      ),
      body: BlocBuilder<ChatListBloc, ChatListState>(builder: (context, state) {
        {
          return Column(
            children: [
              Expanded(
                /// List of all bubble messages on a conversation
                child: ListView.builder(
                  itemCount: state.chatList.length,
                  controller: _chatListController,
                  itemBuilder: (BuildContext context, int index) {
                    return state.chatList[index];
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 16,
                        ),
                        hasSuggestionWords
                            ? Row(
                                children: suggestionWords.map((String word) {
                                  return SuggestedItem(
                                    title: word,
                                    backgroundColor: Colors.blue,
                                    onPressed: (String clickedWord) {
                                      _handleSubmitted(
                                          clickedWord, context, state);
                                      suggestionWords.clear();
                                    },
                                  );
                                }).toList(),
                              )
                            : Container(),
                        hasSynonyms
                            ? SuggestedItem(
                                onPressed: (String a) {
                                  chatListBloc.add(AddSynonyms(
                                    providedWord: currentSearchWord,
                                    itemOnPressed: (clickedWord) {
                                      _handleSubmitted(
                                          clickedWord, context, state);
                                    },
                                  ));
                                  scrollToBottom();
                                },
                                title: 'Synonyms'.i18n,
                              )
                            : Container(),
                        hasAntonyms
                            ? SuggestedItem(
                                onPressed: (String a) {
                                  chatListBloc.add(AddAntonyms(
                                    providedWord: currentSearchWord,
                                    itemOnPressed: (clickedWord) {
                                      _handleSubmitted(
                                          clickedWord, context, state);
                                    },
                                  ));
                                  scrollToBottom();
                                },
                                title: 'Antonyms'.i18n,
                              )
                            : Container(),
                        hasImages
                            ? SuggestedItem(
                                title: 'Images'.i18n,
                                onPressed: (String a) {
                                  chatListBloc
                                      .add(AddImage(imageUrl: imageUrl));
                                  scrollToBottom();
                                },
                              )
                            : Container(),
                      ],
                    )),
              ),

              /// TextField for user to enter their words
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextField(
                          focusNode: Properties.textFieldFocusNode,
                          onSubmitted: (providedWord) {
                            _handleSubmitted(providedWord, context, state);
                          },
                          onChanged: (word) {
                            suggestionWords = [];
                            Set<String> listStartWith = {};
                            Set<String> listContains = {};
                            var suggestionLimit = 5;
                            if (word.length > 1) {
                              for (var element
                                  in Properties.suggestionListWord) {
                                if (element.startsWith(word)) {
                                  listStartWith.add(element);
                                  if (listStartWith.length >= suggestionLimit) {
                                    break;
                                  }
                                } else if (element.contains(word) &&
                                    listContains.length < suggestionLimit) {
                                  listContains.add(element);
                                }
                              }

                              suggestionWords =
                                  [...listStartWith, ...listContains].toList();
                              suggestionWords.reversed;
                            }
                            setState(() {
                              suggestionWords;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Send a message".i18n,
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
          );
        }
      }),
    );
  }
}
