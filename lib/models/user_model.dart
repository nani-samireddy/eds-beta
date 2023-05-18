class UserModel {
  final String name;
  final String email;
  final String phone;
  final String uid;
  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uid,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? uid,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      uid: map['uid'] as String,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, phone: $phone, uid: $uid)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return name.hashCode ^ email.hashCode ^ phone.hashCode ^ uid.hashCode;
  }
}
