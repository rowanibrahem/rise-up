class UserModel {
  int? id;
  String? gender;
  final String name;
  final String email;
  final String status;

  UserModel({
    this.id,
    this.gender,
    required this.status,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'status': status,
    };
  }
}
