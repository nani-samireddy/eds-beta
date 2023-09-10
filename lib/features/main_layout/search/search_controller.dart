import 'dart:developer';

import 'package:eds_beta/api/database_api.dart';
import 'package:eds_beta/providers/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchControllerProvider = Provider<SearchController>((ref) {
  final databaseAPI = ref.watch(databaseAPIProvider);

  return SearchController(databaseAPI: databaseAPI);
});

class SearchController {
  List<String> _tags = [];
  List<String> suggestions = [];
  bool _loading = false;
  final DatabaseAPI _databaseAPI;
  SearchController({required DatabaseAPI databaseAPI})
      : _databaseAPI = databaseAPI {
    _loadTags();
  }

  bool get isLoading => _loading;

  Future<void> _loadTags() async {
    try {
      _loading = true;
      _tags = await _databaseAPI.getTags();
      _loading = false;
    } catch (e) {
      log("Error in loadTags: $e");
      _loading = false;
    }
  }

  List<String> getSuggestions(String query) {
    log(_tags.toString());
    List<String> matches = [];
    if (!_loading) {
      matches.addAll(_tags.where((element) => element.startsWith(query)));
      matches.addAll(_tags.where(
          (element) => element.contains(query) && !matches.contains(element)));
    }
    suggestions = matches;
    return suggestions;
  }
}
