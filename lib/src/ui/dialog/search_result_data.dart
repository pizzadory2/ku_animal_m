class SearchResultData {
  final String type;
  final String txt;

  SearchResultData({
    this.type = "",
    this.txt = "",
  });

  bool get isEmpty => txt.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
