class UserModel {
  UserModelResult? result;
  String? resultMsg;
  String? msg;

  UserModel({this.result});

  UserModel.fromJson(Map<String, dynamic> json) {
    // if (json['data'] != null) {
    //   resultMsg = json['result'] ?? "";
    //   msg = json['msg'] ?? "";
    // }
    resultMsg = json['result'] ?? "";
    msg = json['msg'] ?? "";

    result = json['data'] != null ? UserModelResult.fromJson(json['data']) : null;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   if (result != null) {
  //     data['data'] = result!.toJson();
  //   }
  //   return data;
  // }
}

class UserModelResult {
  String? tu_seq;
  String? tu_id;
  String? tu_name;
  int coe = 0;

  UserModelResult({this.tu_seq, this.tu_id, this.tu_name});

  UserModelResult.fromJson(Map<String, dynamic> json) {
    tu_seq = json['tu_seq'] ?? "";
    tu_id = json['tu_id'] ?? "";
    tu_name = json['tu_name'] ?? "";
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['refreshToken'] = tokenRefresh;
  //   data['jwtToken'] = tokenJWT;
  //   data['email'] = email;
  //   data['nick'] = nick;
  //   data['grade'] = grade;
  //   data['birth'] = birth;

  //   return data;
  // }

  clear() {
    tu_seq = "";
    tu_id = "";
    tu_name = "";
  }
}
