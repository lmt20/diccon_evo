import 'package:diccon_evo/src/common/common.dart';

abstract class EnglishToVietnameseDictionaryRepository {
  Future<Word> getDefinition(String word);
  Future<List<String>> getSynonyms(String word);
  Future<List<String>> getAntonyms(String word);
}