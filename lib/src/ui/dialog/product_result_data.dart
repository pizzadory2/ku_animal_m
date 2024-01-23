class ProductResultData {
  final String code;
  final int count;
  final String year;
  final String month;

  ProductResultData({
    this.code = "",
    this.count = 0,
    this.year = "",
    this.month = "",
  });

  bool get isEmpty => code.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
