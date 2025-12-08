class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime dateOfBirth;
  final String bloodGroup;
  final String? profileImagePath;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.bloodGroup,
    this.profileImagePath,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? dateOfBirth,
    String? bloodGroup,
    String? profileImagePath,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'bloodGroup': bloodGroup,
    'profileImagePath': profileImagePath,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    dateOfBirth: DateTime.parse(
      json['dateOfBirth'] ?? DateTime.now().toIso8601String(),
    ),
    bloodGroup: json['bloodGroup'] ?? '',
    profileImagePath: json['profileImagePath'],
  );
}
