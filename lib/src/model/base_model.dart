class BaseModel {
  String? result;
  String? msg;

  BaseModel();

  BaseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] ?? "";
    msg = json['msg'] ?? "";
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   if (result != null) {
  //     data['data'] = result!.toJson();
  //   }
  //   return data;
  // }
}
