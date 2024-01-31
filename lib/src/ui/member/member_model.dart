class MemberModel {
  final String tu_id;
  final String tu_name;
  final String tu_phone;
  final String tu_email;
  final String tu_step;
  final String tu_type;
  final String tu_last_access_date;
  final String si_name;

  MemberModel({
    required this.tu_id,
    required this.tu_name,
    required this.tu_phone,
    required this.tu_email,
    required this.tu_step,
    required this.tu_type,
    required this.tu_last_access_date,
    required this.si_name,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      tu_id: json['tu_id'] ?? "",
      tu_name: json['tu_name'] ?? "",
      tu_phone: json['tu_phone'] ?? "",
      tu_email: json['tu_email'] ?? "",
      tu_step: json['tu_step'] ?? "",
      tu_type: json['tu_type'] ?? "",
      tu_last_access_date: json['tu_last_access_date'] ?? "",
      si_name: json['si_name'] ?? "",
    );
  }
}
