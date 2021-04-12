class UserModel {
  final String databaseId;
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final bool adminRole;
  UserModel({this.userId,this.databaseId ,this.name, this.email, this.phoneNumber, this.password,this.adminRole});
}