class ProductResultData {
  String code;
  final int count;
  final String year;
  final String month;

  ProductResultData({
    this.code = "",
    this.count = 0,
    this.year = "",
    this.month = "",
  });

  @override
  String toString() {
    String result = "code:$code, count:$count, year:$year, month:$month";
    return result;
  }

  bool get isEmpty => year.isEmpty || month.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
