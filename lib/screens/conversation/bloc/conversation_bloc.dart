import 'dart:async';
import 'package:diccon_evo/data/repositories/chat_gpt_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../ui/components/conversation_machine_bubble.dart';
import '../ui/components/conversation_user_bubble.dart';

/// Events
@immutable
abstract class ConversationEvent {}

class AskAQuestion extends ConversationEvent {
  final String providedWord;
  AskAQuestion({required this.providedWord});
}

/// State
abstract class ConversationState {}

abstract class ConversationActionState extends ConversationState {}

class ConversationInitial extends ConversationState {
  List<Widget> conversation;
  ConversationInitial({required this.conversation});
}

class ConversationUpdated extends ConversationState {
  List<Widget> conversation;
  ConversationUpdated({required this.conversation});
}

/// Bloc
class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc()
      : super(ConversationInitial(conversation: [/*const WelcomeBox()*/])) {
    on<AskAQuestion>(_addUserMessage);
  }
  final chatGptRepository = ChatGptRepository();
  List<Widget> conversation = [];

  Future<void> _addUserMessage(
      AskAQuestion event, Emitter<ConversationState> emit) async {
    conversation.add(ConversationUserBubble(message: event.providedWord));
    emit(ConversationUpdated(conversation: conversation));
    // Process and return reply
    final question = event.providedWord;
    // create gpt request
    var request = await chatGptRepository.createQuestionRequest(question);
    var answerIndex = chatGptRepository.questionAnswers.length - 1;
    conversation.add(ConversationMachineBubble(
      questionRequest: request,
      chatGptRepository: chatGptRepository,
      answerIndex: answerIndex,
    ));
    emit(ConversationUpdated(conversation: conversation));
  }
}
