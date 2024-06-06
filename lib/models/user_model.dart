class UserModel {
  UserModel({
    required this.id,
    required this.username,
    required this.isAdmin,
    required this.created,
    required this.updated,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      isAdmin: json['isAdmin'],
      created: json['created'],
      updated: json['updated'],
    );
  }

  String id;
  String username;
  String isAdmin;
  String created;
  String updated;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'isAdmin': isAdmin,
      'created': created,
      'updated': updated,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? isAdmin,
    String? created,
    String? updated,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      isAdmin: isAdmin ?? this.isAdmin,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }
}
