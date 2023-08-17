
class SearchResultModel {
  String title;
  int productCount;
  String query;
  int limit;
  int currentCount;
  bool hasMore = true;

  SearchResultModel(
      {required this.title,
      required this.productCount,
      required this.query,
      this.limit = 20,
      this.currentCount = 0,
      this.hasMore = true});

  addCategoryToQuery(String category) {
    if (query.isEmpty) {
      query = 'category:$category';
    } else {
      if (query.contains('category:')) {
        String categoryQuery =
            'category$category|${query.substring(query.indexOf('category:'))}';
        query = categoryQuery;
      } else {
        query = 'category:$category&$query';
      }
    }
  }

  SearchResultModel copyWith({
    String? title,
    int? productCount,
    String? query,
    int? limit,
    int? currentCount,
  }) {
    return SearchResultModel(
      title: title ?? this.title,
      productCount: productCount ?? this.productCount,
      query: query ?? this.query,
      limit: limit ?? this.limit,
      currentCount: currentCount ?? this.currentCount,
    );
  }
}
