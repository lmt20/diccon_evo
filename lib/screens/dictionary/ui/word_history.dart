import 'dart:async';
import 'package:diccon_evo/extensions/i18n.dart';
import 'package:diccon_evo/extensions/sized_box.dart';
import 'package:diccon_evo/screens/commons/circle_button.dart';
import 'package:diccon_evo/screens/commons/header.dart';
import 'package:flutter/material.dart';
import '../../commons/notify.dart';
import '../../commons/pill_button.dart';
import '../bloc/word_history_bloc.dart';
import 'components/history_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WordHistoryView extends StatefulWidget {
  final WordHistoryBloc wordHistoryBloc;
  const WordHistoryView({super.key, required this.wordHistoryBloc});

  @override
  State<WordHistoryView> createState() => _WordHistoryViewState();
}

class _WordHistoryViewState extends State<WordHistoryView> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            BlocBuilder<WordHistoryBloc, WordHistoryState>(
              bloc: widget.wordHistoryBloc,
              builder: (context, state) {
                switch (state.runtimeType) {
                  case WordHistoryUpdated:
                    if (state.words.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(
                              image: AssetImage('assets/stickers/history.png'),
                              height: 200,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "History is empty".i18n,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox().mediumHeight(),
                            Opacity(
                              opacity: 0.5,
                              child: Text(
                                "SubSentenceInWordHistory".i18n,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 60),
                        itemCount: state.words.length,
                        itemBuilder: (context, index) {
                          final word = state.words[index];
                          return HistoryTile(
                              word: word, onEdit: state.isEdit!, wordHistoryBloc : widget.wordHistoryBloc);
                        },
                      );
                    }
                  default:
                    widget.wordHistoryBloc.add(InitialWordHistory());
                    return Container();
                }
              },
            ),
            Header(
              title: "History".i18n,
              actions: [
                IconButton(
                    onPressed: () =>
                        widget.wordHistoryBloc.add(SortAlphabetWordHistory()),
                    icon: const Icon(Icons.sort_by_alpha)),
                PopupMenuButton(
                  //splashRadius: 10.0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Reverse".i18n),
                      onTap: () =>
                          widget.wordHistoryBloc.add(SortReverseWordHistory()),
                    ),
                    const PopupMenuItem(
                      height: 0,
                      child: Divider(),
                    ),
                    PopupMenuItem(
                      child: Text("Edit".i18n),
                      onTap: () => widget.wordHistoryBloc.add(WordHistoryEditMode()),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BlocBuilder<WordHistoryBloc, WordHistoryState>(
            bloc: widget.wordHistoryBloc,
            builder: (context, state) {
          if (state.isEdit == true) {
            return BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    PillButton(
                        icon: Icons.delete_outline,
                        onTap: () {
                          Notify.showAlertDialog(
                              context: context,
                              title: "Delete History".i18n,
                              content:
                                  "AskQuestionBeforeDelete".i18n,
                              action: () {
                                widget.wordHistoryBloc.add(ClearAllWordHistory());
                                widget.wordHistoryBloc.add(CloseWordHistoryEditMode());

                              });

                        },
                        title: "Clear all".i18n),
                    const Spacer(),
                    CircleButton(
                        iconData: Icons.close,
                        onTap: () {
                          widget.wordHistoryBloc.add(CloseWordHistoryEditMode());
                        })
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ),
    );
  }
}
