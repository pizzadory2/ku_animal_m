class ProductHistoryModel {
  final String name; // 제품명
  final String company; // 제품명
  final String inoutCount;
  final String totalCount;
  final String regDate;
  final String regUser;
  final bool productIn;

  ProductHistoryModel({
    this.name = "",
    this.company = "",
    this.inoutCount = "",
    this.totalCount = "",
    this.regDate = "",
    this.regUser = "",
    this.productIn = true,
  });
}
