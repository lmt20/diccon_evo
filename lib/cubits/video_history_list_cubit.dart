import 'package:diccon_evo/models/article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../global.dart';
import '../helpers/file_handler.dart';
import '../models/video.dart';

class VideoHistoryListCubit extends Cubit<List<Video>> {
  VideoHistoryListCubit() : super([]);

  List<Video> videos = [];

  void loadArticleHistory() async {
    videos = await FileHandler.readVideoHistory();
    emit(videos);
  }

  void sortAlphabet() {
    var sorted = videos;
    sorted.sort((a, b) => a.title.compareTo(b.title));
    emit(sorted);
  }

  void sortReverse() {
    var sorted = videos.reversed.toList();
    emit(sorted);
  }

  void clearHistory() {
    FileHandler.deleteFile(Global.VIDEO_HISTORY_FILENAME);
    videos = List.empty();
    emit(videos);
  }

  void getAll() {
    var all = videos;
    emit(all);
  }
}