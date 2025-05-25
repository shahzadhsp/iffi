class UserEntity {
  final String? id;
  final String name;
  final String email;
  final String? password;

  UserEntity({this.id, required this.name, required this.email, this.password});
}
