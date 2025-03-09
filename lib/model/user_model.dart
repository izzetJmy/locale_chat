class UserModel {
  String id;
  String userName;
  String email;
  String createdAt;
  bool isAnonymousName;
  String profilePhoto;
  bool isOnline;
  UserModel({
    required this.id,
    required this.userName,
    required this.isAnonymousName,
    required this.email,
    required this.profilePhoto,
    required this.isOnline,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'isAnonymousName': isAnonymousName,
      'email': email,
      'createdAt': createdAt,
      'profilePhoto': profilePhoto,
      'isOnline': isOnline,
    };
  }

  UserModel fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      userName: map['userName'],
      isAnonymousName: map['isAnonymousName'],
      email: map['email'],
      createdAt: map['createdAt'],
      profilePhoto: map['profilePhoto'],
      isOnline: map['isOnline'],
    );
  }
}
