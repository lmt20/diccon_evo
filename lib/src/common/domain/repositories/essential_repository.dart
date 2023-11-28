import 'package:diccon_evo/src/common/common.dart';

abstract class EssentialWordRepository {
  Future<List<EssentialWord>> loadEssentialData(String topic);
  Future<List<EssentialWord>> readFavouriteEssential();
  Future<bool> saveEssentialWordToFavourite(EssentialWord word);
  Future<void> removeEssentialWordOutOfFavourite(EssentialWord word);
}
