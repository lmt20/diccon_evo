import 'dart:async';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:diccon_evo/src/features/features.dart';
import 'package:diccon_evo/src/common/common.dart';

import '../../../common/data/data_providers/searching.dart';
import '../../../common/data/models/word.dart';

part 'dictionary_state.dart';
part 'dictionary_event.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc()
      : super(ChatListUpdated(chatList: [const DictionaryWelcome()])) {
    on<AddTranslation>(_addTranslation);
    on<AddUserMessage>(_addUserMessage);
    on<AddSorryMessage>(_addSorryMessage);
    on<AddSynonyms>(_addSynonymsList);
    on<AddAntonyms>(_addAntonymsList);
    on<AddImage>(_addImage);
    on<ScrollToBottom>(_scrollToBottom);
    on<CreateNewChatlist>(_createNewChatlist);
  }
  List<ChatGptRepository> _listChatGptRepository = [];
  final ScrollController chatListController = ScrollController();
  final TextEditingController textController = TextEditingController();
  List<Widget> _chatList = [const DictionaryWelcome()];
  bool _isReportedAboutDisconnection = false;

  /// Implement Events and Callbacks
  Future<void> _addImage(AddImage event, Emitter<ChatListState> emit) async {
    _chatList.add(ImageBubble(imageUrl: event.imageUrl));
    emit(ChatListUpdated(chatList: _chatList));
    _scrollChatListToBottom();
    emit(ImageAdded());
  }

  void _addSynonymsList(AddSynonyms event, Emitter<ChatListState> emit) {
    var listSynonyms = ThesaurusRepositoryImpl().getSynonyms(event.providedWord);
    _chatList.add(BrickWallButtons(listString: listSynonyms));
    emit(ChatListUpdated(chatList: _chatList));
    _scrollChatListToBottom();
    emit(SynonymsAdded());
  }

  void _addAntonymsList(AddAntonyms event, Emitter<ChatListState> emit) {
    var listAntonyms = ThesaurusRepositoryImpl().getAntonyms(event.providedWord);
    _chatList.add(BrickWallButtons(
        textColor: Colors.orange,
        borderColor: Colors.orangeAccent,
        listString: listAntonyms));
    emit(ChatListUpdated(chatList: _chatList));
    _scrollChatListToBottom();

    emit(AntonymsAdded());
  }

  void _addSorryMessage(AddSorryMessage event, Emitter<ChatListState> emit) {
    _chatList.add(const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("Sorry, we couldn't find this word at this time.")],
    ));
    emit(ChatListUpdated(chatList: _chatList));
    _scrollChatListToBottom();
  }

  void _addUserMessage(AddUserMessage event, Emitter<ChatListState> emit) {
    _chatList.add(UserBubble(
      message: event.providedWord,
      onTap: () {
        textController.text = event.providedWord;
      },
    ));
    emit(ChatListUpdated(chatList: _chatList));
    _scrollChatListToBottom();
  }

  Future<void> _addTranslation(
      AddTranslation event, Emitter<ChatListState> emit) async {
    // Check internet connection before create request to chatbot
    bool isInternetConnected = await InternetConnectionChecker().hasConnection;
    if (kDebugMode) {
      print("[Internet Connection] $isInternetConnected");
    }
    if (Properties.defaultSetting.translationChoice.toTranslationChoice() ==
            TranslationChoices.ai &&
        !isInternetConnected &&
        !_isReportedAboutDisconnection) {
      _chatList.add(const NoInternetBubble());
      emit(ChatListUpdated(chatList: _chatList));
      _isReportedAboutDisconnection = true;
    }
    var newChatGptRepository = ChatGptRepositoryImplement(chatGpt: ChatGpt(apiKey: PropertiesConstants.dictionaryKey));
    _listChatGptRepository.add(newChatGptRepository);
    var chatGptRepositoryIndex = _listChatGptRepository.length - 1;
    var wordResult = await _getLocalTranslation(event.providedWord);
    _chatList.add(CombineBubble(
        wordObjectForLocal: wordResult,
        wordForChatbot: event.providedWord,
        chatListController: chatListController,
        index: chatGptRepositoryIndex,
        listChatGptRepository: _listChatGptRepository));
    emit(ChatListUpdated(chatList: _chatList));
    _scrollChatListToBottom();
  }


  FutureOr<void> _createNewChatlist(CreateNewChatlist event, Emitter<ChatListState> emit){
    _listChatGptRepository = [];
    textController.clear();
    _chatList = [const DictionaryWelcome()];
    emit(ChatListUpdated(chatList: _chatList));
  }
  Future<Word> _getLocalTranslation(String providedWord) async {
    var searchingEngine = SearchingEngine();
    Word? wordResult = await searchingEngine.getDefinition(providedWord);
    if (wordResult != Word.empty()) {
      if (kDebugMode) {
        print("got result from local dictionary");
      }
      return wordResult;
    }
    var badResult = Word(
        word: providedWord,
        definition:
            "Local dictionary don't have definition for this word. Check out AI Dictionary !");
    return badResult;
  }

  FutureOr<void> _scrollToBottom(
      ScrollToBottom event, Emitter<ChatListState> emit) {
    _scrollChatListToBottom();
  }

  void _scrollChatListToBottom() {
    /// Delay the scroll animation until after the list has been updated
    Future.delayed(const Duration(milliseconds: 300), () {
      chatListController.animateTo(
        chatListController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}
