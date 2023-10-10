import 'dart:async';
import 'package:diccon_evo/data/repositories/chat_gpt_repository.dart';
import 'package:diccon_evo/extensions/string.dart';
import 'package:diccon_evo/screens/dictionary/ui/components/combine_bubble.dart';
import 'package:diccon_evo/screens/dictionary/ui/components/dictionary_welcome_box.dart';
import 'package:diccon_evo/screens/commons/no_internet_buble.dart';
import 'package:diccon_evo/screens/dictionary/ui/components/user_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/properties.dart';
import '../../../data/data_providers/searching.dart';
import '../../../data/models/translation_choices.dart';
import '../../../data/models/word.dart';
import '../../../data/repositories/thesaurus_repository.dart';
import '../ui/components/brick_wall_buttons.dart';
import '../ui/components/image_buble.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'chat_list_state.dart';
part 'chat_list_event.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc()
      : super(ChatListUpdated(chatList: [const DictionaryWelcome()])) {
    on<AddLocalTranslation>(_addLocalTranslation);
    on<AddUserMessage>(_addUserMessage);
    on<AddSorryMessage>(_addSorryMessage);
    on<AddSynonyms>(_addSynonymsList);
    on<AddAntonyms>(_addAntonymsList);
    on<AddImage>(_addImage);
    on<ScrollToBottom>(_scrollToBottom);
  }
  List<ChatGptRepository> listChatGptRepository = [];
  final ScrollController chatListController = ScrollController();
  final TextEditingController textController = TextEditingController();
  List<Widget> chatList = [const DictionaryWelcome()];
  bool isReportedAboutDisconnection = false;

  /// Implement Events and Callbacks
  Future<void> _addImage(AddImage event, Emitter<ChatListState> emit) async {
    chatList.add(ImageBubble(imageUrl: event.imageUrl));
    emit(ChatListUpdated(chatList: chatList));
    _scrollChatListToBottom();
    emit(ImageAdded());
  }

  void _addSynonymsList(AddSynonyms event, Emitter<ChatListState> emit) {
    var listSynonyms = ThesaurusRepository().getSynonyms(event.providedWord);
    chatList.add(BrickWallButtons(stringList: listSynonyms));
    emit(ChatListUpdated(chatList: chatList));
    _scrollChatListToBottom();
    emit(SynonymsAdded());
  }

  void _addAntonymsList(AddAntonyms event, Emitter<ChatListState> emit) {
    var listAntonyms = ThesaurusRepository().getAntonyms(event.providedWord);
    chatList.add(BrickWallButtons(
        textColor: Colors.orange,
        borderColor: Colors.orangeAccent,
        stringList: listAntonyms));
    emit(ChatListUpdated(chatList: chatList));
    _scrollChatListToBottom();

    emit(AntonymsAdded());
  }

  void _addSorryMessage(AddSorryMessage event, Emitter<ChatListState> emit) {
    chatList.add(const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("Sorry, we couldn't find this word at this time.")],
    ));
    emit(ChatListUpdated(chatList: chatList));
    _scrollChatListToBottom();
  }

  void _addUserMessage(AddUserMessage event, Emitter<ChatListState> emit) {
    chatList.add(UserBubble(
      message: event.providedWord,
      onTap: () {
        textController.text = event.providedWord;
      },
    ));
    emit(ChatListUpdated(chatList: chatList));
    _scrollChatListToBottom();
  }

  Future<void> _addLocalTranslation(
      AddLocalTranslation event, Emitter<ChatListState> emit) async {
    // Check internet connection before create request to chatbot
    bool isInternetConnected = await InternetConnectionChecker().hasConnection;
    if (kDebugMode) {
      print("[Internet Connection] $isInternetConnected");
    }
    if (Properties.defaultSetting.translationChoice.toTranslationChoice() ==
            TranslationChoices.ai &&
        !isInternetConnected &&
        !isReportedAboutDisconnection) {
      chatList.add(const NoInternetBubble());
      emit(ChatListUpdated(chatList: chatList));
      isReportedAboutDisconnection = true;
    }
    var newChatGptRepository = ChatGptRepository();
    listChatGptRepository.add(newChatGptRepository);
    var chatGptRepositoryIndex = listChatGptRepository.length - 1;
    var wordResult = await _getLocalTranslation(event.providedWord);
    chatList.add(CombineBubble(
        wordObjectForLocal: wordResult,
        wordForChatbot: event.providedWord,
        chatListController: chatListController,
        index: chatGptRepositoryIndex,
        listChatGptRepository: listChatGptRepository));
    emit(ChatListUpdated(chatList: chatList));
    _scrollChatListToBottom();
  }

  Future<Word> _getLocalTranslation(String providedWord) async {
    Word? wordResult = await Searching.getDefinition(providedWord);
    if (wordResult != null) {
      if (kDebugMode) {
        print("got result from local dictionary");
      }
      return wordResult;
    }
    var badResult = Word(
        word: providedWord,
        meaning:
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
