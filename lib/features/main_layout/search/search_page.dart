import 'package:eds_beta/common/circular_loading_page.dart';
import 'package:eds_beta/core/styles.dart';
import 'package:eds_beta/features/main_layout/search/results_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'search_controller.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<String> _suggestions = [];
  bool _noSuggestions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: AppStyles.paragraph2,
          onChanged: _handleInputChanges,
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search",
            border: InputBorder.none,
          ),
          onSubmitted: _handleSearch,
        ),
        actions: [
          IconButton(
            onPressed: () {
              _searchController.clear();
            },
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _isLoading ? _buildSuggestionsLoader() : _buildSuggestions(),
        ],
      ),
    );
  }

  Widget _buildSuggestionsLoader() {
    return const Center(
      child: CircularLoaderPage(
        message: "Loading suggestions",
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView(
      shrinkWrap: true,
      children: _noSuggestions
          ? [
              ListTile(
                title: const Text("No results found"),
                onTap: () {},
              ),
            ]
          : [
              for (var suggestion in _suggestions)
                ListTile(
                  leading: const Icon(Icons.north_east_sharp),
                  title: Text(suggestion, style: AppStyles.paragraph1),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ResultsPageView(
                          query: suggestion,
                          title: suggestion,
                        ),
                      ),
                    );
                  },
                ),
            ],
    );
  }

  void _handleSearch(String value) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultsPageView(
          query: value,
          title: value,
        ),
      ),
    );
  }

  void _handleInputChanges(String value) async {
    setState(() {
      _isLoading = true;
      final controller = ref.read(searchControllerProvider);
      _suggestions = controller.getSuggestions(value);
      _isLoading = false;
    });
  }
}
