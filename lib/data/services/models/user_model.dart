import 'package:iffi_store/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    String? id,
    required String name,
    required String email,
    String? password,
  }) : super(id: id, name: name, email: email, password: password);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], name: json['name'], email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}
