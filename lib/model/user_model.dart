class UserModel {
  String id;
  String userName;
  bool isAnonymousName;
  String email;
  String profilePhoto;
  bool isOnline;
  UserModel({
    required this.id,
    required this.userName,
    required this.isAnonymousName,
    required this.email,
    required this.profilePhoto,
    required this.isOnline,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'isAnonymousName': isAnonymousName,
      'email': email,
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
      profilePhoto: map['profilePhoto'],
      isOnline: map['isOnline'],
    );
  }
}
